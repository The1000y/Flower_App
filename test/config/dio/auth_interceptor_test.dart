import 'package:dio/dio.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/dio/auth_interceptor.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/auth/api/service/token_refresh_service.dart';
import 'package:flower_app/features/auth/data/model/response/refresh_token_response/refresh_token_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/auth_test_helpers.dart';

/// Answers requests from a canned responder and records what was sent, so the
/// replayed request can be inspected.
class _RecordingAdapter implements HttpClientAdapter {
  _RecordingAdapter(this._responder);

  final ResponseBody Function(RequestOptions options, int callIndex)
  _responder;

  final List<RequestOptions> requests = [];

  int _callCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return _responder(options, _callCount++);
  }

  @override
  void close({bool force = false}) {}
}

/// Counts refresh attempts and returns a canned outcome, so the interceptor can
/// be exercised without the real network path.
class _SpyRefreshService extends TokenRefreshService {
  _SpyRefreshService(super.apiClient, super.storage);

  int callCount = 0;
  String? newAccessToken;

  @override
  Future<String?> refreshAccessToken() async {
    callCount++;
    return newAccessToken;
  }
}

ResponseBody _json(String body, int statusCode) {
  return ResponseBody.fromString(
    body,
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

void main() {
  group('AuthInterceptors 401 refresh', () {
    late SecureStorageService storage;
    late _SpyRefreshService refreshService;
    late _RecordingAdapter adapter;

    setUp(() async {
      await getIt.reset();
      useInMemorySecureStorage();
      storage = SecureStorageService(const FlutterSecureStorage());
      refreshService = _SpyRefreshService(FakeAuthApiClient(), storage);
      getIt.registerSingleton<SecureStorageService>(storage);
      getIt.registerSingleton<TokenRefreshService>(refreshService);
    });

    tearDown(() async => getIt.reset());

    /// Builds the Dio the app uses, with the real interceptor attached, and
    /// registers it because the interceptor replays requests through the
    /// container.
    Dio buildDio(ResponseBody Function(RequestOptions, int) responder) {
      adapter = _RecordingAdapter(responder);
      final dio = Dio(BaseOptions(baseUrl: 'http://gateway.test'))
        ..httpClientAdapter = adapter
        ..interceptors.add(AuthInterceptors());
      getIt.registerSingleton<Dio>(dio);
      return dio;
    }

    Dio expiredThenOk() => buildDio(
      (options, callIndex) => callIndex == 0
          ? _json('{"error":"expired"}', 401)
          : _json('{"ok":true}', 200),
    );

    test('refreshes the token and replays a 401 request successfully', () async {
      refreshService.newAccessToken = 'fresh-access';
      final dio = expiredThenOk();
      await storage.saveAccessToken('expired-access');

      final response = await dio.get<dynamic>('/cart/cart');

      expect(response.statusCode, 200);
      expect(refreshService.callCount, 1);
      expect(adapter.requests.length, 2);
      expect(
        adapter.requests.last.headers['Authorization'],
        'Bearer fresh-access',
      );
    });

    test('replays the original method, url, query and body', () async {
      refreshService.newAccessToken = 'fresh-access';
      final dio = expiredThenOk();
      await storage.saveAccessToken('expired-access');

      await dio.post<dynamic>(
        '/api/v1/cart/items',
        queryParameters: {'page': '1', 'size': '5'},
        data: {'productId': 'abc', 'quantity': 2},
      );

      final retried = adapter.requests.last;
      expect(adapter.requests.length, 2);
      expect(retried.method, 'POST');
      expect(retried.path, '/api/v1/cart/items');
      expect(retried.queryParameters, {'page': '1', 'size': '5'});
      expect(retried.data, {'productId': 'abc', 'quantity': 2});
    });

    test('surfaces the 401 and refreshes only once when the retry also fails',
        () async {
      refreshService.newAccessToken = 'fresh-access';
      final dio = buildDio(
        (options, callIndex) => _json('{"error":"no"}', 401),
      );
      await storage.saveAccessToken('expired-access');

      await expectLater(
        dio.get<dynamic>('/cart/cart'),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            401,
          ),
        ),
      );

      expect(refreshService.callCount, 1);
    });

    test('does not refresh on failures other than 401', () async {
      final dio = buildDio(
        (options, callIndex) => _json('{"error":"boom"}', 500),
      );
      await storage.saveAccessToken('access');

      await expectLater(
        dio.get<dynamic>('/cart/cart'),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            500,
          ),
        ),
      );

      expect(refreshService.callCount, 0);
    });

    test('does not try to refresh the refresh call itself', () async {
      final dio = buildDio(
        (options, callIndex) => _json('{"error":"no"}', 401),
      );
      await storage.saveAccessToken('expired-access');
      await storage.saveRefreshToken('stored-refresh');

      await expectLater(
        dio.post<dynamic>('/auth/refresh', data: {'token': 'stored-refresh'}),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            401,
          ),
        ),
      );

      expect(refreshService.callCount, 0);
    });

    test('surfaces the original 401 when the session cannot be renewed',
        () async {
      refreshService.newAccessToken = null;
      final dio = buildDio(
        (options, callIndex) => _json('{"error":"no"}', 401),
      );
      await storage.saveAccessToken('expired-access');

      await expectLater(
        dio.get<dynamic>('/cart/cart'),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            401,
          ),
        ),
      );

      expect(refreshService.callCount, 1);
    });

    test('attaches the stored access token to outgoing requests', () async {
      final dio = buildDio(
        (options, callIndex) => _json('{"ok":true}', 200),
      );
      await storage.saveAccessToken('stored-access');

      await dio.get<dynamic>('/cart/cart');

      expect(
        adapter.requests.single.headers['Authorization'],
        'Bearer stored-access',
      );
      expect(refreshService.callCount, 0);
    });

    test('sends no Authorization header when nothing is stored', () async {
      final dio = buildDio(
        (options, callIndex) => _json('{"ok":true}', 200),
      );

      await dio.get<dynamic>('/catalog/products');

      expect(
        adapter.requests.single.headers.containsKey('Authorization'),
        isFalse,
      );
      expect(refreshService.callCount, 0);
    });

    test('collapses a burst of 401s into a single refresh', () async {
      // The real service is used here on purpose: collapsing concurrent
      // refreshes is its job, and the spy deliberately bypasses it.
      final apiClient = FakeAuthApiClient(
        refreshResponse: const RefreshTokenResponseDto(
          accessToken: 'fresh-access',
        ),
        refreshDelay: const Duration(milliseconds: 50),
      );
      await getIt.unregister<TokenRefreshService>();
      getIt.registerSingleton<TokenRefreshService>(
        TokenRefreshService(apiClient, storage),
      );

      final dio = buildDio((options, callIndex) {
        return callIndex < 3
            ? _json('{"error":"expired"}', 401)
            : _json('{"ok":true}', 200);
      });
      await storage.saveAccessToken('expired-access');
      await storage.saveRefreshToken('stored-refresh');

      await Future.wait([
        dio.get<dynamic>('/cart/cart'),
        dio.get<dynamic>('/catalog/products'),
        dio.get<dynamic>('/cart/cart/items'),
      ]);

      expect(apiClient.refreshCallCount, 1);
    });

    test('does not log token values', () async {
      refreshService.newAccessToken = 'fresh-access';
      final dio = expiredThenOk();
      await storage.saveAccessToken('expired-access');

      final logged = <String>[];
      final original = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
        logged.add(message ?? '');
      };

      try {
        await dio.get<dynamic>('/cart/cart');
      } finally {
        debugPrint = original;
      }

      expect(logged.where((line) => line.contains('fresh-access')), isEmpty);
      expect(logged.where((line) => line.contains('expired-access')), isEmpty);
    });
  });
}

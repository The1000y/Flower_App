import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/model/user_dto.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/profile/data/repo_impl/profile_repo_imp.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileLocalDataSource extends Mock
    implements ProfileLocalDataSource {}

void main() {
  late MockProfileLocalDataSource mockDataSource;
  late ProfileRepoImp repo;

  final userDto = UserDto(
    id: 1,
    fullName: 'Nour Mohamed',
    email: 'nour@example.com',
    phoneNumber: '+201234567890',
    gender: 'female',
    role: 'user',
    status: 'active',
  );

  setUp(() {
    mockDataSource = MockProfileLocalDataSource();
    repo = ProfileRepoImp(mockDataSource);
  });

  group('ProfileRepoImp', () {
    group('getProfile - Success', () {
      test(
        'returns SuccessResponce<UserEntity> when data source succeeds',
        () async {
          when(
            () => mockDataSource.getProfile(),
          ).thenAnswer((_) async => SuccessResponce(userDto));

          final result = await repo.getProfile();

          expect(result, isA<SuccessResponce<UserEntity>>());
          verify(() => mockDataSource.getProfile()).called(1);
        },
      );

      test('maps UserDto to UserEntity correctly', () async {
        when(
          () => mockDataSource.getProfile(),
        ).thenAnswer((_) async => SuccessResponce(userDto));

        final result = await repo.getProfile();
        final success = result as SuccessResponce<UserEntity>;

        expect(success.data.id, 1);
        expect(success.data.fullName, 'Nour Mohamed');
        expect(success.data.email, 'nour@example.com');
        expect(success.data.phoneNumber, '+201234567890');
        expect(success.data.gender, 'female');
        expect(success.data.role, 'user');
        expect(success.data.status, 'active');
      });

      test('handles null nullable fields (photoUrl) correctly', () async {
        final dtoNoPhoto = UserDto(
          id: 2,
          fullName: 'Sara',
          email: 'sara@test.com',
          phoneNumber: '+20000000000',
          gender: 'female',
          role: 'user',
          status: 'active',
          photoUrl: null,
        );
        when(
          () => mockDataSource.getProfile(),
        ).thenAnswer((_) async => SuccessResponce(dtoNoPhoto));

        final result = await repo.getProfile();
        final success = result as SuccessResponce<UserEntity>;

        expect(success.data.photoUrl, isNull);
      });
    });

    group('getProfile - Error', () {
      test('returns ErrorResponce when data source returns error', () async {
        when(() => mockDataSource.getProfile()).thenAnswer(
          (_) async => ErrorResponce<UserDto>(Exception('User not found')),
        );

        final result = await repo.getProfile();

        expect(result, isA<ErrorResponce<UserEntity>>());
      });

      test('forwards the error message from data source', () async {
        when(() => mockDataSource.getProfile()).thenAnswer(
          (_) async =>
              ErrorResponce<UserDto>(Exception('Storage not available')),
        );

        final result = await repo.getProfile();
        final error = result as ErrorResponce<UserEntity>;

        expect(error.errorMessage, isNotEmpty);
      });
    });

    // The repository is the layer that guarantees "failures are values": the
    // data source can throw, and every caller (use case, view model) must still
    // receive an `ErrorResponce` rather than an exception.
    group('getProfile - data source throws', () {
      test('converts the throw into an ErrorResponce', () async {
        when(
          () => mockDataSource.getProfile(),
        ).thenThrow(Exception('Storage not available'));

        final result = await repo.getProfile();

        expect(result, isA<ErrorResponce<UserEntity>>());
      });

      test('never rethrows to the caller', () async {
        when(
          () => mockDataSource.getProfile(),
        ).thenThrow(Exception('Storage not available'));

        await expectLater(repo.getProfile(), completes);
      });

      test('handles a non-Exception throw', () async {
        when(() => mockDataSource.getProfile()).thenThrow('a bare string');

        final result = await repo.getProfile();

        expect(result, isA<ErrorResponce<UserEntity>>());
        expect((result as ErrorResponce<UserEntity>).errorMessage, isNotEmpty);
      });

      test('propagates the original error through the response', () async {
        when(
          () => mockDataSource.getProfile(),
        ).thenThrow(Exception('Storage not available'));

        final result = await repo.getProfile();
        final error = result as ErrorResponce<UserEntity>;

        expect(error.error, isA<Exception>());
        expect(error.errorMessage, isNotEmpty);
      });
    });
  });

  group('ProfileRepo contract', () {
    test('the implementation satisfies the interface', () {
      // `ProfileRepo` is an `abstract interface class`, so the implementation
      // must use `implements`; a compile-time assignment is the guarantee.
      final ProfileRepo contract = repo;
      expect(contract, same(repo));
    });
  });
}

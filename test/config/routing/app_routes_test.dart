import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/routing/app_routes.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/locale/app_language.dart';
import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/show_profile_usecase.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/view/notification_view.dart';
import 'package:flower_app/features/search/domain/usecases/search_products_use_case.dart';
import 'package:flower_app/features/search/presentation/manger/cubit/search_cubit.dart';
import 'package:flower_app/features/search/presentation/view/search_view.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockRemoteMessage extends Mock implements RemoteMessage {}

class MockShowProfileUsecase extends Mock implements ShowProfileUsecase {}

class MockSearchProductsUseCase extends Mock implements SearchProductsUseCase {}

/// A real [ProfileViewModel] backed by a stubbed use case, so the route can be
/// pumped without a full cubit mock.
ProfileViewModel buildProfileViewModel() {
  final usecase = MockShowProfileUsecase();
  when(
    () => usecase.getProfile(),
  ).thenAnswer((_) async => ErrorResponce<UserEntity>(Exception('no profile')));
  return ProfileViewModel(usecase);
}

void main() {
  Route<dynamic> build(String name, {Object? arguments}) {
    return AppRoutes.onGenerateRoute(
      RouteSettings(name: name, arguments: arguments),
    );
  }

  Future<void> pumpRoute(WidgetTester tester, Route<dynamic> route) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final localeCubit = LocaleCubit(await SharedPreferences.getInstance());
    addTearDown(localeCubit.close);

    await tester.pumpWidget(
      // LocaleCubit is provided above the navigator by the app root in
      // production, so the harness mirrors that here.
      BlocProvider<LocaleCubit>.value(
        value: localeCubit,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateRoute: (_) => route,
        ),
      ),
    );
  }

  group('AppRoutes route generator', () {
    test('no longer takes factory parameters', () {
      // The factories were removed so the container is consulted in one place.
      // This is a compile-time guarantee: `onGenerateRoute` takes only the
      // settings, so a caller cannot reintroduce a factory seam.
      expect(
        AppRoutes.onGenerateRoute,
        isA<Route<Object?> Function(RouteSettings)>(),
      );
    });

    test('has no case for the profile route', () {
      // The profile is a bottom-navigation tab, not a pushed route. An unknown
      // name must therefore fall through to the "not found" page.
      final route = build(Routes.profile);
      expect(route, isA<MaterialPageRoute<Object?>>());
    });
  });

  group('AppRoutes notification route', () {
    testWidgets('passes a RemoteMessage argument through to the view', (
      tester,
    ) async {
      final message = MockRemoteMessage();
      when(() => message.notification).thenReturn(null);

      await pumpRoute(tester, build(Routes.notification, arguments: message));

      final view = tester.widget<NotificationView>(
        find.byType(NotificationView),
      );
      expect(view.message, same(message));
    });

    testWidgets('passes null when no argument is supplied', (tester) async {
      await pumpRoute(tester, build(Routes.notification));

      final view = tester.widget<NotificationView>(
        find.byType(NotificationView),
      );
      expect(view.message, isNull);
    });

    testWidgets('passes null for a non-RemoteMessage argument', (tester) async {
      await pumpRoute(
        tester,
        build(Routes.notification, arguments: 'not-a-message'),
      );

      final view = tester.widget<NotificationView>(
        find.byType(NotificationView),
      );
      expect(view.message, isNull);
    });
  });

  group('AppRoutes search route', () {
    // The cubit is owned by the `BlocProvider` the route creates, so the
    // container is reset rather than unregistered to avoid disposing twice.
    setUp(
      () => getIt.registerSingleton<SearchCubit>(
        SearchCubit(MockSearchProductsUseCase()),
      ),
    );
    tearDown(() => getIt.reset());

    testWidgets('resolves the SearchCubit from the container', (tester) async {
      await pumpRoute(tester, build(Routes.search));
      await tester.pump();

      expect(find.byType(SearchView), findsOneWidget);
      // Read through the built tree to confirm the cubit is actually provided
      // to SearchView, not merely created.
      final provided = BlocProvider.of<SearchCubit>(
        tester.element(find.byType(SearchView)),
        listen: false,
      );
      expect(provided, same(getIt<SearchCubit>()));
    });

    testWidgets('renders no "unavailable" placeholder any more', (
      tester,
    ) async {
      // The placeholder only existed because the route could not resolve its
      // cubit. The container lookup cannot fail, so the guard is gone.
      await pumpRoute(tester, build(Routes.search));
      await tester.pump();

      expect(find.text('Search is unavailable'), findsNothing);
    });
  });

  group('AppRoutes unknown routes', () {
    testWidgets('renders a "Route Not Found" page', (tester) async {
      await pumpRoute(tester, build('/does-not-exist'));

      expect(find.text('Route Not Found'), findsOneWidget);
    });

    testWidgets(
      'renders a "Route Not Found" page for the removed profile route',
      (tester) async {
        await pumpRoute(tester, build(Routes.profile));

        expect(find.text('Route Not Found'), findsOneWidget);
      },
    );
  });

  group('AppLanguage', () {
    test('exposes a locale for each language', () {
      expect(AppLanguage.english.locale.languageCode, 'en');
      expect(AppLanguage.arabic.locale.languageCode, 'ar');
    });

    test('answers isArabic without a string comparison at the call site', () {
      expect(AppLanguage.arabic.isArabic, isTrue);
      expect(AppLanguage.english.isArabic, isFalse);
    });

    test('resolves persisted codes and falls back for unknown values', () {
      expect(AppLanguage.fromLanguageCode('ar'), AppLanguage.arabic);
      expect(AppLanguage.fromLanguageCode('en'), AppLanguage.english);
      expect(AppLanguage.fromLanguageCode('fr'), AppLanguage.english);
      expect(AppLanguage.fromLanguageCode(null), AppLanguage.english);
    });
  });
}

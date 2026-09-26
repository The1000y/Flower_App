import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/config/routing/app_routes.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/show_profile_usecase.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_view_model_factory.dart';
import 'package:flower_app/features/profile/presentation/view/notification_view.dart';
import 'package:flower_app/features/profile/presentation/view/profile_view.dart';
import 'package:flower_app/features/search/domain/usecases/search_products_use_case.dart';
import 'package:flower_app/features/search/presentation/manger/cubit/search_cubit.dart';
import 'package:flower_app/features/search/presentation/manger/cubit/search_cubit_factory.dart';
import 'package:flower_app/features/search/presentation/view/search_view.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeProfileViewModelFactory implements ProfileViewModelFactory {
  _FakeProfileViewModelFactory(this._viewModel);

  final ProfileViewModel _viewModel;

  int createCount = 0;

  @override
  ProfileViewModel create() {
    createCount++;
    return _viewModel;
  }
}

class _FakeSearchCubitFactory implements SearchCubitFactory {
  _FakeSearchCubitFactory(this._cubit);

  final SearchCubit _cubit;

  int createCount = 0;

  @override
  SearchCubit create() {
    createCount++;
    return _cubit;
  }
}

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
  Route<dynamic> build(
    String name, {
    Object? arguments,
    ProfileViewModelFactory? factory,
    SearchCubitFactory? searchFactory,
  }) {
    return AppRoutes.onGenerateRoute(
      RouteSettings(name: name, arguments: arguments),
      profileViewModelFactory: factory,
      searchCubitFactory: searchFactory,
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

  group('AppRoutes profile route', () {
    testWidgets('resolves the ProfileViewModel from the injected factory', (
      tester,
    ) async {
      final viewModel = buildProfileViewModel();
      addTearDown(viewModel.close);
      final factory = _FakeProfileViewModelFactory(viewModel);

      await pumpRoute(tester, build(Routes.profile, factory: factory));
      await tester.pump();

      expect(factory.createCount, 1);
    });

    testWidgets('renders the profile view for the profile route', (
      tester,
    ) async {
      final viewModel = buildProfileViewModel();
      addTearDown(viewModel.close);
      final factory = _FakeProfileViewModelFactory(viewModel);

      await pumpRoute(tester, build(Routes.profile, factory: factory));
      await tester.pump();

      expect(find.byType(ProfileView), findsOneWidget);
    });

    testWidgets('renders a placeholder when no factory is supplied', (
      tester,
    ) async {
      await pumpRoute(tester, build(Routes.profile));
      await tester.pump();

      expect(find.byType(ProfileView), findsNothing);
      expect(find.text('Profile is unavailable'), findsOneWidget);
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
    testWidgets('provides the SearchCubit supplied by the factory', (
      tester,
    ) async {
      final cubit = SearchCubit(MockSearchProductsUseCase());
      addTearDown(cubit.close);
      final factory = _FakeSearchCubitFactory(cubit);

      await pumpRoute(tester, build(Routes.search, searchFactory: factory));
      await tester.pump();

      expect(factory.createCount, 1);
      // Read through the built tree to confirm the cubit is actually provided
      // to SearchView, not merely created.
      expect(find.byType(SearchView), findsOneWidget);
      final provided = BlocProvider.of<SearchCubit>(
        tester.element(find.byType(SearchView)),
        listen: false,
      );
      expect(provided, same(cubit));
    });

    testWidgets('renders a placeholder when no factory is supplied', (
      tester,
    ) async {
      await pumpRoute(tester, build(Routes.search));
      await tester.pump();

      expect(find.text('Search is unavailable'), findsOneWidget);
    });
  });

  group('AppRoutes unknown routes', () {
    testWidgets('renders a "Route Not Found" page', (tester) async {
      await pumpRoute(tester, build('/does-not-exist'));

      expect(find.text('Route Not Found'), findsOneWidget);
    });
  });
}

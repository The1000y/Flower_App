import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_state.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockProfileViewModel extends MockCubit<ProfileState>
    implements ProfileViewModel {}

void main() {
  late MockProfileViewModel mockViewModel;
  late LocaleCubit localeCubit;

  const testUser = UserEntity(
    id: 1,
    fullName: 'Nour Mohamed',
    email: 'nour@example.com',
    phoneNumber: '+201234567890',
    gender: 'female',
    role: 'user',
    status: 'active',
  );

  setUpAll(() {
    registerFallbackValue(GetProfileIntent());
  });

  /// The profile body is a scroll view taller than the default 600px test
  /// surface, so the surface is enlarged to make every option tappable.
  void useTallSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1000, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  setUp(() async {
    mockViewModel = MockProfileViewModel();
    SharedPreferences.setMockInitialValues(<String, Object>{});
    localeCubit = LocaleCubit(await SharedPreferences.getInstance());
    when(() => mockViewModel.doIntent(any())).thenReturn(null);
  });

  tearDown(() => localeCubit.close());

  Widget wrapWidget(ProfileState state, {NavigatorObserver? observer}) {
    whenListen(
      mockViewModel,
      Stream<ProfileState>.value(state),
      initialState: state,
    );

    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorObservers: [?observer],
      onGenerateRoute: (settings) => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const Scaffold(body: Text('placeholder route')),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ProfileViewModel>.value(value: mockViewModel),
          BlocProvider<LocaleCubit>.value(value: localeCubit),
        ],
        child: const ProfileView(),
      ),
    );
  }

  testWidgets('renders loading indicator when isLoading is true', (
    tester,
  ) async {
    await tester.pumpWidget(wrapWidget(const ProfileState(isLoading: true)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders user profile info and options when data is present', (
    tester,
  ) async {
    await tester.pumpWidget(wrapWidget(const ProfileState(data: testUser)));
    await tester.pump();

    expect(find.text('Nour Mohamed'), findsOneWidget);
    expect(find.text('nour@example.com'), findsOneWidget);
    expect(find.text('Flowery'), findsOneWidget);
    expect(find.text('My orders'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Notification'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets(
    'renders error message when errorMessage is present and data is null',
    (tester) async {
      await tester.pumpWidget(
        wrapWidget(const ProfileState(errorMessage: 'Failed to load profile')),
      );
      await tester.pump();

      expect(find.text('Failed to load profile'), findsOneWidget);
    },
  );

  testWidgets('surfaces the error as a banner when data is also present', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapWidget(
        const ProfileState(data: testUser, errorMessage: 'Refresh failed'),
      ),
    );
    await tester.pump();

    // The error must not be swallowed just because data exists.
    expect(find.text('Refresh failed'), findsOneWidget);
    expect(find.text('Nour Mohamed'), findsOneWidget);
  });

  testWidgets('dispatches GetProfileIntent upon mounting', (tester) async {
    await tester.pumpWidget(wrapWidget(const ProfileState(data: testUser)));
    await tester.pump();

    verify(
      () => mockViewModel.doIntent(any(that: isA<GetProfileIntent>())),
    ).called(1);
  });

  group('logout flow', () {
    Future<void> openLogoutDialog(WidgetTester tester) async {
      useTallSurface(tester);
      await tester.pumpWidget(wrapWidget(const ProfileState(data: testUser)));
      await tester.pump();

      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();
    }

    testWidgets('tapping Logout shows the dialog without logging out yet', (
      tester,
    ) async {
      await openLogoutDialog(tester);

      expect(find.byKey(logoutDialogKey), findsOneWidget);
      verifyNever(() => mockViewModel.doIntent(any(that: isA<LogoutIntent>())));
    });

    testWidgets('the dialog shows the localized title and confirmation text', (
      tester,
    ) async {
      await openLogoutDialog(tester);

      final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
      expect(dialog.title, isA<Text>());
      expect((dialog.title! as Text).data, 'Logout');
      expect(dialog.content, isA<Text>());
    });

    testWidgets('Cancel closes the dialog without confirming logout', (
      tester,
    ) async {
      await openLogoutDialog(tester);
      expect(find.byKey(logoutDialogKey), findsOneWidget);

      await tester.tap(
        find.text(
          AppLocalizations.of(
            tester.element(find.byType(AlertDialog)),
          )!.actionCancel,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(logoutDialogKey), findsNothing);
      verifyNever(() => mockViewModel.doIntent(any(that: isA<LogoutIntent>())));
    });

    testWidgets('Logout closes the dialog and dispatches LogoutIntent', (
      tester,
    ) async {
      await openLogoutDialog(tester);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Logout'));
      await tester.pumpAndSettle();

      expect(find.byKey(logoutDialogKey), findsNothing);
      verify(
        () => mockViewModel.doIntent(any(that: isA<LogoutIntent>())),
      ).called(1);
    });
  });

  group('edit profile flow', () {
    testWidgets('tapping the edit icon dispatches EditProfileIntent', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWidget(const ProfileState(data: testUser)));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pump();

      verify(
        () => mockViewModel.doIntent(any(that: isA<EditProfileIntent>())),
      ).called(1);
    });
  });

  group('notification flow', () {
    testWidgets('tapping the bell dispatches NotificationIntent', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWidget(const ProfileState(data: testUser)));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.notifications_none_outlined));
      await tester.pump();

      verify(
        () => mockViewModel.doIntent(any(that: isA<NotificationIntent>())),
      ).called(1);
    });
  });

  group('language flow', () {
    testWidgets('tapping Language opens the bottom sheet', (tester) async {
      useTallSurface(tester);
      await tester.pumpWidget(wrapWidget(const ProfileState(data: testUser)));
      await tester.pump();

      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
    });
  });

  group('navigation', () {
    testWidgets('edit icon pushes Routes.editProfile', (tester) async {
      final observer = _RouteNameObserver();
      await tester.pumpWidget(
        wrapWidget(const ProfileState(data: testUser), observer: observer),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      expect(observer.pushedNames, contains(Routes.editProfile));
    });

    testWidgets('bell icon pushes Routes.notification', (tester) async {
      final observer = _RouteNameObserver();
      await tester.pumpWidget(
        wrapWidget(const ProfileState(data: testUser), observer: observer),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.notifications_none_outlined));
      await tester.pumpAndSettle();

      expect(observer.pushedNames, contains(Routes.notification));
    });
  });
}

class _RouteNameObserver extends NavigatorObserver {
  final List<String?> pushedNames = <String?>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedNames.add(route.settings.name);
    super.didPush(route, previousRoute);
  }
}

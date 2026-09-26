import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_state.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_viewModel.dart';
import 'package:flower_app/features/profile/presentation/view/profile_view.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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

  setUp(() {
    mockViewModel = MockProfileViewModel();
    localeCubit = LocaleCubit();
    when(() => mockViewModel.doIntent(any())).thenReturn(null);
  });

  Widget wrapWidget(ProfileState state) {
    whenListen(
      mockViewModel,
      Stream<ProfileState>.value(state),
      initialState: state,
    );

    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ProfileViewModel>.value(value: mockViewModel),
          BlocProvider<LocaleCubit>.value(value: localeCubit),
        ],
        child: const ProfileView(),
      ),
    );
  }

  testWidgets('renders loading indicator when isLoading is true', (tester) async {
    await tester.pumpWidget(wrapWidget(const ProfileState(isLoading: true)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders user profile info and options when data is present',
      (tester) async {
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

  testWidgets('renders error message when errorMessage is present and data is null',
      (tester) async {
    await tester.pumpWidget(
      wrapWidget(const ProfileState(errorMessage: 'Failed to load profile')),
    );
    await tester.pump();

    expect(find.text('Failed to load profile'), findsOneWidget);
  });

  testWidgets('dispatches GetProfileIntent upon mounting', (tester) async {
    await tester.pumpWidget(wrapWidget(const ProfileState(data: testUser)));
    await tester.pump();

    verify(() => mockViewModel.doIntent(any(that: isA<GetProfileIntent>()))).called(1);
  });
}

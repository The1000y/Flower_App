import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/shared/app_widgets/profile_tab.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/show_profile_usecase.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockShowProfileUsecase extends Mock implements ShowProfileUsecase {}

ProfileViewModel buildViewModel() {
  final usecase = MockShowProfileUsecase();
  when(
    () => usecase.getProfile(),
  ).thenAnswer((_) async => ErrorResponce<UserEntity>(Exception('no profile')));
  return ProfileViewModel(usecase);
}

void main() {
  // The full bar cannot be pumped in isolation: `HomeView` and `CategoriesView`
  // resolve their own cubits from the service locator, which is outside this
  // module's scope. So the profile tab is built directly, which is exactly the
  // widget under test.
  group('ProfileTab', () {
    // `getIt` is process-wide, so each test registers its own view model and
    // the whole container is reset afterwards. `reset()` is preferred over
    // `unregister` because the instance is also owned by the `BlocProvider`
    // under test, and disposing it from two places deadlocks.
    setUp(() => getIt.registerSingleton<ProfileViewModel>(buildViewModel()));
    tearDown(() => getIt.reset());

    testWidgets('provides its own ProfileViewModel and renders ProfileView', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileTab()));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(ProfileView), findsOneWidget);
    });

    testWidgets('the resolved view model is the one the view reads from', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileTab()));
      await tester.pump();

      final provided = BlocProvider.of<ProfileViewModel>(
        tester.element(find.byType(ProfileView)),
        listen: false,
      );
      expect(provided, isA<ProfileViewModel>());
      expect(provided, same(getIt<ProfileViewModel>()));
    });

    testWidgets('closes the view model when the tab is disposed', (
      tester,
    ) async {
      final viewModel = getIt<ProfileViewModel>();

      await tester.pumpWidget(const MaterialApp(home: ProfileTab()));
      await tester.pump();
      expect(viewModel.isClosed, isFalse);

      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

      // `BlocProvider(create: ...)` owns the instance, so it must be closed
      // rather than left dangling.
      expect(viewModel.isClosed, isTrue);
    });
  });
}

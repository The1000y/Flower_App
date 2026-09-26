import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/core/shared/app_widgets/bottom_navigation_bar.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/show_profile_usecase.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/view/profile_view.dart';
import 'package:flutter/material.dart';
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
  // module's scope. So the tab content is built directly, which is exactly the
  // expression under test.
  group('bottom navigation profile tab resolution', () {
    testWidgets('supplied view model renders ProfileView without a provider', (
      tester,
    ) async {
      final viewModel = buildViewModel();
      addTearDown(viewModel.close);

      final screen = PersistenBottomNavBarDemo.resolveProfileTab(viewModel);

      await tester.pumpWidget(MaterialApp(home: screen));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(ProfileView), findsOneWidget);
    });

    testWidgets('a null view model renders a placeholder instead of throwing', (
      tester,
    ) async {
      // Regression test: the previous eager `?? context.read<ProfileViewModel>()`
      // fallback threw ProviderNotFoundException with no ancestor provider.
      final screen = PersistenBottomNavBarDemo.resolveProfileTab(null);

      await tester.pumpWidget(MaterialApp(home: screen));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(ProfileView), findsNothing);
      expect(find.text('Profile is unavailable'), findsOneWidget);
    });
  });
}

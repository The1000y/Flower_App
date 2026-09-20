import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:flower_app/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:flower_app/features/profile/domain/use_case/update_profile_use_case.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeProfileRepo implements ProfileRepo {
  final BaseResponce<ProfileEntity> getProfileResponse;
  final BaseResponce<ProfileEntity> updateProfileResponse;
  int updateCallCount = 0;

  FakeProfileRepo({
    required this.getProfileResponse,
    required this.updateProfileResponse,
  });

  @override
  Future<BaseResponce<ProfileEntity>> getProfile() async => getProfileResponse;

  @override
  Future<BaseResponce<ProfileEntity>> updateProfile(
    ProfileEntity profile,
  ) async {
    updateCallCount++;
    return updateProfileResponse;
  }
}

void main() {
  final testEntity = const ProfileEntity(
    firstName: 'Sara',
    lastName: 'Ahmed',
    email: 'sara.ahmed@example.com',
    phoneNumber: '+201000000000',
    gender: 'Female',
  );

  Widget createWidgetUnderTest(FakeProfileRepo fakeRepo) {
    return ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        home: BlocProvider<ProfileViewModel>(
          create: (_) => ProfileViewModel(
            GetProfileUseCase(fakeRepo),
            UpdateProfileUseCase(fakeRepo),
          ),
          child: const ProfileView(),
        ),
      ),
    );
  }

  testWidgets('Shows a CircularProgressIndicator while the profile is loading', (
    tester,
  ) async {
    final fakeRepo = FakeProfileRepo(
      getProfileResponse: SuccessResponce(testEntity),
      updateProfileResponse: SuccessResponce(testEntity),
    );

    await tester.pumpWidget(createWidgetUnderTest(fakeRepo));
    
    // Initial pump shows the loading indicator triggered by initState FetchProfileEvent
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets(
    'After pumpAndSettle, the text fields are filled with the entity values',
    (tester) async {
      final fakeRepo = FakeProfileRepo(
        getProfileResponse: SuccessResponce(testEntity),
        updateProfileResponse: SuccessResponce(testEntity),
      );

      await tester.pumpWidget(createWidgetUnderTest(fakeRepo));
      await tester.pumpAndSettle();

      expect(find.text('Sara'), findsOneWidget);
      expect(find.text('Ahmed'), findsOneWidget);
      expect(find.text('sara.ahmed@example.com'), findsOneWidget);
      expect(find.text('+201000000000'), findsOneWidget);
    },
  );

  testWidgets(
    'Tapping the Update button calls updateProfile on the fake repo and shows a SnackBar',
    (tester) async {
      final fakeRepo = FakeProfileRepo(
        getProfileResponse: SuccessResponce(testEntity),
        updateProfileResponse: SuccessResponce(testEntity),
      );

      await tester.pumpWidget(createWidgetUnderTest(fakeRepo));
      await tester.pumpAndSettle();

      expect(find.text('Update'), findsOneWidget);
      await tester.ensureVisible(find.text('Update'));
      
      // Tap the button
      await tester.tap(find.text('Update'));
      await tester.pump(); // Start the update
      await tester.pumpAndSettle(); // Finish the update and SnackBar animation

      expect(fakeRepo.updateCallCount, 1);
      expect(find.text('Profile updated'), findsWidgets);
    },
  );

  testWidgets(
    'When getProfile returns an error, a SnackBar with the error message appears',
    (tester) async {
      final fakeRepo = FakeProfileRepo(
        getProfileResponse: ErrorResponce(Exception('Network failure')),
        updateProfileResponse: SuccessResponce(testEntity),
      );

      await tester.pumpWidget(createWidgetUnderTest(fakeRepo));
      await tester.pump(); // state emission
      await tester.pumpAndSettle(); // snackbar animation

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Exception: Network failure'), findsWidgets);
    },
  );
}
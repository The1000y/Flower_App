import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/services/image_picker_service.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:flower_app/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:flower_app/features/profile/domain/use_case/update_profile_use_case.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/view/update_profile_view.dart';
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

class FakeImagePickerService implements ImagePickerService {
  @override
  Future<String?> pickFromGallery() async => null;
}

void main() {
  const testEntity = ProfileEntity(
    firstName: 'Sara',
    lastName: 'Ahmed',
    email: 'sara.ahmed@example.com',
    phoneNumber: '01000000000',
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
            FakeImagePickerService(),
          ),
          child: const UpdateProfileView(),
        ),
      ),
    );
  }

  testWidgets('Shows a CircularProgressIndicator while the profile is loading',
          (tester) async {
        final fakeRepo = FakeProfileRepo(
          getProfileResponse: SuccessResponce(testEntity),
          updateProfileResponse: SuccessResponce(testEntity),
        );

        await tester.pumpWidget(createWidgetUnderTest(fakeRepo));

        // Initial pump shows the loading indicator triggered by initState FetchProfileEvent
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pumpAndSettle();
      });

  testWidgets('After loading, the text fields are filled with the entity values',
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
        expect(find.text('01000000000'), findsOneWidget);
      });

  testWidgets('The Update button is disabled when nothing has changed',
          (tester) async {
        final fakeRepo = FakeProfileRepo(
          getProfileResponse: SuccessResponce(testEntity),
          updateProfileResponse: SuccessResponce(testEntity),
        );

        await tester.pumpWidget(createWidgetUnderTest(fakeRepo));
        await tester.pumpAndSettle();

        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.onPressed, isNull);
      });

  testWidgets(
      'After editing a field, tapping Update calls updateProfile and shows a SnackBar',
          (tester) async {
        final fakeRepo = FakeProfileRepo(
          getProfileResponse: SuccessResponce(testEntity),
          updateProfileResponse: SuccessResponce(testEntity),
        );

        await tester.pumpWidget(createWidgetUnderTest(fakeRepo));
        await tester.pumpAndSettle();

        // First TextFormField is the first name; editing it enables the Update button
        await tester.enterText(find.byType(TextFormField).first, 'Mona');
        await tester.pump();

        final updateFinder = find.text(AppStrings.actionUpdate);
        await tester.ensureVisible(updateFinder);
        await tester.tap(updateFinder);
        await tester.pump(); // start the update
        await tester.pumpAndSettle(); // finish the update and SnackBar animation

        expect(fakeRepo.updateCallCount, 1);
        expect(find.text(AppStrings.profileUpdated), findsWidgets);
      });

  testWidgets('When getProfile returns an error, a SnackBar with the error message appears',
          (tester) async {
        final error = ErrorResponce<ProfileEntity>(Exception('Network failure'));
        final fakeRepo = FakeProfileRepo(
          getProfileResponse: error,
          updateProfileResponse: SuccessResponce(testEntity),
        );

        await tester.pumpWidget(createWidgetUnderTest(fakeRepo));
        await tester.pump(); // state emission
        await tester.pumpAndSettle(); // snackbar animation

        expect(find.byType(SnackBar), findsOneWidget);
        // Uses the message the error handler actually produces, not a hardcoded string
        expect(find.text(error.errorMessage), findsWidgets);
      });
}
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/core/services/image_picker_service.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:flower_app/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:flower_app/features/profile/domain/use_case/update_profile_use_case.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_state.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_view_model.dart';
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

class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({super.key});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final ValueNotifier<bool> _isFemaleNotifier = ValueNotifier<bool>(true);

  ProfileEntity? _loadedProfile;

  @override
  void initState() {
    super.initState();
    context.read<ProfileViewModel>().doEvent(FetchProfileEvent());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _isFemaleNotifier.dispose();
    super.dispose();
  }

  void _fillFieldsFrom(ProfileEntity profile) {
    _loadedProfile = profile;
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phoneNumber;
    _isFemaleNotifier.value = profile.gender.toLowerCase() == 'female';
  }

  void _onUpdatePressed(BuildContext context) {
    if (_loadedProfile == null) return;

    context.read<ProfileViewModel>().doEvent(
      UpdateProfileEvent(
        profile: ProfileEntity(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          gender: _isFemaleNotifier.value ? 'Female' : 'Male',
          photoUrl: _loadedProfile!.photoUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileViewModel, ProfileState>(
      listenWhen: (previous, current) =>
          previous.profileState != current.profileState ||
          previous.updateProfileState != current.updateProfileState,
      listener: (context, state) {
        if (state.profileState.data != null && _loadedProfile == null) {
          setState(() => _fillFieldsFrom(state.profileState.data!));
        }
        if (state.profileState.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.profileState.errorMessage),
                backgroundColor: AppColors.error,
              ),
            );
        }
        if (state.updateProfileState.data != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Profile updated')));
        }
        if (state.updateProfileState.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.updateProfileState.errorMessage),
                backgroundColor: AppColors.error,
              ),
            );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteBase,
        appBar: AppBar(title: const Text('Edit profile')),
        body: BlocBuilder<ProfileViewModel, ProfileState>(
          builder: (context, state) {
            if (state.profileState.isLoading && _loadedProfile == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(labelText: 'First name'),
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Last name'),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone number'),
                    ),
                    ElevatedButton(
                      onPressed: () => _onUpdatePressed(context),
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  final testEntity = const ProfileEntity(
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
      expect(find.text('01000000000'), findsOneWidget);
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
      expect(find.text('something went wrong, pls try again'), findsWidgets);
    },
  );
}
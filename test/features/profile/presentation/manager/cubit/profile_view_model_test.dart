import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/core/services/image_picker_service.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:flower_app/features/profile/domain/use_case/update_profile_use_case.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_state.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}

class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

class MockImagePickerService extends Mock implements ImagePickerService {}

class FakeProfileEntity extends Fake implements ProfileEntity {}

void main() {
  late MockGetProfileUseCase mockGetProfile;
  late MockUpdateProfileUseCase mockUpdateProfile;
  late MockImagePickerService mockImagePicker;
  late ProfileViewModel viewModel;

  const tProfile = ProfileEntity(
    firstName: 'Nour',
    lastName: 'Mohamed',
    email: 'nour@example.com',
    phoneNumber: '+201234567890',
    gender: 'female',
  );

  const tUpdate = ProfileEntity(
    firstName: 'Jane',
    lastName: 'Doe',
    email: 'jane@example.com',
    phoneNumber: '01000000000',
    gender: 'Female',
    photoUrl: '/tmp/picked.png',
  );

  setUpAll(() => registerFallbackValue(FakeProfileEntity()));

  setUp(() {
    mockGetProfile = MockGetProfileUseCase();
    mockUpdateProfile = MockUpdateProfileUseCase();
    mockImagePicker = MockImagePickerService();
    viewModel = ProfileViewModel(
      mockGetProfile,
      mockUpdateProfile,
      mockImagePicker,
    );
  });

  tearDown(() => viewModel.close());

  test('initial state should be ProfileState()', () {
    expect(viewModel.state, equals(const ProfileState()));
  });

  group('FetchProfileEvent', () {
    blocTest<ProfileViewModel, ProfileState>(
      'emits [isLoading: true, data: tProfile] when the profile loads',
      build: () {
        when(() => mockGetProfile.call())
            .thenAnswer((_) async => SuccessResponce<ProfileEntity>(tProfile));
        return viewModel;
      },
      act: (cubit) => cubit.doEvent(FetchProfileEvent()),
      expect: () => [
        const ProfileState(
          profileState: BaseState<ProfileEntity>(isLoading: true),
        ),
        const ProfileState(
          profileState: BaseState<ProfileEntity>(data: tProfile),
        ),
      ],
      verify: (_) => verify(() => mockGetProfile.call()).called(1),
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits the error message when the use case fails',
      build: () {
        when(() => mockGetProfile.call()).thenAnswer(
          (_) async => ErrorResponce<ProfileEntity>(Exception('offline')),
        );
        return viewModel;
      },
      act: (cubit) => cubit.doEvent(FetchProfileEvent()),
      expect: () => [
        const ProfileState(
          profileState: BaseState<ProfileEntity>(isLoading: true),
        ),
        isA<ProfileState>()
            .having((s) => s.profileState.isLoading, 'isLoading', isFalse)
            .having(
              (s) => s.profileState.errorMessage,
              'errorMessage',
              isNotEmpty,
            )
            .having((s) => s.profileState.data, 'data', isNull),
      ],
    );
  });

  group('PickProfileImageEvent', () {
    blocTest<ProfileViewModel, ProfileState>(
      'stores the picked image path',
      build: () {
        when(() => mockImagePicker.pickFromGallery())
            .thenAnswer((_) async => '/tmp/picked.png');
        return viewModel;
      },
      act: (cubit) => cubit.doEvent(PickProfileImageEvent()),
      expect: () => [
        const ProfileState(pickedImagePath: '/tmp/picked.png'),
      ],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits nothing when the user cancels the picker',
      build: () {
        when(() => mockImagePicker.pickFromGallery()).thenAnswer((_) async => null);
        return viewModel;
      },
      act: (cubit) => cubit.doEvent(PickProfileImageEvent()),
      expect: () => <ProfileState>[],
    );
  });

  group('UpdateProfileEvent', () {
    blocTest<ProfileViewModel, ProfileState>(
      'syncs the loaded profile with the saved one and clears the picked image',
      build: () {
        when(() => mockUpdateProfile.call(any()))
            .thenAnswer((_) async => SuccessResponce<ProfileEntity>(tUpdate));
        return viewModel;
      },
      seed: () => const ProfileState(pickedImagePath: '/tmp/picked.png'),
      act: (cubit) => cubit.doEvent(UpdateProfileEvent(profile: tUpdate)),
      expect: () => [
        isA<ProfileState>()
            .having((s) => s.updateProfileState.isLoading, 'isLoading', isTrue),
        isA<ProfileState>()
            .having((s) => s.profileState.data, 'profileState.data', tUpdate)
            .having(
              (s) => s.updateProfileState.data,
              'updateProfileState.data',
              tUpdate,
            )
            .having((s) => s.pickedImagePath, 'pickedImagePath', isNull),
      ],
      verify: (_) => verify(() => mockUpdateProfile.call(tUpdate)).called(1),
    );

    blocTest<ProfileViewModel, ProfileState>(
      'reports the error and keeps the loaded profile intact',
      build: () {
        when(() => mockUpdateProfile.call(any())).thenAnswer(
          (_) async => ErrorResponce<ProfileEntity>(Exception('rejected')),
        );
        return viewModel;
      },
      seed: () => const ProfileState(
        profileState: BaseState<ProfileEntity>(data: tProfile),
      ),
      act: (cubit) => cubit.doEvent(UpdateProfileEvent(profile: tUpdate)),
      expect: () => [
        isA<ProfileState>()
            .having((s) => s.updateProfileState.isLoading, 'isLoading', isTrue),
        isA<ProfileState>()
            .having(
              (s) => s.updateProfileState.errorMessage,
              'errorMessage',
              isNotEmpty,
            )
            .having((s) => s.profileState.data, 'profileState.data', tProfile),
      ],
    );
  });
}
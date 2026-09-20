import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:flower_app/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:flower_app/features/profile/domain/use_case/update_profile_use_case.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_state.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeProfileRepo implements ProfileRepo {
  final BaseResponce<ProfileEntity> getProfileResponse;
  final BaseResponce<ProfileEntity> updateProfileResponse;

  FakeProfileRepo({
    required this.getProfileResponse,
    required this.updateProfileResponse,
  });

  @override
  Future<BaseResponce<ProfileEntity>> getProfile() async => getProfileResponse;

  @override
  Future<BaseResponce<ProfileEntity>> updateProfile(
    ProfileEntity profile,
  ) async => updateProfileResponse;
}

void main() {
  late GetProfileUseCase getProfileUseCase;
  late UpdateProfileUseCase updateProfileUseCase;
  late ProfileViewModel viewModel;

  final profileEntity = const ProfileEntity(
    firstName: 'Sara',
    lastName: 'Ahmed',
    email: 'sara.ahmed@example.com',
    phoneNumber: '+201000000000',
    gender: 'Female',
  );

  setUp(() {});

  test('Initial state is const ProfileState()', () {
    final fakeRepo = FakeProfileRepo(
      getProfileResponse: SuccessResponce(profileEntity),
      updateProfileResponse: SuccessResponce(profileEntity),
    );
    getProfileUseCase = GetProfileUseCase(fakeRepo);
    updateProfileUseCase = UpdateProfileUseCase(fakeRepo);
    viewModel = ProfileViewModel(getProfileUseCase, updateProfileUseCase);

    expect(viewModel.state, equals(const ProfileState()));
  });

  test(
    'FetchProfileEvent with success: profileState goes isLoading true, then isLoading false with data',
    () async {
      final fakeRepo = FakeProfileRepo(
        getProfileResponse: SuccessResponce(profileEntity),
        updateProfileResponse: SuccessResponce(profileEntity),
      );
      getProfileUseCase = GetProfileUseCase(fakeRepo);
      updateProfileUseCase = UpdateProfileUseCase(fakeRepo);
      viewModel = ProfileViewModel(getProfileUseCase, updateProfileUseCase);

      final emitted = expectLater(
        viewModel.stream,
        emitsInOrder([
          isA<ProfileState>().having(
            (state) => state.profileState.isLoading,
            'isLoading',
            true,
          ),
          isA<ProfileState>()
              .having((state) => state.profileState.isLoading, 'isLoading', false)
              .having((state) => state.profileState.data, 'data', profileEntity),
        ]),
      );

      viewModel.doEvent(FetchProfileEvent());
      await emitted;
    },
  );

  test(
    'FetchProfileEvent with error: profileState ends with isLoading false and a non-null errorMessage',
    () async {
      final fakeRepo = FakeProfileRepo(
        getProfileResponse: ErrorResponce(Exception('fetch error')),
        updateProfileResponse: SuccessResponce(profileEntity),
      );
      getProfileUseCase = GetProfileUseCase(fakeRepo);
      updateProfileUseCase = UpdateProfileUseCase(fakeRepo);
      viewModel = ProfileViewModel(getProfileUseCase, updateProfileUseCase);

      final emitted = expectLater(
        viewModel.stream,
        emitsInOrder([
          isA<ProfileState>().having(
            (state) => state.profileState.isLoading,
            'isLoading',
            true,
          ),
          isA<ProfileState>()
              .having((state) => state.profileState.isLoading, 'isLoading', false)
              .having(
                (state) => state.profileState.errorMessage,
                'errorMessage',
                isNotNull,
              ),
        ]),
      );

      viewModel.doEvent(FetchProfileEvent());
      await emitted;
    },
  );

  test('PickProfileImageEvent: pickedImagePath is updated', () async {
    final fakeRepo = FakeProfileRepo(
      getProfileResponse: SuccessResponce(profileEntity),
      updateProfileResponse: SuccessResponce(profileEntity),
    );
    getProfileUseCase = GetProfileUseCase(fakeRepo);
    updateProfileUseCase = UpdateProfileUseCase(fakeRepo);
    viewModel = ProfileViewModel(getProfileUseCase, updateProfileUseCase);

    final emitted = expectLater(
      viewModel.stream,
      emitsInOrder([
        isA<ProfileState>().having(
          (state) => state.pickedImagePath,
          'pickedImagePath',
          'path/to/image.png',
        ),
      ]),
    );

    viewModel.doEvent(PickProfileImageEvent(imagePath: 'path/to/image.png'));
    await emitted;
  });

  test(
    'UpdateProfileEvent with success: updateProfileState ends with the returned data',
    () async {
      final updatedEntity = const ProfileEntity(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        phoneNumber: '+201000000000',
        gender: 'Male',
      );

      final fakeRepo = FakeProfileRepo(
        getProfileResponse: SuccessResponce(profileEntity),
        updateProfileResponse: SuccessResponce(updatedEntity),
      );
      getProfileUseCase = GetProfileUseCase(fakeRepo);
      updateProfileUseCase = UpdateProfileUseCase(fakeRepo);
      viewModel = ProfileViewModel(getProfileUseCase, updateProfileUseCase);

      final emitted = expectLater(
        viewModel.stream,
        emitsInOrder([
          isA<ProfileState>().having(
            (state) => state.updateProfileState.isLoading,
            'isLoading',
            true,
          ),
          isA<ProfileState>()
              .having(
                (state) => state.updateProfileState.isLoading,
                'isLoading',
                false,
              )
              .having(
                (state) => state.updateProfileState.data,
                'data',
                updatedEntity,
              ),
        ]),
      );

      viewModel.doEvent(UpdateProfileEvent(profile: updatedEntity));
      await emitted;
    },
  );

  test(
    'UpdateProfileEvent with error: updateProfileState ends with an errorMessage',
    () async {
      final fakeRepo = FakeProfileRepo(
        getProfileResponse: SuccessResponce(profileEntity),
        updateProfileResponse: ErrorResponce(Exception('update error')),
      );
      getProfileUseCase = GetProfileUseCase(fakeRepo);
      updateProfileUseCase = UpdateProfileUseCase(fakeRepo);
      viewModel = ProfileViewModel(getProfileUseCase, updateProfileUseCase);

      final emitted = expectLater(
        viewModel.stream,
        emitsInOrder([
          isA<ProfileState>().having(
            (state) => state.updateProfileState.isLoading,
            'isLoading',
            true,
          ),
          isA<ProfileState>()
              .having(
                (state) => state.updateProfileState.isLoading,
                'isLoading',
                false,
              )
              .having(
                (state) => state.updateProfileState.errorMessage,
                'errorMessage',
                isNotNull,
              ),
        ]),
      );

      viewModel.doEvent(UpdateProfileEvent(profile: profileEntity));
      await emitted;
    },
  );
}
import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/show_profile_usecase.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_state.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_viewModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockShowProfileUsecase extends Mock implements ShowProfileUsecase {}

void main() {
  late MockShowProfileUsecase mockUsecase;
  late ProfileViewModel viewModel;

  const userEntity = UserEntity(
    id: 1,
    fullName: 'Nour Mohamed',
    email: 'nour@example.com',
    phoneNumber: '+201234567890',
    gender: 'female',
    role: 'user',
    status: 'active',
  );

  setUp(() {
    mockUsecase = MockShowProfileUsecase();
    viewModel = ProfileViewModel(mockUsecase);
  });

  tearDown(() {
    viewModel.close();
  });

  group('ProfileViewModel initial state', () {
    test('initial state has correct defaults', () {
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.errorMessage, '');
      expect(viewModel.state.data, isNull);
    });
  });

  group('GetProfileIntent', () {
    blocTest<ProfileViewModel, ProfileState>(
      'emits [loading=true, loading=false with data] on success',
      build: () {
        when(() => mockUsecase.getProfile())
            .thenAnswer((_) async => SuccessResponce(userEntity));
        return ProfileViewModel(mockUsecase);
      },
      act: (vm) => vm.doIntent(GetProfileIntent()),
      expect: () => [
        const ProfileState(isLoading: true),
        const ProfileState(isLoading: false, data: userEntity),
      ],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits [loading=true, loading=false with error] on failure',
      build: () {
        when(() => mockUsecase.getProfile()).thenAnswer(
          (_) async =>
              ErrorResponce<UserEntity>(Exception('Profile not found')),
        );
        return ProfileViewModel(mockUsecase);
      },
      act: (vm) => vm.doIntent(GetProfileIntent()),
      expect: () => [
        const ProfileState(isLoading: true),
        predicate<ProfileState>((s) => !s.isLoading && s.errorMessage.isNotEmpty),
      ],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'sets data with correct user info on success',
      build: () {
        when(() => mockUsecase.getProfile())
            .thenAnswer((_) async => SuccessResponce(userEntity));
        return ProfileViewModel(mockUsecase);
      },
      act: (vm) => vm.doIntent(GetProfileIntent()),
      verify: (vm) {
        expect(vm.state.data?.fullName, 'Nour Mohamed');
        expect(vm.state.data?.email, 'nour@example.com');
        expect(vm.state.data?.id, 1);
      },
    );

    blocTest<ProfileViewModel, ProfileState>(
      'calls usecase exactly once per GetProfileIntent',
      build: () {
        when(() => mockUsecase.getProfile())
            .thenAnswer((_) async => SuccessResponce(userEntity));
        return ProfileViewModel(mockUsecase);
      },
      act: (vm) => vm.doIntent(GetProfileIntent()),
      verify: (_) {
        verify(() => mockUsecase.getProfile()).called(1);
      },
    );
  });

  group('Non-fetching intents', () {
    blocTest<ProfileViewModel, ProfileState>(
      'EditProfileIntent does not emit or crash',
      build: () => ProfileViewModel(mockUsecase),
      act: (vm) => vm.doIntent(EditProfileIntent()),
      expect: () => [],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'NotificationIntent does not emit or crash',
      build: () => ProfileViewModel(mockUsecase),
      act: (vm) => vm.doIntent(NotificationIntent()),
      expect: () => [],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'LogoutIntent does not emit or crash',
      build: () => ProfileViewModel(mockUsecase),
      act: (vm) => vm.doIntent(LogoutIntent()),
      expect: () => [],
    );
  });
}

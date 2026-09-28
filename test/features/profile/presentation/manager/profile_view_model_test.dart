import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/show_profile_usecase.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_event.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_state.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockShowProfileUsecase extends Mock implements ShowProfileUsecase {}

/// Convenience constructors mirroring the old named parameters, so the
/// expectations below stay readable while [ProfileState] holds a single
/// [BaseState] member.
ProfileState stateWith({
  bool isLoading = false,
  String errorMessage = '',
  UserEntity? data,
}) => ProfileState(
  baseState: BaseState<UserEntity>(
    isLoading: isLoading,
    errorMessage: errorMessage,
    data: data,
  ),
);

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

  group('ProfileState', () {
    test('initial state has correct defaults', () {
      const state = ProfileState();

      expect(state.isLoading, isFalse);
      expect(state.errorMessage, '');
      expect(state.data, isNull);
    });

    test('delegates isLoading/errorMessage/data to the held BaseState', () {
      final state = stateWith(
        isLoading: true,
        errorMessage: 'boom',
        data: userEntity,
      );

      expect(state.baseState.isLoading, isTrue);
      expect(state.baseState.errorMessage, 'boom');
      expect(state.isLoading, isTrue);
      expect(state.errorMessage, 'boom');
      expect(state.data, userEntity);
    });

    test('two states with the same BaseState are equal', () {
      expect(stateWith(data: userEntity), stateWith(data: userEntity));
      expect(
        stateWith(data: userEntity),
        isNot(stateWith(isLoading: true, data: userEntity)),
      );
    });

    test('copyWith keeps the existing BaseState when none is given', () {
      final state = stateWith(data: userEntity);

      expect(state.copyWith(), state);
    });
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
        when(
          () => mockUsecase.getProfile(),
        ).thenAnswer((_) async => SuccessResponce(userEntity));
        return ProfileViewModel(mockUsecase);
      },
      act: (vm) => vm.doIntent(GetProfileIntent()),
      expect: () => [
        stateWith(isLoading: true),
        stateWith(isLoading: false, data: userEntity),
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
        stateWith(isLoading: true),
        predicate<ProfileState>(
          (s) => !s.isLoading && s.errorMessage.isNotEmpty,
        ),
      ],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'sets data with correct user info on success',
      build: () {
        when(
          () => mockUsecase.getProfile(),
        ).thenAnswer((_) async => SuccessResponce(userEntity));
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
        when(
          () => mockUsecase.getProfile(),
        ).thenAnswer((_) async => SuccessResponce(userEntity));
        return ProfileViewModel(mockUsecase);
      },
      act: (vm) => vm.doIntent(GetProfileIntent()),
      verify: (_) {
        verify(() => mockUsecase.getProfile()).called(1);
      },
    );
  });

  group('Error reporting', () {
    // Failures are values, not throws: `ProfileRepoImp.getProfile` converts a
    // throw into an `ErrorResponce`, so the view model handles exactly one
    // error shape.
    blocTest<ProfileViewModel, ProfileState>(
      'reports a repository error without throwing',
      build: () {
        when(
          () => mockUsecase.getProfile(),
        ).thenAnswer((_) async => ErrorResponce<UserEntity>(Exception('boom')));
        return ProfileViewModel(mockUsecase);
      },
      act: (vm) => vm.doIntent(GetProfileIntent()),
      expect: () => [
        stateWith(isLoading: true),
        predicate<ProfileState>(
          (s) => !s.isLoading && s.errorMessage.isNotEmpty,
        ),
      ],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'clears a previous error message on a successful refetch',
      build: () {
        when(
          () => mockUsecase.getProfile(),
        ).thenAnswer((_) async => SuccessResponce(userEntity));
        return ProfileViewModel(mockUsecase);
      },
      seed: () => stateWith(errorMessage: 'Previous failure'),
      act: (vm) => vm.doIntent(GetProfileIntent()),
      verify: (vm) {
        expect(vm.state.errorMessage, isEmpty);
        expect(vm.state.data, userEntity);
      },
    );
  });

  group('Non-fetching intents', () {
    // These intents exist so the view can express user actions; navigation and
    // logout side effects are owned by the view layer, so the view model must
    // leave the state untouched and must not call the use case.
    blocTest<ProfileViewModel, ProfileState>(
      'EditProfileIntent does not emit and does not fetch',
      build: () => ProfileViewModel(mockUsecase),
      act: (vm) => vm.doIntent(EditProfileIntent()),
      expect: () => [],
      verify: (_) => verifyNever(() => mockUsecase.getProfile()),
    );

    blocTest<ProfileViewModel, ProfileState>(
      'NotificationIntent does not emit and does not fetch',
      build: () => ProfileViewModel(mockUsecase),
      act: (vm) => vm.doIntent(NotificationIntent()),
      expect: () => [],
      verify: (_) => verifyNever(() => mockUsecase.getProfile()),
    );

    blocTest<ProfileViewModel, ProfileState>(
      'LogoutIntent does not emit and does not fetch',
      build: () => ProfileViewModel(mockUsecase),
      act: (vm) => vm.doIntent(LogoutIntent()),
      expect: () => [],
      verify: (_) => verifyNever(() => mockUsecase.getProfile()),
    );

    blocTest<ProfileViewModel, ProfileState>(
      'non-fetching intents preserve the existing state',
      build: () => ProfileViewModel(mockUsecase),
      seed: () => stateWith(data: userEntity),
      act: (vm) async {
        vm.doIntent(EditProfileIntent());
        vm.doIntent(NotificationIntent());
        vm.doIntent(LogoutIntent());
      },
      verify: (vm) {
        expect(vm.state.data, userEntity);
        expect(vm.state.isLoading, isFalse);
        expect(vm.state.errorMessage, isEmpty);
      },
    );
  });
}

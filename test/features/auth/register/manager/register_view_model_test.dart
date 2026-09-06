import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_entity.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_request_entity.dart';
import 'package:flower_app/features/auth/domain/use_case/register_auth_use_case.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterAuthUseCase extends Mock implements RegisterAuthUseCase {}

void main() {
  final event = RegisterSubmitted(
    fullName: 'John Doe',
    email: 'john@example.com',
    password: 'P@ssw0rd',
    confirmPassword: 'P@ssw0rd',
    phoneNumber: '01012345678',
    gender: 1,
  );

  final entity = RegisterEntity(
    isSuccess: true,
    errorCode: 200,
    message: 'Registration successful',
    data: true,
  );

  late MockRegisterAuthUseCase useCase;
  late RegisterViewModel viewModel;

  setUpAll(() {
    registerFallbackValue(RegisterRequestEntity(
      fullName: 'John Doe',
      email: 'john@example.com',
      phoneNumber: '01012345678',
      gender: 1,
      password: 'P@ssw0rd',
      confirmPassword: 'P@ssw0rd',
    ));
  });

  setUp(() {
    useCase = MockRegisterAuthUseCase();
    viewModel = RegisterViewModel(useCase);
  });

  group('RegisterViewModel', () {
    test('initial state uses default values', () {
      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.errorMessage, isEmpty);
      expect(viewModel.state.data, isNull);
    });

    test('emits loading then success state on successful registration', () async {
      when(() => useCase.execute(any())).thenAnswer(
        (_) async => SuccessResponce<RegisterEntity>(entity),
      );

      final expectations = expectLater(
        viewModel.stream,
        emitsInOrder([
          predicate<RegisterState>(
            (state) => state.isLoading && state.errorMessage.isEmpty,
          ),
          predicate<RegisterState>(
            (state) => !state.isLoading && state.data?.isSuccess == true,
          ),
        ]),
      );

      viewModel.handle(event);

      await expectations;
      verify(() => useCase.execute(any())).called(1);
    });

    test('emits loading then error state when the use case returns an error', () async {
      when(() => useCase.execute(any())).thenAnswer(
        (_) async => ErrorResponce<RegisterEntity>(Exception('boom')),
      );

      final expectations = expectLater(
        viewModel.stream,
        emitsInOrder([
          predicate<RegisterState>(
            (state) => state.isLoading && state.errorMessage.isEmpty,
          ),
          predicate<RegisterState>(
            (state) => !state.isLoading && state.errorMessage.isNotEmpty,
          ),
        ]),
      );

      viewModel.handle(event);

      await expectations;
      verify(() => useCase.execute(any())).called(1);
    });
  });
}
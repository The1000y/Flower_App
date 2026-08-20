import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_entity.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_request_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:flower_app/features/auth/domain/use_case/register_auth_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  final validEntity = RegisterRequestEntity(
    fullName: 'John Doe',
    email: 'john@example.com',
    phoneNumber: '01012345678',
    gender: 1,
    password: 'P@ssw0rd',
    confirmPassword: 'P@ssw0rd',
  );

  final successEntity = RegisterEntity(
    isSuccess: true,
    errorCode: 200,
    message: 'Registration successful',
    data: true,
  );

  late MockAuthRepo authRepo;
  late RegisterAuthUseCase useCase;

  setUpAll(() {
    registerFallbackValue(validEntity);
  });

  setUp(() {
    authRepo = MockAuthRepo();
    useCase = RegisterAuthUseCase(authRepo);
  });

  group('RegisterAuthUseCase', () {
    test('execute delegates to the repo and returns its result', () async {
      when(() => authRepo.register(any())).thenAnswer(
        (_) async => SuccessResponce<RegisterEntity>(successEntity),
      );

      final result = await useCase.execute(validEntity);

      expect(result, isA<SuccessResponce<RegisterEntity>>());
      expect((result as SuccessResponce<RegisterEntity>).data, successEntity);
      verify(() => authRepo.register(validEntity)).called(1);
    });

    test('execute returns ErrorResponce when the repo fails', () async {
      when(() => authRepo.register(any())).thenAnswer(
        (_) async => ErrorResponce<RegisterEntity>(Exception('boom')),
      );

      final result = await useCase.execute(validEntity);

      expect(result, isA<ErrorResponce<RegisterEntity>>());
      verify(() => authRepo.register(validEntity)).called(1);
    });

    test(
      'execute returns ErrorResponce without calling repo when invalid',
      () async {
        final invalidEntity = RegisterRequestEntity(
          fullName: '',
          email: 'not-an-email',
          phoneNumber: '01012345678',
          gender: 1,
          password: 'P@ssw0rd',
          confirmPassword: 'Different',
        );

        final result = await useCase.execute(invalidEntity);

        expect(result, isA<ErrorResponce<RegisterEntity>>());
        verifyNever(() => authRepo.register(any()));
      },
    );

    test('execute surfaces a generic message for validation failures', () async {
      final invalidEntity = RegisterRequestEntity(
        fullName: '',
        email: 'john@example.com',
        phoneNumber: '01012345678',
        gender: 1,
        password: 'P@ssw0rd',
        confirmPassword: 'P@ssw0rd',
      );

      final result = await useCase.execute(invalidEntity);

      expect(result, isA<ErrorResponce<RegisterEntity>>());
      expect(
        (result as ErrorResponce<RegisterEntity>).errorMessage,
        'something went wrong, pls try again',
      );
    });
  });
}
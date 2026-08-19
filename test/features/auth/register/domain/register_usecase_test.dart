import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:flower_app/features/auth/domain/use_case/register_auth_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  final request = RegisterRequest(
    fullName: 'John Doe',
    email: 'john@example.com',
    phoneNumber: '01012345678',
    gender: 1,
    password: 'P@ssw0rd',
    confirmPassword: 'P@ssw0rd',
  );

  final entity = RegisterEntity(
    isSuccess: true,
    errorCode: 200,
    message: 'Registration successful',
    data: true,
  );

  late MockAuthRepo authRepo;
  late RegisterAuthUseCase useCase;

  setUp(() {
    authRepo = MockAuthRepo();
    useCase = RegisterAuthUseCase(authRepo);
  });

  group('RegisterAuthUseCase', () {
    test('execute delegates to the repo and returns its result', () async {
      when(() => authRepo.register(request)).thenAnswer(
        (_) async => SuccessResponce<RegisterEntity>(entity),
      );

      final result = await useCase.execute(request);

      expect(result, isA<SuccessResponce<RegisterEntity>>());
      expect((result as SuccessResponce<RegisterEntity>).data, entity);
      verify(() => authRepo.register(request)).called(1);
    });

    test('execute returns ErrorResponce when the repo fails', () async {
      when(() => authRepo.register(request)).thenAnswer(
        (_) async => ErrorResponce<RegisterEntity>(Exception('boom')),
      );

      final result = await useCase.execute(request);

      expect(result, isA<ErrorResponce<RegisterEntity>>());
      verify(() => authRepo.register(request)).called(1);
    });
  });
}
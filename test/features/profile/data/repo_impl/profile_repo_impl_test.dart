import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/data/data_source/remote_data_source/profile_remote_data_source.dart';
import 'package:flower_app/features/profile/data/model/request/update_profile_request_dto.dart';
import 'package:flower_app/features/profile/data/model/response/get_profile_response_dto.dart';
import 'package:flower_app/features/profile/data/repo_impl/profile_repo_impl.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRemoteDataSource extends Mock implements ProfileRemoteDataSource {}

class FakeUpdateProfileRequestDto extends Fake implements UpdateProfileRequestDto {}

void main() {
  late ProfileRepoImpl repo;
  late MockProfileRemoteDataSource mockRemoteDataSource;

  setUpAll(() {
    registerFallbackValue(FakeUpdateProfileRequestDto());
  });

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    repo = ProfileRepoImpl(mockRemoteDataSource);
  });

  group('getProfile', () {
    test('returns SuccessResponce<ProfileEntity> when data source succeeds', () async {
      final dto = GetProfileResponseDto(
        fullName: 'John Doe',
        email: 'john@example.com',
        phone: '01000000000',
        gender: 'Male',
      );
      when(() => mockRemoteDataSource.getProfile())
          .thenAnswer((_) async => SuccessResponce(dto));

      final result = await repo.getProfile();

      expect(result, isA<SuccessResponce<ProfileEntity>>());
      final entity = (result as SuccessResponce<ProfileEntity>).data;
      expect(entity.firstName, 'John');
      expect(entity.lastName, 'Doe');
    });

    test('returns ErrorResponce when data source fails', () async {
      when(() => mockRemoteDataSource.getProfile())
          .thenAnswer((_) async => ErrorResponce(Exception('Network error')));

      final result = await repo.getProfile();

      expect(result, isA<ErrorResponce<ProfileEntity>>());
    });
  });

  group('updateProfile', () {
    final entity = const ProfileEntity(
      firstName: 'Jane',
      lastName: 'Doe',
      email: 'jane@example.com',
      phoneNumber: '01000000000',
      gender: 'Female',
    );

    test('returns SuccessResponce<ProfileEntity> when data source succeeds', () async {
      final dto = GetProfileResponseDto(
        fullName: 'Jane Doe',
        email: 'jane@example.com',
        phone: '01000000000',
        gender: 'Female',
      );

      when(() => mockRemoteDataSource.updateProfile(any()))
          .thenAnswer((_) async => SuccessResponce<void>(null));
      when(() => mockRemoteDataSource.getProfile())
          .thenAnswer((_) async => SuccessResponce(dto));

      final result = await repo.updateProfile(entity);

      expect(result, isA<SuccessResponce<ProfileEntity>>());
      verify(() => mockRemoteDataSource.updateProfile(any())).called(1);
      verify(() => mockRemoteDataSource.getProfile()).called(1);
    });

    test('returns ErrorResponce when update data source fails', () async {
      when(() => mockRemoteDataSource.updateProfile(any()))
          .thenAnswer((_) async => ErrorResponce<void>(Exception('Update error')));

      final result = await repo.updateProfile(entity);

      expect(result, isA<ErrorResponce<ProfileEntity>>());
      verify(() => mockRemoteDataSource.updateProfile(any())).called(1);
      verifyNever(() => mockRemoteDataSource.getProfile());
    });
  });
}

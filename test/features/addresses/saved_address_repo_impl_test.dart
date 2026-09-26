import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/addresses/data/data_source/local_data_source/location_data_source.dart';
import 'package:flower_app/features/addresses/data/data_source/remote_data_source/address_remote_data_source.dart';
import 'package:flower_app/features/addresses/data/model/responce/address_dto.dart';
import 'package:flower_app/features/addresses/data/model/responce/area_dto.dart';
import 'package:flower_app/features/addresses/data/repo_impl/address_repo_impl.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddressRemoteDataSource extends Mock
    implements AddressRemoteDataSource {}

class MockLocationDataSource extends Mock implements LocationDataSource {}

void main() {
  late MockAddressRemoteDataSource mockRemoteDataSource;
  late MockLocationDataSource mockLocationDataSource;
  late AddressRepoImpl addressRepoImpl;

  setUpAll(() {
    registerFallbackValue(
      SuccessResponce<List<AddressDto>>([]),
    );
    registerFallbackValue(
      SuccessResponce<bool>(false),
    );
    registerFallbackValue(
      SuccessResponce<AddressDto>(
        AddressDto(
          id: 'dummy',
          recipientName: 'Dummy',
          recipientPhone: '01000000000',
          addressLine: 'Dummy Line',
          city: 'Cairo',
          area: 'Dokki',
          isDefault: false,
          isServiceable: true,
        ),
      ),
    );
    registerFallbackValue(
      SuccessResponce<List<AreaDto>>([]),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockAddressRemoteDataSource();
    mockLocationDataSource = MockLocationDataSource();

    addressRepoImpl = AddressRepoImpl(
      mockRemoteDataSource,
      mockLocationDataSource,
    );
  });

  final dummyAddressDto = AddressDto(
    id: '123',
    recipientName: 'Test Name',
    recipientPhone: '01000000000',
    addressLine: 'Test Line',
    city: 'Cairo',
    area: 'Dokki',
    isDefault: true,
    isServiceable: true,
  );

  group('AddressRepoImpl - GetAddresses', () {
    test('should return List<AddressEntity> when remote data source succeeds',
        () async {
      when(() => mockRemoteDataSource.getAddresses()).thenAnswer(
        (_) async => SuccessResponce<List<AddressDto>>([dummyAddressDto]),
      );

      final result = await addressRepoImpl.getAddresses();

      expect(result, isA<List<AddressEntity>>());
      expect(result.length, 1);
      expect(result.first.id, '123');
      verify(() => mockRemoteDataSource.getAddresses()).called(1);
    });

    test('should throw Exception when remote data source fails', () async {
      when(() => mockRemoteDataSource.getAddresses()).thenAnswer(
        (_) async => ErrorResponce(Exception('Fetch failed')),
      );

      expect(() => addressRepoImpl.getAddresses(), throwsException);
    });
  });

  group('AddressRepoImpl - DeleteAddress', () {
    test('should return bool when remote data source succeeds', () async {
      when(() => mockRemoteDataSource.deleteAddress(any())).thenAnswer(
        (_) async => SuccessResponce<bool>(true),
      );

      final result = await addressRepoImpl.deleteAddress('123');

      expect(result, true);
      verify(() => mockRemoteDataSource.deleteAddress('123')).called(1);
    });
  });

  group('AddressRepoImpl - SetDefaultAddress', () {
    test('should return AddressEntity when remote data source succeeds',
        () async {
      when(() => mockRemoteDataSource.setDefaultAddress(any())).thenAnswer(
        (_) async => SuccessResponce<AddressDto>(dummyAddressDto),
      );

      final result = await addressRepoImpl.setDefaultAddress('123');

      expect(result, isA<AddressEntity>());
      verify(() => mockRemoteDataSource.setDefaultAddress('123')).called(1);
    });
  });

  group('AddressRepoImpl - GetGovernorates', () {
    test('should return GovernorateEntities from areas', () async {
      when(() => mockRemoteDataSource.getAreas()).thenAnswer(
        (_) async => SuccessResponce<List<AreaDto>>([
          const AreaDto(
            id: 'g1',
            name: 'Giza',
            cities: [
              CityItemDto(id: 'c1', name: 'Dokki'),
              CityItemDto(id: 'c2', name: 'Sheikh Zayed'),
            ],
          ),
        ]),
      );

      final result = await addressRepoImpl.getGovernorates();

      expect(result.length, 1);
      expect(result.first.id, 'g1');
      expect(result.first.nameEn, 'Giza');
    });
  });

  group('AddressRepoImpl - GetCities', () {
    test('should return cities for the matched governorate', () async {
      when(() => mockRemoteDataSource.getAreas()).thenAnswer(
        (_) async => SuccessResponce<List<AreaDto>>([
          const AreaDto(
            id: 'g1',
            name: 'Giza',
            cities: [
              CityItemDto(id: 'c1', name: 'Dokki'),
              CityItemDto(id: 'c2', name: 'Sheikh Zayed'),
            ],
          ),
          const AreaDto(
            id: 'g2',
            name: 'Cairo',
            cities: [
              CityItemDto(id: 'c3', name: 'Maadi'),
            ],
          ),
        ]),
      );

      final result = await addressRepoImpl.getCities(governorateId: 'g1');

      expect(result.length, 2);
      expect(result.first.id, 'c1');
      expect(result.first.nameEn, 'Dokki');
      expect(result.first.governorateId, 'g1');
    });
  });
}

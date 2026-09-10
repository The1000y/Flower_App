import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/addresses/data/data_source/local_data_source/address_local_data_source.dart';
import 'package:flower_app/features/addresses/data/data_source/local_data_source/location_data_source.dart'; // 🎯 Added import
import 'package:flower_app/features/addresses/data/model/responce/address_dto.dart';
import 'package:flower_app/features/addresses/data/repo_impl/address_repo_impl.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'saved_address_repo_impl_test.mocks.dart';

@GenerateMocks([AddressLocalDataSource, LocationDataSource])
void main() {
  late MockAddressLocalDataSource mockLocalDataSource;
  late MockLocationDataSource mockLocationDataSource; // 🎯 Added mock
  late AddressRepoImpl savedAddressRepoImpl;

  setUp(() {
    mockLocalDataSource = MockAddressLocalDataSource();
    mockLocationDataSource = MockLocationDataSource(); // 🎯 Initialized mock

    savedAddressRepoImpl = AddressRepoImpl(
      mockLocalDataSource,
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

  group('SavedAddressRepoImpl - GetAddresses', () {
    test('should return List<AddressEntity> when data source succeeds', () async {
      when(mockLocalDataSource.getAddresses()).thenAnswer(
            (_) async => SuccessResponce<List<AddressDto>>([dummyAddressDto]),
      );

      final result = await savedAddressRepoImpl.getAddresses();

      // 🎯 Expect pure list
      expect(result, isA<List<AddressEntity>>());
      verify(mockLocalDataSource.getAddresses()).called(1);
    });

    test('should throw Exception when data source fails', () async {
      when(mockLocalDataSource.getAddresses()).thenAnswer(
            (_) async => ErrorResponce(Exception('Fetch failed')),
      );

      // 🎯 Expect it to throw the error
      expect(() => savedAddressRepoImpl.getAddresses(), throwsException);
    });
  });

  group('SavedAddressRepoImpl - DeleteAddress', () {
    test('should return bool when data source succeeds', () async {
      when(mockLocalDataSource.deleteAddress(any)).thenAnswer(
            (_) async => SuccessResponce<bool>(true),
      );

      final result = await savedAddressRepoImpl.deleteAddress('123');

      expect(result, true);
      verify(mockLocalDataSource.deleteAddress('123')).called(1);
    });
  });

  group('SavedAddressRepoImpl - SetDefaultAddress', () {
    test('should return AddressEntity when data source succeeds', () async {
      when(mockLocalDataSource.setDefaultAddress(any)).thenAnswer(
            (_) async => SuccessResponce<AddressDto>(dummyAddressDto),
      );

      final result = await savedAddressRepoImpl.setDefaultAddress('123');

      expect(result, isA<AddressEntity>());
      verify(mockLocalDataSource.setDefaultAddress('123')).called(1);
    });
  });
}
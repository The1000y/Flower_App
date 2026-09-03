import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/addresses/data/datasource/address_local_datasource.dart';
import 'package:flower_app/features/addresses/data/model/%20response/address_dto.dart';
import 'package:flower_app/features/addresses/data/repo_impl/address_repository_impl.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'saved_address_repo_impl_test.mocks.dart';

@GenerateMocks([SavedAddressLocalDataSource])
void main() {
  late MockSavedAddressLocalDataSource mockLocalDataSource;
  late SavedAddressRepoImpl savedAddressRepoImpl;

  setUp(() {
    mockLocalDataSource = MockSavedAddressLocalDataSource();
    savedAddressRepoImpl = SavedAddressRepoImpl(mockLocalDataSource);
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
    test('should return SuccessResponce<List<AddressEntity>> when data source succeeds', () async {
      when(mockLocalDataSource.getAddresses()).thenAnswer(
        (_) async => SuccessResponce<List<AddressDto>>([dummyAddressDto]),
      );

      final result = await savedAddressRepoImpl.getAddresses();

      expect(result, isA<SuccessResponce<List<AddressEntity>>>());
      verify(mockLocalDataSource.getAddresses()).called(1);
    });

    test('should return ErrorResponce when data source fails', () async {
      when(mockLocalDataSource.getAddresses()).thenAnswer(
        (_) async => ErrorResponce(Exception('Fetch failed')),
      );

      final result = await savedAddressRepoImpl.getAddresses();

      expect(result, isA<ErrorResponce<List<AddressEntity>>>());
    });
  });

  group('SavedAddressRepoImpl - DeleteAddress', () {
    test('should return SuccessResponce<bool> when data source succeeds', () async {
      when(mockLocalDataSource.deleteAddress(any)).thenAnswer(
        (_) async => SuccessResponce<bool>(true),
      );

      final result = await savedAddressRepoImpl.deleteAddress('123');

      expect(result, isA<SuccessResponce<bool>>());
      verify(mockLocalDataSource.deleteAddress('123')).called(1);
    });
  });

  group('SavedAddressRepoImpl - SetDefaultAddress', () {
    test('should return SuccessResponce<AddressEntity> when data source succeeds', () async {
      when(mockLocalDataSource.setDefaultAddress(any)).thenAnswer(
        (_) async => SuccessResponce<AddressDto>(dummyAddressDto),
      );

      final result = await savedAddressRepoImpl.setDefaultAddress('123');

      expect(result, isA<SuccessResponce<AddressEntity>>());
      verify(mockLocalDataSource.setDefaultAddress('123')).called(1);
    });
  });
}

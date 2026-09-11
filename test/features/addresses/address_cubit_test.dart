import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/domain/usecases/add_address_use_case.dart';
import 'package:flower_app/features/addresses/domain/usecases/delete_address_usecase.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_addresses_usecase.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_cities_use_case.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_current_location_use_case.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_governomets_use_case.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_reverse_geocoded_address_use_case.dart';
import 'package:flower_app/features/addresses/domain/usecases/set_default_address_usecase.dart';
import 'package:flower_app/features/addresses/domain/usecases/update_address_use_case.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_events.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddAddressUseCase extends Mock implements AddAddressUseCase {}
class MockGetCitiesUseCase extends Mock implements GetCitiesUseCase {}
class MockGetReverseGeocodedAddressUseCase extends Mock
    implements GetReverseGeocodedAddressUseCase {}
class MockGetCurrentLocationUseCase extends Mock
    implements GetCurrentLocationUseCase {}
class MockGetGovernoratesUseCase extends Mock implements GetGovernoratesUseCase {}
class MockUpdateAddressUseCase extends Mock implements UpdateAddressUseCase {}
class MockGetAddressesUseCase extends Mock implements GetAddressesUseCase {}
class MockDeleteAddressUseCase extends Mock implements DeleteAddressUseCase {}
class MockSetDefaultAddressUseCase extends Mock implements SetDefaultAddressUseCase {}

void main() {
  late MockAddAddressUseCase mockAddAddressUseCase;
  late MockGetCitiesUseCase mockGetCitiesUseCase;
  late MockGetReverseGeocodedAddressUseCase mockGetReverseGeocodedAddressUseCase;
  late MockGetCurrentLocationUseCase mockGetCurrentLocationUseCase;
  late MockGetGovernoratesUseCase mockGetGovernoratesUseCase;
  late MockUpdateAddressUseCase mockUpdateAddressUseCase;
  late MockGetAddressesUseCase mockGetAddressesUseCase;
  late MockDeleteAddressUseCase mockDeleteAddressUseCase;
  late MockSetDefaultAddressUseCase mockSetDefaultAddressUseCase;
  late AddressCubit cubit;

  final tAddress = AddressEntity(
    id: '1',
    recipientName: 'Test',
    recipientPhone: '01000000000',
    addressLine: 'Line',
    city: 'City',
    area: 'Area',
    isDefault: true,
    isServiceable: true,
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockAddAddressUseCase = MockAddAddressUseCase();
    mockGetCitiesUseCase = MockGetCitiesUseCase();
    mockGetReverseGeocodedAddressUseCase = MockGetReverseGeocodedAddressUseCase();
    mockGetCurrentLocationUseCase = MockGetCurrentLocationUseCase();
    mockGetGovernoratesUseCase = MockGetGovernoratesUseCase();
    mockUpdateAddressUseCase = MockUpdateAddressUseCase();
    mockGetAddressesUseCase = MockGetAddressesUseCase();
    mockDeleteAddressUseCase = MockDeleteAddressUseCase();
    mockSetDefaultAddressUseCase = MockSetDefaultAddressUseCase();

    cubit = AddressCubit(
      mockAddAddressUseCase,
      mockGetCitiesUseCase,
      mockGetReverseGeocodedAddressUseCase,
      mockGetCurrentLocationUseCase,
      mockGetGovernoratesUseCase,
      mockUpdateAddressUseCase,
      mockGetAddressesUseCase,
      mockDeleteAddressUseCase,
      mockSetDefaultAddressUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('AddressCubit', () {
    test('initial state should have an empty, non-loading addresses list', () {
      expect(cubit.state.addressesState.isLoading, isFalse);
      expect(cubit.state.addressesState.data, isEmpty);
    });

    blocTest<AddressCubit, AddressState>(
      'emits [loading, loaded, selected] when FetchUserAddressesEvent succeeds',
      build: () {
        when(() => mockGetAddressesUseCase.execute())
            .thenAnswer((_) async => [tAddress]);
        return cubit;
      },
      act: (cubit) => cubit.doEvent(FetchUserAddressesEvent()),
      expect: () => [
        isA<AddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isTrue),
        isA<AddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isFalse)
            .having((s) => s.addressesState.data, 'data', [tAddress]),
        isA<AddressState>()
            .having((s) => s.selectedAddress, 'selectedAddress', tAddress),
      ],
      verify: (_) {
        verify(() => mockGetAddressesUseCase.execute()).called(1);
      },
    );

    blocTest<AddressCubit, AddressState>(
      'emits [loading, error] when FetchUserAddressesEvent fails',
      build: () {
        when(() => mockGetAddressesUseCase.execute())
            .thenThrow(Exception('Load failed'));
        return cubit;
      },
      act: (cubit) => cubit.doEvent(FetchUserAddressesEvent()),
      expect: () => [
        isA<AddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isTrue),
        isA<AddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isFalse)
            .having((s) => s.addressesState.errorMessage, 'errorMessage', isNotEmpty),
      ],
    );

    blocTest<AddressCubit, AddressState>(
      'reloads the list when DeleteAddressEvent succeeds',
      build: () {
        when(() => mockDeleteAddressUseCase.execute('1'))
            .thenAnswer((_) async => true);

        when(() => mockGetAddressesUseCase.execute())
            .thenAnswer((_) async => []);
        return cubit;
      },
      act: (cubit) => cubit.doEvent(DeleteAddressEvent(id: '1')),
      expect: () => [
        isA<AddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isTrue),
        isA<AddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isFalse)
            .having((s) => s.addressesState.data, 'data', isEmpty),
      ],
      verify: (_) {
        verify(() => mockDeleteAddressUseCase.execute('1')).called(1);
        verify(() => mockGetAddressesUseCase.execute()).called(1);
      },
    );

    blocTest<AddressCubit, AddressState>(
      'emits an error and does not reload when DeleteAddressEvent fails',
      build: () {
        when(() => mockDeleteAddressUseCase.execute('1'))
            .thenThrow(Exception('Delete failed'));
        return cubit;
      },
      act: (cubit) => cubit.doEvent(DeleteAddressEvent(id: '1')),
      expect: () => [
        isA<AddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isTrue),
        isA<AddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isFalse)
            .having((s) => s.addressesState.errorMessage, 'errorMessage', isNotEmpty),
      ],
      verify: (_) {
        verify(() => mockDeleteAddressUseCase.execute('1')).called(1);
        verifyNever(() => mockGetAddressesUseCase.execute());
      },
    );
  });
}
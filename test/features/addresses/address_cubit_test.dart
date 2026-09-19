import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/location_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/params/add_address_params.dart';
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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockAddAddressUseCase extends Mock implements AddAddressUseCase {}

class MockGetCitiesUseCase extends Mock implements GetCitiesUseCase {}

class MockGetReverseGeocodedAddressUseCase extends Mock
    implements GetReverseGeocodedAddressUseCase {}

class MockGetCurrentLocationUseCase extends Mock
    implements GetCurrentLocationUseCase {}

class MockGetGovernoratesUseCase extends Mock
    implements GetGovernoratesUseCase {}

class MockUpdateAddressUseCase extends Mock implements UpdateAddressUseCase {}

class MockGetAddressesUseCase extends Mock implements GetAddressesUseCase {}

class MockDeleteAddressUseCase extends Mock implements DeleteAddressUseCase {}

class MockSetDefaultAddressUseCase extends Mock
    implements SetDefaultAddressUseCase {}

void main() {
  late MockAddAddressUseCase mockAddAddressUseCase;
  late MockGetCitiesUseCase mockGetCitiesUseCase;
  late MockGetReverseGeocodedAddressUseCase
  mockGetReverseGeocodedAddressUseCase;
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
    city: 'Cairo',
    area: 'Sheikh Zayed',
    lat: 30.0,
    lng: 31.0,
    label: 'Home',
    isDefault: true,
    isServiceable: true,
    createdAt: DateTime.now(),
  );

  final tGovernorate = GovernorateEntity(
    id: 'g1',
    nameAr: 'القاهرة',
    nameEn: 'Cairo',
  );

  final tCity = CityEntity(
    id: 'c1',
    governorateId: 'g1',
    nameAr: 'الشيخ زايد',
    nameEn: 'Sheikh Zayed',
  );

  setUpAll(() {
    registerFallbackValue(
      const AddAddressParams(
        recipientName: '',
        recipientPhone: '',
        addressLine: '',
        city: '',
        area: '',
        lat: 0,
        lng: 0,
        label: '',
      ),
    );
  });

  setUp(() {
    mockAddAddressUseCase = MockAddAddressUseCase();
    mockGetCitiesUseCase = MockGetCitiesUseCase();
    mockGetReverseGeocodedAddressUseCase =
        MockGetReverseGeocodedAddressUseCase();
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
        when(
          () => mockGetAddressesUseCase.execute(),
        ).thenAnswer((_) async => [tAddress]);
        return cubit;
      },
      act: (cubit) => cubit.doEvent(FetchUserAddressesEvent()),
      expect: () => [
        isA<AddressState>().having(
          (s) => s.addressesState.isLoading,
          'isLoading',
          isTrue,
        ),
        isA<AddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isFalse)
            .having((s) => s.addressesState.data, 'data', [tAddress]),
        isA<AddressState>().having(
          (s) => s.selectedAddress,
          'selectedAddress',
          tAddress,
        ),
      ],
      verify: (_) {
        verify(() => mockGetAddressesUseCase.execute()).called(1);
      },
    );

    blocTest<AddressCubit, AddressState>(
      'emits [loading, error] when FetchUserAddressesEvent fails',
      build: () {
        when(
          () => mockGetAddressesUseCase.execute(),
        ).thenThrow(Exception('Load failed'));
        return cubit;
      },
      act: (cubit) => cubit.doEvent(FetchUserAddressesEvent()),
      expect: () => [
        isA<AddressState>().having(
          (s) => s.addressesState.isLoading,
          'isLoading',
          isTrue,
        ),
        isA<AddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isFalse)
            .having(
              (s) => s.addressesState.errorMessage,
              'errorMessage',
              isNotEmpty,
            ),
      ],
    );

    blocTest<AddressCubit, AddressState>(
      'reloads the list when DeleteAddressEvent succeeds',
      build: () {
        when(
          () => mockDeleteAddressUseCase.execute('1'),
        ).thenAnswer((_) async => true);

        when(
          () => mockGetAddressesUseCase.execute(),
        ).thenAnswer((_) async => []);
        return cubit;
      },
      act: (cubit) => cubit.doEvent(DeleteAddressEvent(id: '1')),
      expect: () => [
        isA<AddressState>().having(
          (s) => s.addressesState.isLoading,
          'isLoading',
          isTrue,
        ),
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
        when(
          () => mockDeleteAddressUseCase.execute('1'),
        ).thenThrow(Exception('Delete failed'));
        return cubit;
      },
      act: (cubit) => cubit.doEvent(DeleteAddressEvent(id: '1')),
      expect: () => [
        isA<AddressState>().having(
          (s) => s.addressesState.isLoading,
          'isLoading',
          isTrue,
        ),
        isA<AddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isFalse)
            .having(
              (s) => s.addressesState.errorMessage,
              'errorMessage',
              isNotEmpty,
            ),
      ],
      verify: (_) {
        verify(() => mockDeleteAddressUseCase.execute('1')).called(1);
        verifyNever(() => mockGetAddressesUseCase.execute());
      },
    );

    Future<void> seedLocationState() async {
      when(
        () => mockGetGovernoratesUseCase.call(),
      ).thenAnswer((_) async => [tGovernorate]);
      when(
        () => mockGetCitiesUseCase.call('g1'),
      ).thenAnswer((_) async => [tCity]);
      cubit.doEvent(InitializeAddressEvent(existingAddress: tAddress));
      await pumpEventQueue();
    }

    test(
      'InitializeAddressEvent loads an existing address for editing',
      () async {
        await seedLocationState();

        final state = cubit.state;
        expect(state.governorates, [tGovernorate]);
        expect(state.selectedGovernorate, 'g1');
        expect(state.citiesState.data, [tCity]);
        expect(state.selectedCity, 'c1');
        expect(state.selectedCoordinates, const LatLng(30.0, 31.0));
        expect(state.streetAddress, 'Line, Cairo');
      },
    );

    test(
      'SubmitAddressEvent emits success and reset clears the action state',
      () async {
        await seedLocationState();

        when(
          () => mockAddAddressUseCase.call(any()),
        ).thenAnswer((_) async => SuccessResponce<AddressEntity>(tAddress));

        cubit.doEvent(
          SubmitAddressEvent(
            addAddressParams: const AddAddressParams(
              recipientName: 'Test',
              recipientPhone: '01000000000',
              addressLine: 'Line',
              city: 'g1',
              area: 'c1',
              lat: 30.0,
              lng: 31.0,
              label: 'Home',
            ),
          ),
        );
        await pumpEventQueue();

        var state = cubit.state;
        expect(state.addAddressState.data, tAddress);
        expect(state.addAddressState.isLoading, isFalse);
        expect(state.userAddresses, [tAddress]);
        expect(state.addressesState.data, [tAddress]);
        expect(state.selectedAddress, tAddress);
        verify(() => mockAddAddressUseCase.call(any())).called(1);

        cubit.doEvent(ResetAddAddressStateEvent());
        await pumpEventQueue();

        state = cubit.state;
        expect(state.addAddressState.data, isNull);
        expect(state.addAddressState.isLoading, isFalse);
        expect(state.userAddresses, [tAddress]);
        expect(state.addressesState.data, [tAddress]);
        expect(state.selectedAddress, tAddress);
      },
    );

    test('UpdateExistingAddressEvent updates the address everywhere', () async {
      await seedLocationState();

      when(
        () => mockGetAddressesUseCase.execute(),
      ).thenAnswer((_) async => [tAddress]);
      cubit.doEvent(FetchUserAddressesEvent());
      await pumpEventQueue();
      expect(cubit.state.selectedAddress, tAddress);

      final updatedAddress = AddressEntity(
        id: '1',
        recipientName: 'Updated Name',
        recipientPhone: '01000000000',
        addressLine: 'Updated Line',
        city: 'Cairo',
        area: 'Sheikh Zayed',
        lat: 30.0,
        lng: 31.0,
        label: 'Home',
        isDefault: true,
        isServiceable: true,
        createdAt: tAddress.createdAt,
      );

      when(
        () => mockUpdateAddressUseCase.execute('1', any()),
      ).thenAnswer((_) async => updatedAddress);

      cubit.doEvent(
        UpdateExistingAddressEvent(
          id: '1',
          params: const AddAddressParams(
            recipientName: 'Updated Name',
            recipientPhone: '01000000000',
            addressLine: 'Updated Line',
            city: 'g1',
            area: 'c1',
            lat: 30.0,
            lng: 31.0,
            label: 'Home',
          ),
        ),
      );
      await pumpEventQueue();

      final state = cubit.state;
      expect(state.addAddressState.data, updatedAddress);
      expect(state.userAddresses, [updatedAddress]);
      expect(state.addressesState.data, [updatedAddress]);
      expect(state.fetchAddressesState.data, [updatedAddress]);
      expect(state.selectedAddress, updatedAddress);
      expect(state.selectedAddressLabel, 'Updated Line - Sheikh Zayed');
      verify(() => mockUpdateAddressUseCase.execute('1', any())).called(1);
    });
  });
}

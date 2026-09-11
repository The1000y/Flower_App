import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/domain/usecases/delete_address_usecase.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_addresses_usecase.dart';
import 'package:flower_app/features/addresses/domain/usecases/set_default_address_usecase.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/manger/saved_address_event.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/manger/saved_address_state.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/manger/saved_address_view_model.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/manger/selected_address_cubit/selected_address_state.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/manger/selected_address_cubit/selected_address_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAddressesUseCase extends Mock implements GetAddressesUseCase {}
class MockDeleteAddressUseCase extends Mock implements DeleteAddressUseCase {}
class MockSetDefaultAddressUseCase extends Mock implements SetDefaultAddressUseCase {}
class MockSelectedAddressViewModel extends Mock implements SelectedAddressViewModel {}

void main() {
  late MockGetAddressesUseCase mockGetAddressesUseCase;
  late MockDeleteAddressUseCase mockDeleteAddressUseCase;
  late MockSetDefaultAddressUseCase mockSetDefaultAddressUseCase;
  late MockSelectedAddressViewModel mockSelectedAddressViewModel;
  late SavedAddressViewModel viewModel;

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
    mockGetAddressesUseCase = MockGetAddressesUseCase();
    mockDeleteAddressUseCase = MockDeleteAddressUseCase();
    mockSetDefaultAddressUseCase = MockSetDefaultAddressUseCase();
    mockSelectedAddressViewModel = MockSelectedAddressViewModel();
    when(() => mockSelectedAddressViewModel.state)
        .thenReturn(const SelectedAddressState());
    viewModel = SavedAddressViewModel(
      mockGetAddressesUseCase,
      mockDeleteAddressUseCase,
      mockSetDefaultAddressUseCase,
      mockSelectedAddressViewModel,
    );
  });

  tearDown(() {
    viewModel.close();
  });

  group('SavedAddressViewModel', () {
    test('initial state should have an empty, non-loading addresses list', () {
      expect(viewModel.state.addressesState.isLoading, isFalse);
      expect(viewModel.state.addressesState.data, isEmpty);
    });

    blocTest<SavedAddressViewModel, SavedAddressState>(
      'emits [loading, loaded] when LoadAddresses succeeds',
      build: () {
        when(() => mockGetAddressesUseCase.execute())
            .thenAnswer((_) async => [tAddress]);
        return viewModel;
      },
      act: (cubit) => cubit.doEvent(LoadAddresses()),
      expect: () => [
        isA<SavedAddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isTrue),
        isA<SavedAddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isFalse)
            .having((s) => s.addressesState.data, 'data', [tAddress]),
      ],
      verify: (_) {
        verify(() => mockGetAddressesUseCase.execute()).called(1);
      },
    );

    blocTest<SavedAddressViewModel, SavedAddressState>(
      'emits [loading, error] when LoadAddresses fails',
      build: () {
        when(() => mockGetAddressesUseCase.execute())
            .thenThrow(Exception('Load failed'));
        return viewModel;
      },
      act: (cubit) => cubit.doEvent(LoadAddresses()),
      expect: () => [
        isA<SavedAddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isTrue),
        isA<SavedAddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isFalse)
            .having((s) => s.addressesState.errorMessage, 'errorMessage', isNotEmpty),
      ],
    );

    blocTest<SavedAddressViewModel, SavedAddressState>(
      'reloads the list when DeleteAddress succeeds',
      build: () {
        when(() => mockDeleteAddressUseCase.execute('1'))
            .thenAnswer((_) async => true);

        when(() => mockGetAddressesUseCase.execute())
            .thenAnswer((_) async => []);
        return viewModel;
      },
      act: (cubit) => cubit.doEvent(DeleteAddressPressed('1')),
      expect: () => [
        isA<SavedAddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isTrue),
        isA<SavedAddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isTrue),
        isA<SavedAddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isFalse)
            .having((s) => s.addressesState.data, 'data', isEmpty),
      ],
      verify: (_) {
        verify(() => mockDeleteAddressUseCase.execute('1')).called(1);
        verify(() => mockGetAddressesUseCase.execute()).called(1);
      },
    );

    blocTest<SavedAddressViewModel, SavedAddressState>(
      'emits an error and does not reload when DeleteAddress fails',
      build: () {
        when(() => mockDeleteAddressUseCase.execute('1'))
            .thenThrow(Exception('Delete failed'));
        return viewModel;
      },
      act: (cubit) => cubit.doEvent(DeleteAddressPressed('1')),
      expect: () => [
        isA<SavedAddressState>()
            .having((s) => s.addressesState.isLoading, 'isLoading', isTrue),
        isA<SavedAddressState>()
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
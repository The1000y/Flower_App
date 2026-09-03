import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/domain/usecases/delete_address_usecase.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_addresses_usecase.dart';
import 'package:flower_app/features/addresses/domain/usecases/set_default_address_usecase.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/manger/saved_address_event.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/manger/saved_address_state.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/manger/saved_address_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAddressesUseCase extends Mock implements GetAddressesUseCase {}
class MockDeleteAddressUseCase extends Mock implements DeleteAddressUseCase {}
class MockSetDefaultAddressUseCase extends Mock implements SetDefaultAddressUseCase {}

void main() {
  late MockGetAddressesUseCase mockGetAddressesUseCase;
  late MockDeleteAddressUseCase mockDeleteAddressUseCase;
  late MockSetDefaultAddressUseCase mockSetDefaultAddressUseCase;
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
  );

  setUp(() {
    mockGetAddressesUseCase = MockGetAddressesUseCase();
    mockDeleteAddressUseCase = MockDeleteAddressUseCase();
    mockSetDefaultAddressUseCase = MockSetDefaultAddressUseCase();
    viewModel = SavedAddressViewModel(
      mockGetAddressesUseCase,
      mockDeleteAddressUseCase,
      mockSetDefaultAddressUseCase,
    );
  });

  tearDown(() {
    viewModel.close();
  });

  group('SavedAddressViewModel', () {
    test('initial state should be SavedAddressInitial', () {
      expect(viewModel.state, isA<SavedAddressInitial>());
    });

    blocTest<SavedAddressViewModel, SavedAddressState>(
      'emits [Loading, Loaded] when LoadAddresses succeeds',
      build: () {
        when(() => mockGetAddressesUseCase.execute())
            .thenAnswer((_) async => SuccessResponce<List<AddressEntity>>([tAddress]));
        return viewModel;
      },
      act: (cubit) => cubit.onEvent(LoadAddresses()),
      expect: () => [
        isA<SavedAddressLoading>(),
        isA<SavedAddressLoaded>().having((s) => s.addresses, 'addresses', [tAddress]),
      ],
      verify: (_) {
        verify(() => mockGetAddressesUseCase.execute()).called(1);
      },
    );

    blocTest<SavedAddressViewModel, SavedAddressState>(
      'emits [Loading, Error] when LoadAddresses fails',
      build: () {
        when(() => mockGetAddressesUseCase.execute())
            .thenAnswer((_) async => ErrorResponce(Exception('Load failed')));
        return viewModel;
      },
      act: (cubit) => cubit.onEvent(LoadAddresses()),
      expect: () => [
        isA<SavedAddressLoading>(),
        isA<SavedAddressError>().having((s) => s.message, 'message', isNotEmpty),
      ],
    );

    blocTest<SavedAddressViewModel, SavedAddressState>(
      'emits [Loading, Loaded] when DeleteAddress succeeds and reloads list',
      build: () {
        when(() => mockDeleteAddressUseCase.execute('1'))
            .thenAnswer((_) async => SuccessResponce<bool>(true));
        when(() => mockGetAddressesUseCase.execute())
            .thenAnswer((_) async => SuccessResponce<List<AddressEntity>>([]));
        return viewModel;
      },
      act: (cubit) => cubit.onEvent(DeleteAddressPressed('1')),
      expect: () => [
        isA<SavedAddressLoading>(),
        isA<SavedAddressLoaded>().having((s) => s.addresses, 'addresses', isEmpty),
      ],
      verify: (_) {
        verify(() => mockDeleteAddressUseCase.execute('1')).called(1);
        verify(() => mockGetAddressesUseCase.execute()).called(1);
      },
    );
  });
}

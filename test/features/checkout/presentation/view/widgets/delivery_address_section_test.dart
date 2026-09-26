import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_events.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_state.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_event.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_state.dart';
import 'package:flower_app/features/checkout/presentation/view/widgets/delivery_address_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/cubit_stream_stub.dart';
import '../../../mocks/mocks.mocks.dart';

import '../../../../../helpers/flutter_diagnostic_tolerances.dart';

void main() {
  late MockAddressCubit mockAddressCubit;
  late MockCheckoutCubit mockCheckoutCubit;
  late CubitStreamStub<AddressState, MockAddressCubit> stub;
  late CubitStreamStub<CheckoutState, MockCheckoutCubit> checkoutStub;

  // `AddressEntity.createdAt` is a non-nullable `DateTime`, so the fixture can
  // never be a const value.
  final tAddress = AddressEntity(
    id: 'address-1',
    recipientName: 'Mona Ahmed',
    recipientPhone: '01012345678',
    addressLine: '2XVP+XC',
    city: 'Cairo',
    area: 'Sheikh Zayed',
    label: 'Home',
    isDefault: true,
    isServiceable: true,
    createdAt: DateTime(2024, 2, 10),
  );

  setUp(() {
    mockAddressCubit = MockAddressCubit();
    mockCheckoutCubit = MockCheckoutCubit();
    // `BlocProvider.value` subscribes to `stream` on every cubit it holds, so
    // the checkout cubit needs one too even though this widget only dispatches
    // events to it.
    checkoutStub = CubitStreamStub(mockCheckoutCubit, const CheckoutState());
    addTearDown(checkoutStub.close);
  });

  Future<void> pumpApp(WidgetTester tester) async {
    // TODO(flutter-app): `_AddressTile` wraps its `RadioListTile` in a
    // `Container` with a background colour, which trips the ListTile
    // ink-visibility diagnostic on every build. Fixing it requires a
    // production change, so only that exact message is dropped here.
    FlutterDiagnosticTolerances.ignoreFlutterDiagnostics({
      FlutterDiagnosticTolerances.listTileInkVisibility,
    });
    addTearDown(FlutterDiagnosticTolerances.restoreFlutterErrorHandler);

    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: const Size(800, 1400),
        child: MaterialApp(
          home: Scaffold(
            body: MultiBlocProvider(
              providers: [
                BlocProvider<AddressCubit>.value(value: mockAddressCubit),
                BlocProvider<CheckoutCubit>.value(value: mockCheckoutCubit),
              ],
              child: const DeliveryAddressSection(),
            ),
          ),
        ),
      ),
    );
  }

  AddressState withAddresses({String? selectedAddressId}) => AddressState(
    addressesState: BaseState<List<AddressEntity>>(data: [tAddress]),
    selectedAddressId: selectedAddressId,
  );

  group('DeliveryAddressSection', () {
    testWidgets('renders the section title and the add new button', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(
        mockAddressCubit,
        const AddressState(
          addressesState: BaseState<List<AddressEntity>>(data: []),
        ),
      );
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.text(AppStrings.deliveryAddress), findsOneWidget);
      expect(find.text(AppStrings.addNew), findsOneWidget);
    });

    testWidgets('shows a loading indicator while the addresses are loading', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(
        mockAddressCubit,
        const AddressState(
          addressesState: BaseState<List<AddressEntity>>(isLoading: true),
        ),
      );
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows the empty state message when there is no address', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(
        mockAddressCubit,
        const AddressState(
          addressesState: BaseState<List<AddressEntity>>(data: []),
        ),
      );
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.text(AppStrings.noSavedAddresses), findsOneWidget);
    });

    testWidgets('shows the error message when loading the addresses fails', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(
        mockAddressCubit,
        const AddressState(
          addressesState: BaseState<List<AddressEntity>>(
            errorMessage: 'Failed to load addresses',
          ),
        ),
      );
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.text('Failed to load addresses'), findsOneWidget);
      expect(find.text(AppStrings.noSavedAddresses), findsNothing);
    });

    testWidgets('renders one tile per saved address', (tester) async {
      // Arrange
      stub = CubitStreamStub(mockAddressCubit, withAddresses());
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.byType(RadioListTile<String>), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('renders the address line and the area as the subtitle', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(mockAddressCubit, withAddresses());
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.text('2XVP+XC - Sheikh Zayed'), findsOneWidget);
    });

    testWidgets(
      'dispatches SelectAddressEvent and GetEstimationTimeEvent on select',
      (tester) async {
        // Arrange
        stub = CubitStreamStub(mockAddressCubit, withAddresses());
        addTearDown(stub.close);
        await pumpApp(tester);

        // Act
        await tester.tap(find.byType(RadioListTile<String>));
        await tester.pump();

        // Assert
        // TODO(flutter-app): the event classes have no `==` override, so the
        // dispatched instances are captured and inspected instead of matched.
        final addressEvents = verify(
          mockAddressCubit.doEvent(captureAny),
        ).captured;
        expect(addressEvents.single, isA<SelectAddressEvent>());
        // TODO(flutter-app): `SelectAddressEvent` accepts a required named
        // `addressId` argument but never stores it on a field, so the forwarded
        // id cannot be asserted here until production keeps it.
        expect(
          (addressEvents.single as SelectAddressEvent).selectedAddress,
          tAddress,
        );

        final checkoutEvents = verify(
          mockCheckoutCubit.doEvent(captureAny),
        ).captured;
        expect(checkoutEvents.single, isA<GetEstimationTimeEvent>());
        expect(
          (checkoutEvents.single as GetEstimationTimeEvent).addressId,
          tAddress.id,
        );
      },
    );

    testWidgets('marks the tile matching the selected address id', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(
        mockAddressCubit,
        withAddresses(selectedAddressId: 'address-1'),
      );
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      final tile = tester.widget<RadioListTile<String>>(
        find.byType(RadioListTile<String>),
      );
      // ignore: deprecated_member_use
      expect(tile.groupValue, 'address-1');
      expect(tile.value, 'address-1');
    });

    testWidgets('renders the edit button for each address', (tester) async {
      // Arrange
      stub = CubitStreamStub(mockAddressCubit, withAddresses());
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    });
  });
}

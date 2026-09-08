import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/manger/saved_address_event.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/manger/saved_address_state.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/manger/saved_address_view_model.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/view/saved_address_view.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/view/widgets/address_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSavedAddressViewModel extends MockCubit<SavedAddressState> implements SavedAddressViewModel {}

void main() {
  late MockSavedAddressViewModel mockViewModel;

  setUpAll(() {
    registerFallbackValue(LoadAddresses());
  });

  setUp(() {
    mockViewModel = MockSavedAddressViewModel();
    when(() => mockViewModel.doEvent(any())).thenAnswer((_) {});

    if (getIt.isRegistered<SavedAddressViewModel>()) {
      getIt.unregister<SavedAddressViewModel>();
    }
    getIt.registerFactory<SavedAddressViewModel>(() => mockViewModel);
  });

  tearDown(() {
    getIt.reset();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: const Size(375, 812),
        child: const MaterialApp(home: SavedAddressView()),
      ),
    );
  }

  testWidgets('shows loading indicator while addresses are loading', (tester) async {
    whenListen(
      mockViewModel,
      const Stream<SavedAddressState>.empty(),
      initialState: const SavedAddressState(
        addressesState: BaseState<List<AddressEntity>>(isLoading: true),
      ),
    );

    await pumpApp(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows empty state message when addresses list is empty', (tester) async {
    whenListen(
      mockViewModel,
      const Stream<SavedAddressState>.empty(),
      initialState: const SavedAddressState(
        addressesState: BaseState<List<AddressEntity>>(data: []),
      ),
    );

    await pumpApp(tester);

    expect(find.text('No saved addresses yet'), findsOneWidget);
  });

  testWidgets('renders AddressCards when addresses are loaded', (tester) async {
    final tAddress = AddressEntity(
      id: '1',
      recipientName: 'Mona Ahmed',
      recipientPhone: '01000000000',
      addressLine: '2XVP+XC',
      city: 'Cairo',
      area: 'Sheikh Zayed',
      isDefault: true,
      isServiceable: true,
      createdAt: DateTime.now(),
    );

    whenListen(
      mockViewModel,
      const Stream<SavedAddressState>.empty(),
      initialState: SavedAddressState(
        addressesState: BaseState<List<AddressEntity>>(data: [tAddress]),
      ),
    );

    await pumpApp(tester);
    await tester.pumpAndSettle();

    expect(find.byType(AddressCard), findsOneWidget);
    expect(find.text('Cairo'), findsOneWidget);
    expect(find.text('2XVP+XC - Sheikh Zayed'), findsOneWidget);
  });
}
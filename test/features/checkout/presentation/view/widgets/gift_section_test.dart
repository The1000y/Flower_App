import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_event.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_state.dart';
import 'package:flower_app/features/checkout/presentation/view/widgets/gift_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/cubit_stream_stub.dart';
import '../../../mocks/mocks.mocks.dart';

import '../../../fixtures/checkout_fixtures.dart';

void main() {
  late MockCheckoutCubit mockCubit;
  late CubitStreamStub<CheckoutState, MockCheckoutCubit> stub;
  late GlobalKey<FormState> formKey;

  setUp(() {
    mockCubit = MockCheckoutCubit();
    formKey = GlobalKey<FormState>();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: const Size(800, 1400),
        child: MaterialApp(
          home: Scaffold(
            body: BlocProvider<CheckoutCubit>.value(
              value: mockCubit,
              child: GiftSection(formKey: formKey),
            ),
          ),
        ),
      ),
    );
  }

  group('GiftSection', () {
    testWidgets('renders the gift switch and its label by default', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, const CheckoutState());
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.byType(Switch), findsOneWidget);
      expect(find.text(AppStrings.itIsAGift), findsOneWidget);
      expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
    });

    testWidgets('hides the gift fields while the switch is off', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, const CheckoutState());
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(
        find.widgetWithText(TextFormField, AppStrings.enterNameHint),
        findsNothing,
      );
      expect(
        find.widgetWithText(TextFormField, AppStrings.enterPhoneHintAlt),
        findsNothing,
      );
    });

    testWidgets('reveals the name and phone fields when it is a gift', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, const CheckoutState(isGift: true));
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(
        find.widgetWithText(TextFormField, AppStrings.nameLabel),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, AppStrings.phoneNumberLabel),
        findsOneWidget,
      );
    });

    testWidgets('reflects the isGift state on the switch', (tester) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, const CheckoutState(isGift: true));
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
    });

    testWidgets('dispatches ToggleGiftEvent when the switch is turned on', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, const CheckoutState());
      addTearDown(stub.close);
      await pumpApp(tester);

      // Act
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Assert
      // TODO(flutter-app): the event classes have no `==` override, so the
      // dispatched instance is captured and inspected instead of matched.
      final captured = verify(mockCubit.doEvent(captureAny)).captured;
      expect(captured.single, isA<ToggleGiftEvent>());
      expect((captured.single as ToggleGiftEvent).isGift, isTrue);
    });

    testWidgets('dispatches ToggleGiftEvent when the switch is turned off', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, const CheckoutState(isGift: true));
      addTearDown(stub.close);
      await pumpApp(tester);

      // Act
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Assert
      final captured = verify(mockCubit.doEvent(captureAny)).captured;
      expect((captured.single as ToggleGiftEvent).isGift, isFalse);
    });

    testWidgets(
      'dispatches ChangeGiftRecipientNameEvent when the name changes',
      (tester) async {
        // Arrange
        stub = CubitStreamStub(mockCubit, const CheckoutState(isGift: true));
        addTearDown(stub.close);
        await pumpApp(tester);

        // Act
        await tester.enterText(
          find.widgetWithText(TextFormField, AppStrings.nameLabel),
          'Mona',
        );
        await tester.pump();

        // Assert
        final captured = verify(mockCubit.doEvent(captureAny)).captured;
        expect(captured.single, isA<ChangeGiftRecipientNameEvent>());
        expect((captured.single as ChangeGiftRecipientNameEvent).name, 'Mona');
      },
    );

    testWidgets(
      'dispatches ChangeGiftRecipientPhoneEvent when the phone changes',
      (tester) async {
        // Arrange
        stub = CubitStreamStub(mockCubit, const CheckoutState(isGift: true));
        addTearDown(stub.close);
        await pumpApp(tester);

        // Act
        await tester.enterText(
          find.widgetWithText(TextFormField, AppStrings.phoneNumberLabel),
          '01012345678',
        );
        await tester.pump();

        // Assert
        final captured = verify(mockCubit.doEvent(captureAny)).captured;
        expect(captured.single, isA<ChangeGiftRecipientPhoneEvent>());
        expect(
          (captured.single as ChangeGiftRecipientPhoneEvent).phone,
          '01012345678',
        );
      },
    );

    testWidgets('shows a validation error for an empty gift name', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, const CheckoutState(isGift: true));
      addTearDown(stub.close);
      await pumpApp(tester);

      // Act
      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(AppStrings.giftNameValidation), findsOneWidget);
    });

    testWidgets('collapses the whole section for the COD payment method', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(
        mockCubit,
        const CheckoutState(
          selectedPaymentMethod: CheckoutFixtures.tCod,
          isGift: true,
        ),
      );
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(Switch), findsNothing);
      expect(find.text(AppStrings.itIsAGift), findsNothing);
      expect(find.byType(Form), findsNothing);
    });

    testWidgets('keeps the section visible for a non COD payment method', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(
        mockCubit,
        const CheckoutState(
          selectedPaymentMethod: CheckoutFixtures.tCard,
          isGift: true,
        ),
      );
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.byType(Form), findsOneWidget);
      expect(find.text(AppStrings.itIsAGift), findsOneWidget);
    });

    testWidgets('hides the section once COD gets selected on the stream', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, const CheckoutState(isGift: true));
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);
      stub.emit(
        const CheckoutState(
          selectedPaymentMethod: CheckoutFixtures.tCod,
          isGift: true,
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Form), findsNothing);
    });
  });
}

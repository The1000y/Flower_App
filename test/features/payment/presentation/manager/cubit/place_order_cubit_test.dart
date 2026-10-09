import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/checkout/presentation/manager/checkout_payment_method.dart';
import 'package:flower_app/features/payment/domain/entities/param/place_order_param.dart';
import 'package:flower_app/features/payment/domain/entities/place_order_entity.dart';
import 'package:flower_app/features/payment/presentation/manager/cubit/place_order_cubit.dart';
import 'package:flower_app/features/payment/presentation/manager/cubit/place_order_event.dart';
import 'package:flower_app/features/payment/presentation/manager/cubit/place_order_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.mocks.dart';
import '../../../mocks/test_dummies.dart';

void main() {
  late MockPlaceOrderUseCase useCase;

  const param = PlaceOrderParam(
    addressId: 'address-1',
    paymentMethod: CheckoutPaymentMethod.COD,
  );
  const entity = PlaceOrderEntity(
    message: 'created',
    orderId: 'order-1',
    sessionUrl: 'https://pay/session',
  );
  const loadingState = PlaceOrderState(
    placeOrderState: BaseState<PlaceOrderEntity>(isLoading: true),
  );

  setUp(() {
    registerPaymentTestDummies();
    useCase = MockPlaceOrderUseCase();
  });

  PlaceOrderCubit buildCubit() => PlaceOrderCubit(useCase);

  test('starts with an empty state', () {
    expect(buildCubit().state, const PlaceOrderState());
  });

  blocTest<PlaceOrderCubit, PlaceOrderState>(
    'emits [loading, success] when the order is accepted',
    build: () {
      when(
        useCase.call(any),
      ).thenAnswer((_) async => SuccessResponce<PlaceOrderEntity>(entity));
      return buildCubit();
    },
    act: (cubit) => cubit.doEvent(PostPlaceOrderEvent(placeOrderParam: param)),
    expect: () => [
      loadingState,
      PlaceOrderState(
        placeOrderState: BaseState<PlaceOrderEntity>(
          data: entity,
          isLoading: false,
        ),
      ),
    ],
    verify: (_) {
      verify(useCase.call(param)).called(1);
    },
  );

  blocTest<PlaceOrderCubit, PlaceOrderState>(
    'emits [loading, error] when the order is rejected',
    build: () {
      when(useCase.call(any)).thenAnswer(
        (_) async => ErrorResponce<PlaceOrderEntity>(Exception('boom')),
      );
      return buildCubit();
    },
    act: (cubit) => cubit.doEvent(PostPlaceOrderEvent(placeOrderParam: param)),
    expect: () => [
      loadingState,
      const PlaceOrderState(
        placeOrderState: BaseState<PlaceOrderEntity>(
          errorMessage: 'something went wrong, pls try again',
        ),
      ),
    ],
  );
}

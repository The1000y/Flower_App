import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/payment/data/model/response/place_order_dto.dart';
import 'package:flower_app/features/payment/domain/entities/place_order_entity.dart';
import 'package:mockito/mockito.dart';

/// Registers dummy values for [BaseResponce] generics so Mockito can build
/// fallback return values without throwing [MissingDummyValueError].
///
/// Call this once at the start of every payment test's `main()`.
void registerPaymentTestDummies() {
  provideDummy<BaseResponce<PlaceOrderDto>>(
    SuccessResponce<PlaceOrderDto>(PlaceOrderDto()),
  );
  provideDummy<BaseResponce<PlaceOrderEntity>>(
    SuccessResponce<PlaceOrderEntity>(const PlaceOrderEntity(message: '')),
  );
}

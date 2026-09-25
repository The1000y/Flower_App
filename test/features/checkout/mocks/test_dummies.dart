import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/checkout/data/model/responce/checkout_details_dto.dart';
import 'package:flower_app/features/checkout/data/model/responce/estimation_time_dto.dart';
import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';
import 'package:flower_app/features/checkout/domain/entities/estimation_time_entity.dart';
import 'package:mockito/mockito.dart';

/// Registers dummy values for [BaseResponce] generics so Mockito can capture
/// stub invocations without throwing [MissingDummyValueError].
///
/// Call this once at the start of every checkout test's `main()`.
void registerCheckoutTestDummies() {
  // Data-layer types.
  provideDummy<BaseResponce<CheckoutDetailsDto>>(
    SuccessResponce<CheckoutDetailsDto>(CheckoutDetailsDto()),
  );
  provideDummy<BaseResponce<EstimationTimeDto>>(
    SuccessResponce<EstimationTimeDto>(EstimationTimeDto()),
  );

  // Domain-layer types.
  provideDummy<BaseResponce<CheckoutDetailsEntity>>(
    SuccessResponce<CheckoutDetailsEntity>(
      const CheckoutDetailsEntity(
        subtotal: 0,
        deliveryFee: 0,
        total: 0,
        estimatedDeliveryAt: '',
        paymentMethods: [],
        isGift: false,
      ),
    ),
  );
  provideDummy<BaseResponce<EstimationTimeEntity>>(
    SuccessResponce<EstimationTimeEntity>(
      const EstimationTimeEntity(estimatedDeliveryAt: ''),
    ),
  );
}

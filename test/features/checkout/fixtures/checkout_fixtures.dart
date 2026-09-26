import 'package:flower_app/features/checkout/data/model/responce/checkout_details_dto.dart';
import 'package:flower_app/features/checkout/data/model/responce/checkout_responce.dart';
import 'package:flower_app/features/checkout/data/model/responce/estimation_time_dto.dart';
import 'package:flower_app/features/checkout/data/model/responce/estimation_time_response.dart';
import 'package:flower_app/features/checkout/data/model/responce/payment_methods_dto.dart';
import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';
import 'package:flower_app/features/checkout/domain/entities/estimation_time_entity.dart';

/// Fixed test data (fixtures) shared across the checkout feature tests.
class CheckoutFixtures {
  CheckoutFixtures._();

  // ---------------------------------------------------------------------
  // Payment methods
  // ---------------------------------------------------------------------
  static const String tCod = 'COD';
  static const String tCard = 'CARD';

  static const List<PaymentMethodEntity> tPaymentMethodEntities = [
    PaymentMethodEntity(method: tCod, gateways: ['cash']),
    PaymentMethodEntity(method: tCard, gateways: ['visa', 'mastercard']),
  ];

  static const PaymentMethodEntity tCodEntity = PaymentMethodEntity(
    method: tCod,
    gateways: ['cash'],
  );

  static const PaymentMethodEntity tCardEntity = PaymentMethodEntity(
    method: tCard,
    gateways: ['visa', 'mastercard'],
  );

  static final List<PaymentMethodsDto> tPaymentMethodsDtos = [
    PaymentMethodsDto(method: tCod, gateways: ['cash']),
    PaymentMethodsDto(method: tCard, gateways: ['visa', 'mastercard']),
  ];

  // ---------------------------------------------------------------------
  // Checkout details (entity / dto)
  // ---------------------------------------------------------------------
  static const String tEstimatedDeliveryAt = '2024-02-10T09:15:00.000Z';

  static const CheckoutDetailsEntity tCheckoutDetailsEntity =
      CheckoutDetailsEntity(
        subtotal: 200,
        deliveryFee: 30,
        total: 230,
        estimatedDeliveryAt: tEstimatedDeliveryAt,
        paymentMethods: tPaymentMethodEntities,
        isGift: false,
        giftRecipientName: 'Mona Ahmed',
        giftRecipientPhone: '01012345678',
      );

  static final CheckoutDetailsDto tCheckoutDetailsDto = CheckoutDetailsDto(
    subtotal: 200,
    deliveryFee: 30,
    total: 230,
    estimatedDeliveryAt: tEstimatedDeliveryAt,
    paymentMethods: tPaymentMethodsDtos,
    isGift: false,
    giftRecipientName: 'Mona Ahmed',
    giftRecipientPhone: '01012345678',
  );

  /// A DTO with every nullable field left `null` to cover the `toEntity()`
  /// default fallbacks.
  static final CheckoutDetailsDto tEmptyCheckoutDetailsDto =
      CheckoutDetailsDto();

  // ---------------------------------------------------------------------
  // Estimation time (entity / dto)
  // ---------------------------------------------------------------------
  static const String tAddressId = 'address-1';

  static const EstimationTimeEntity tEstimationTimeEntity =
      EstimationTimeEntity(estimatedDeliveryAt: tEstimatedDeliveryAt);

  static final EstimationTimeDto tEstimationTimeDto = EstimationTimeDto(
    estimatedDeliveryAt: tEstimatedDeliveryAt,
  );

  static final EstimationTimeDto tEmptyEstimationTimeDto = EstimationTimeDto();

  // ---------------------------------------------------------------------
  // Raw json payloads
  // ---------------------------------------------------------------------
  static const Map<String, dynamic> tCheckoutDetailsJson = {
    'subtotal': 200,
    'deliveryFee': 30,
    'total': 230,
    'estimatedDeliveryAt': tEstimatedDeliveryAt,
    'paymentMethods': [
      {
        'method': tCod,
        'gateways': ['cash'],
      },
      {
        'method': tCard,
        'gateways': ['visa', 'mastercard'],
      },
    ],
    'isGift': false,
    'giftRecipientName': 'Mona Ahmed',
    'giftRecipientPhone': '01012345678',
  };

  static const Map<String, dynamic> tCheckoutResponceJson = {
    'success': true,
    'message': 'Checkout details fetched',
    'data': tCheckoutDetailsJson,
    'error': null,
  };

  static const Map<String, dynamic> tEstimationTimeJson = {
    'estimatedDeliveryAt': tEstimatedDeliveryAt,
  };

  static const Map<String, dynamic> tEstimationTimeResponseJson = {
    'success': true,
    'message': 'Estimation time fetched',
    'data': tEstimationTimeJson,
    'error': null,
  };

  // ---------------------------------------------------------------------
  // Pre-built api responses
  // ---------------------------------------------------------------------
  static final CheckoutResponce tCheckoutResponce = CheckoutResponce(
    success: true,
    message: 'Checkout details fetched',
    data: tCheckoutDetailsDto,
  );

  static final EstimationTimeResponse tEstimationTimeResponse =
      EstimationTimeResponse(
        success: true,
        message: 'Estimation time fetched',
        data: tEstimationTimeDto,
      );
}

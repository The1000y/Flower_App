import 'package:json_annotation/json_annotation.dart';

import 'package:flower_app/features/commerce/domain/entities/cart/cart_entity.dart';

import 'cart_item_response_dto.dart';

part 'cart_response_dto.g.dart';

/// Hand-written on purpose: the cart endpoints are the only commerce routes
/// without a verified envelope, so both a `{ data: ... }` wrapper and a bare
/// cart body are accepted instead of guessing one shape.
class CartResponseDto {
  final CartDataDto? data;

  final bool isSuccess;

  final String? message;

  final String? messageLocalized;

  final String? statusCode;

  CartResponseDto({
    this.data,
    this.isSuccess = true,
    this.message,
    this.messageLocalized,
    this.statusCode,
  });

  /// Tolerates both response shapes used by the backend: an enveloped body
  /// (`{ data: {...}, isSuccess: ... }`) and a bare cart body
  /// (`{ items: [...], subtotal: ..., total: ... }`).
  factory CartResponseDto.fromJson(Map<String, dynamic> json) {
    final isEnveloped =
        json.containsKey('data') ||
        json.containsKey('isSuccess') ||
        json.containsKey('statusCode');

    if (isEnveloped) {
      return CartResponseDto(
        data: json['data'] == null
            ? null
            : CartDataDto.fromJson(json['data'] as Map<String, dynamic>),
        isSuccess: json['isSuccess'] as bool? ?? true,
        message: json['message'] as String?,
        messageLocalized: json['messageLocalized'] as String?,
        statusCode: json['statusCode']?.toString(),
      );
    }

    return CartResponseDto(data: CartDataDto.fromJson(json));
  }

  Map<String, dynamic> toJson() => {
    'data': data?.toJson(),
    'isSuccess': isSuccess,
    'message': message,
    'messageLocalized': messageLocalized,
    'statusCode': statusCode,
  };

  CartEntity toDomain() => (data ?? CartDataDto.empty()).toDomain();
}

@JsonSerializable()
class CartDataDto {
  @JsonKey(defaultValue: <CartItemResponseDto>[])
  final List<CartItemResponseDto> items;

  @JsonKey(defaultValue: 0.0)
  final double subtotal;

  final double? deliveryFee;

  @JsonKey(defaultValue: 0.0)
  final double total;

  @JsonKey(defaultValue: false)
  final bool hasChanges;

  CartDataDto({
    required this.items,
    required this.subtotal,
    this.deliveryFee,
    required this.total,
    required this.hasChanges,
  });

  /// An empty, well-formed cart, used when a response carries no cart payload.
  factory CartDataDto.empty() => CartDataDto(
    items: const [],
    subtotal: 0,
    total: 0,
    hasChanges: false,
  );

  factory CartDataDto.fromJson(Map<String, dynamic> json) =>
      _$CartDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CartDataDtoToJson(this);

  CartEntity toDomain() => CartEntity(
    items: items.map((item) => item.toDomain()).toList(),
    subtotal: subtotal,
    deliveryFee: deliveryFee,
    total: total,
    hasChanges: hasChanges,
  );
}

import 'package:json_annotation/json_annotation.dart';


part 'checkout_error.g.dart';

@JsonSerializable()
class CheckoutError {
  @JsonKey(name: "code")
  String? code;
  @JsonKey(name: "field")
  String? field;

  CheckoutError({this.code, this.field});

  factory CheckoutError.fromJson(Map<String, dynamic> json) => _$CheckoutErrorFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutErrorToJson(this);
}

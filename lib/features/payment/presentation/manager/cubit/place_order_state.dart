import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/payment/domain/entities/place_order_entity.dart';

class PlaceOrderState extends Equatable {
  final BaseState<PlaceOrderEntity> placeOrderState;
  const PlaceOrderState({this.placeOrderState = const BaseState()});

  PlaceOrderState copyWith({BaseState<PlaceOrderEntity>? placeOrderState}) {
    return PlaceOrderState(
      placeOrderState: placeOrderState ?? this.placeOrderState,
    );
  }

  @override
  List<Object> get props => [placeOrderState];
}

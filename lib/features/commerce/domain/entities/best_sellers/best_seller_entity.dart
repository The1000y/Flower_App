// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class BestSellerEntity extends Equatable {
  final int id;
  final String name;
  final String imageUrl;
  final String currency;
  final int price;
  final int originalPrice;
  final int discountPercentage;
  final String status;
  
  const BestSellerEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.currency,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    currency,
    price,
    originalPrice,
    discountPercentage,
    status,
  ];
}

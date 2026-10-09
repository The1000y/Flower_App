import 'package:equatable/equatable.dart';

enum SectionType { bestSeller, category, occasion }

class SectionEntity extends Equatable {
  final String id;
  final SectionType type;
  final int index;
  final bool isActive;
  final String title;
  final String? occasionId;
  final String? categoryId;

  const SectionEntity({
    required this.id,
    required this.type,
    required this.index,
    required this.isActive,
    required this.title,
    this.occasionId,
    this.categoryId,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    index,
    isActive,
    title,
    occasionId,
    categoryId,
  ];
}

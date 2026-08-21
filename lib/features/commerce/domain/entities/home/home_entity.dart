class HomeEntity {
  final int id;
  final String type;
  final int index;
  final bool isActive;
  final String? title;
  final int? occasionId;
  final int? categoryId;

  HomeEntity({
    required this.id,
    required this.type,
    required this.index,
    required this.isActive,
    this.title,
    this.occasionId,
    this.categoryId,
  });
}
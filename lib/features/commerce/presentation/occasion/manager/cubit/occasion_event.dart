sealed class OccasionEvent {}

class LoadOccasions extends OccasionEvent {}

class LoadProductsForOccasion extends OccasionEvent {
  final int occasionId;
  LoadProductsForOccasion(this.occasionId);
}
sealed class OccasionEvent {}

class LoadOccasions extends OccasionEvent {
  final String? initialOccasionName;
LoadOccasions({this.initialOccasionName});
}

class LoadProductsForOccasion extends OccasionEvent {
  final int occasionId;
  LoadProductsForOccasion(this.occasionId);
}

class LoadMoreProducts extends OccasionEvent {}
sealed class SearchEvent {}

class SearchProductsEvent extends SearchEvent {
  final String query;
  SearchProductsEvent(this.query);
}

class LoadMoreSearchEvent extends SearchEvent {}
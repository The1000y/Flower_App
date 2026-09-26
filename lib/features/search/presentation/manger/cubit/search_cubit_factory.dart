import 'package:flower_app/features/search/presentation/manger/cubit/search_cubit.dart';

/// Supplies [SearchCubit] instances to the route generator.
///
/// Mirrors `ProfileViewModelFactory`: the router depends on this abstraction
/// instead of the service locator, so route construction stays testable.
abstract class SearchCubitFactory {
  SearchCubit create();
}

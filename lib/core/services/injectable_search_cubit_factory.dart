import 'package:flower_app/features/search/presentation/manger/cubit/search_cubit.dart';
import 'package:flower_app/features/search/presentation/manger/cubit/search_cubit_factory.dart';

/// [SearchCubitFactory] backed by a resolver function.
///
/// The resolver is supplied by the DI module, which keeps the container out of
/// the factory and lets tests pass a plain closure.
class InjectableSearchCubitFactory implements SearchCubitFactory {
  InjectableSearchCubitFactory(this._resolve);

  final SearchCubit Function() _resolve;

  @override
  SearchCubit create() => _resolve();
}

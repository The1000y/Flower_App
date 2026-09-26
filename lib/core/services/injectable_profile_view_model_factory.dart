import 'package:flower_app/features/profile/presentation/manager/profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_view_model_factory.dart';

/// [ProfileViewModelFactory] backed by a resolver function.
///
/// The resolver is supplied by the DI module, which keeps the container out of
/// the factory and lets tests pass a plain closure.
class InjectableProfileViewModelFactory implements ProfileViewModelFactory {
  InjectableProfileViewModelFactory(this._resolve);

  final ProfileViewModel Function() _resolve;

  @override
  ProfileViewModel create() => _resolve();
}

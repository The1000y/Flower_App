import 'package:flower_app/features/profile/presentation/manager/profile_view_model.dart';

/// Supplies [ProfileViewModel] instances to the route generator.
///
/// The router depends on this abstraction rather than on the service locator, so
/// route construction can be exercised with a test double.
abstract class ProfileViewModelFactory {
  ProfileViewModel create();
}

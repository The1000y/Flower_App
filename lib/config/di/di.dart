import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

/// Application service locator.
///
/// Widgets and routers must not call `getIt` directly: collaborators are
/// resolved at the composition root (`main`) and injected downwards.
final GetIt getIt = GetIt.instance;

@InjectableInit(initializerName: 'init', preferRelativeImports: true)
Future<void> configureDependencies() => getIt.init();

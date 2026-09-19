import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  @lazySingleton
  AssetBundle get assetBundle => rootBundle;
}

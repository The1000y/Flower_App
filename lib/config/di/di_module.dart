import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/services/injectable_profile_view_model_factory.dart';
import 'package:flower_app/core/services/injectable_search_cubit_factory.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_view_model_factory.dart';
import 'package:flower_app/features/search/presentation/manger/cubit/search_cubit.dart';
import 'package:flower_app/features/search/presentation/manger/cubit/search_cubit_factory.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @lazySingleton
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  /// Bridges the service locator to the route generator. This is the single
  /// place where the container is consulted for a `ProfileViewModel`.
  @lazySingleton
  ProfileViewModelFactory get profileViewModelFactory =>
      InjectableProfileViewModelFactory(() => getIt<ProfileViewModel>());

  /// Same bridge for the search cubit, so `AppRoutes` stays locator-free.
  @lazySingleton
  SearchCubitFactory get searchCubitFactory =>
      InjectableSearchCubitFactory(() => getIt<SearchCubit>());
}

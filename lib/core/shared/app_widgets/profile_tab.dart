import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The profile tab of the bottom navigation bar.
///
/// It owns the scope of its own `ProfileViewModel`: the view model is created
/// here, with `BlocProvider`, so it is built lazily when the tab is first shown
/// and closed with the tab. The rest of the tree does not have to know about it.
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileViewModel>(
      create: (_) => getIt<ProfileViewModel>(),
      child: const ProfileView(),
    );
  }
}

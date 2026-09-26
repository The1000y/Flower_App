import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/presentation/categories/view/categories.dart';
import 'package:flower_app/features/commerce/presentation/home/view/home_view.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../../constants/app_strings/app_strings.dart';

class PersistenBottomNavBarDemo extends StatelessWidget {
  PersistenBottomNavBarDemo({super.key, this.profileViewModel});

  /// Resolved by the caller (the route generator) and injected here, so this
  /// widget stays free of service-locator lookups and can be widget-tested.
  final ProfileViewModel? profileViewModel;

  /// The profile tab, or an explicit placeholder when no view model was
  /// supplied. Exposed for testing: the surrounding bar pulls cubits from the
  /// service locator (HomeView, CategoriesView) and cannot be pumped in
  /// isolation, but this expression can.
  @visibleForTesting
  static Widget resolveProfileTab(ProfileViewModel? viewModel) {
    // `ProfileView` requires an ancestor `BlocProvider<ProfileViewModel>`. An
    // eager `viewModel ?? context.read<ProfileViewModel>()` fallback would throw
    // ProviderNotFoundException whenever the caller did not supply one, so the
    // unavailable case renders an explicit placeholder instead.
    if (viewModel == null) {
      return const Scaffold(
        body: Center(child: Text('Profile is unavailable')),
      );
    }

    return BlocProvider<ProfileViewModel>.value(
      value: viewModel,
      child: const ProfileView(),
    );
  }

  final PersistentTabController controller = PersistentTabController(
    initialIndex: 0,
  );

  @override
  Widget build(BuildContext context) {
    final homeScreen = HomeView(controller: controller);
    final categoriesScreen = CategoriesView();
    final cartScreen = Placeholder();
    final profileScreen = resolveProfileTab(profileViewModel);

    return PersistentTabView(
      controller: controller,
      tabs: [
        PersistentTabConfig(
          screen: homeScreen,
          item: ItemConfig(
            icon: Icon(Icons.home),
            title: AppStrings.navHome,
            activeForegroundColor: AppColors.pinkBase,
          ),
        ),
        PersistentTabConfig(
          screen: categoriesScreen,
          item: ItemConfig(
            icon: Icon(Icons.category),
            title: AppStrings.navcategories,
            activeForegroundColor: AppColors.pinkBase,
          ),
        ),
        PersistentTabConfig(
          screen: cartScreen,
          item: ItemConfig(
            icon: Icon(Icons.shopping_cart),
            title: AppStrings.navCart,
            activeForegroundColor: AppColors.pinkBase,
          ),
        ),
        PersistentTabConfig(
          screen: profileScreen,
          item: ItemConfig(
            icon: Icon(Icons.person),
            title: AppStrings.navProfile,
            activeForegroundColor: AppColors.pinkBase,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) =>
          Style1BottomNavBar(navBarConfig: navBarConfig),
    );
  }
}

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

  final PersistentTabController controller = PersistentTabController(
    initialIndex: 0,
  );

  @override
  Widget build(BuildContext context) {
    final homeScreen = HomeView(controller: controller);
    final categoriesScreen = CategoriesView();
    final cartScreen = Placeholder();
    final profileScreen = BlocProvider<ProfileViewModel>.value(
      value: profileViewModel ?? context.read<ProfileViewModel>(),
      child: const ProfileView(),
    );

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

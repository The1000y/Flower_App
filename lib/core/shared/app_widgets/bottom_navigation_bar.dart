import 'package:flower_app/core/shared/app_widgets/profile_tab.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/presentation/categories/view/categories.dart';
import 'package:flower_app/features/commerce/presentation/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../../constants/app_strings/app_strings.dart';

class PersistenBottomNavBarDemo extends StatelessWidget {
  PersistenBottomNavBarDemo({super.key});

  /// Shared by the tabs so switching back to one keeps its state, matching the
  /// behaviour of the surrounding `HomeView`/`CategoriesView` screens. Not
  /// `const`-constructible: [PersistentTabController] is a mutable object, so it
  /// is created once per instance rather than per build.
  final PersistentTabController controller = PersistentTabController(
    initialIndex: 0,
  );

  @override
  Widget build(BuildContext context) {
    final homeScreen = HomeView(controller: controller);
    final categoriesScreen = const CategoriesView();
    final cartScreen = const Placeholder();
    final profileScreen = const ProfileTab();

    return PersistentTabView(
      controller: controller,
      tabs: [
        PersistentTabConfig(
          screen: homeScreen,
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: AppStrings.navHome,
            activeForegroundColor: AppColors.pinkBase,
          ),
        ),
        PersistentTabConfig(
          screen: categoriesScreen,
          item: ItemConfig(
            icon: const Icon(Icons.category),
            title: AppStrings.navcategories,
            activeForegroundColor: AppColors.pinkBase,
          ),
        ),
        PersistentTabConfig(
          screen: cartScreen,
          item: ItemConfig(
            icon: const Icon(Icons.shopping_cart),
            title: AppStrings.navCart,
            activeForegroundColor: AppColors.pinkBase,
          ),
        ),
        PersistentTabConfig(
          screen: profileScreen,
          item: ItemConfig(
            icon: const Icon(Icons.person),
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

import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/presentation/cart/view/cart.dart';
import 'package:flower_app/features/commerce/presentation/categories/view/categories.dart';
import 'package:flower_app/features/commerce/presentation/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../../constants/app_strings/app_strings.dart';

class PersistentBottomNavBarDemo extends StatelessWidget {
  PersistentBottomNavBarDemo({
    super.key,
    this.onCartTabSelected,
  });

  final VoidCallback? onCartTabSelected;

  final Widget homeScreen = HomeView();

  final Widget categoriesScreen = Categories_view();

  final Widget profileScreen2 = Placeholder();

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      onTabChanged: (index) {
        if (index == 2) {
          onCartTabSelected?.call();
        }
      },
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
          screen: const CartView(),
          item: ItemConfig(
            icon: const Icon(Icons.shopping_cart),
            title: AppStrings.navCart,
            activeForegroundColor: AppColors.pinkBase,
          ),
        ),
        PersistentTabConfig(
          screen: profileScreen2,
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
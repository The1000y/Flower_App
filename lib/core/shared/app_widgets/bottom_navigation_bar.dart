import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/presentation/cart/view/cart.dart';
import 'package:flower_app/features/commerce/presentation/categories/view/categories.dart';
import 'package:flower_app/features/commerce/presentation/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../../constants/app_strings/app_strings.dart';

class PersistenBottomNavBarDemo extends StatelessWidget {
  PersistenBottomNavBarDemo({super.key});

  // Key للوصول إلى State الخاص بالـ Cart
  final GlobalKey<CardViewState> cartKey =
      GlobalKey<CardViewState>();

  final Widget homeScreen = HomeView();

  final Widget categoriesScreen = Categories_view();

  final Widget profileScreen2 = Placeholder();

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      onTabChanged: (index) {
        // Cart هو الـ tab رقم 2
        if (index == 2) {
          cartKey.currentState?.refreshCart();
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
          screen: Card_view(
            key: cartKey,
          ),
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
          Style1BottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}
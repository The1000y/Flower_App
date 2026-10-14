import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/presentation/cart/view/cart.dart';
import 'package:flower_app/features/commerce/presentation/categories/view/categories.dart';
import 'package:flower_app/features/commerce/presentation/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../../constants/app_strings/app_strings.dart';

class PersistentBottomNavBarDemo extends StatefulWidget {
  const PersistentBottomNavBarDemo({super.key, this.onCartTabSelected});

  final VoidCallback? onCartTabSelected;

  @override
  State<PersistentBottomNavBarDemo> createState() =>
      _PersistentBottomNavBarDemoState();
}

class _PersistentBottomNavBarDemoState
    extends State<PersistentBottomNavBarDemo> {
  /// The controller is owned by this screen and disposed with it.
  ///
  /// A [PersistentTabController] carries the [Scaffold]'s [GlobalKey], so a
  /// single controller shared between two live `PersistentTabView`s (for
  /// example while a new home route animates over the previous one) would
  /// attach the same key to both trees and throw "Duplicate GlobalKey detected
  /// in widget tree". Creating it per instance keeps every key unique.
  late final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  late final Widget _homeScreen = HomeView(controller: _controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      onTabChanged: (index) {
        if (index == 2) {
          widget.onCartTabSelected?.call();
        }
      },
      tabs: [
        PersistentTabConfig(
          screen: _homeScreen,
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: AppStrings.navHome,
            activeForegroundColor: AppColors.pinkBase,
          ),
        ),
        PersistentTabConfig(
          screen: const CategoriesView(),
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
          screen: const Placeholder(),
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

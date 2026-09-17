import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/presentation/categories/view/categories.dart';
import 'package:flower_app/features/commerce/presentation/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_viewModel.dart';
import 'package:flower_app/features/profile/presentation/view/profile_home_view.dart';
import '../../constants/app_strings/app_strings.dart';

class PersistenBottomNavBarDemo extends StatelessWidget {
  PersistenBottomNavBarDemo({super.key});
  final PersistentTabController controller = PersistentTabController(
    initialIndex: 0,
  );

  @override
  Widget build(BuildContext context) {
    final homeScreen = HomeView(controller: controller);
    final categoriesScreen = CategoriesView();
    final cartScreen = Placeholder();
    final profileScreen = BlocProvider(
      create: (_) => getIt<ProfileHomeViewModel>(),
      child: const ProfileHomeView(),
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

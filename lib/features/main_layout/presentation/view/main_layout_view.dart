import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/presentation/home/view/home_view.dart';
import 'package:flutter/material.dart';

class MainLayoutView extends StatefulWidget {
  const MainLayoutView({super.key});

  @override
  State<MainLayoutView> createState() => _MainLayoutViewState();
}

class _MainLayoutViewState extends State<MainLayoutView> {
  int _currentIndex = 0;

  static const List<Widget> _tabs = [
    HomeView(),
    _ComingSoonTab(label: AppStrings.navcategories),
    _ComingSoonTab(label: AppStrings.navCart),
    _ComingSoonTab(label: AppStrings.navProfile),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) =>
            setState(() => _currentIndex = index),
        backgroundColor: AppColors.whiteBase,
        indicatorColor: AppColors.lightPink,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.pinkBase),
            label: AppStrings.navHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon:
                Icon(Icons.grid_view_rounded, color: AppColors.pinkBase),
            label: AppStrings.navcategories,
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon:
                Icon(Icons.shopping_cart_rounded, color: AppColors.pinkBase),
            label: AppStrings.navCart,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.pinkBase),
            label: AppStrings.navProfile,
          ),
        ],
      ),
    );
  }
}

class _ComingSoonTab extends StatelessWidget {
  const _ComingSoonTab({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      appBar: AppBar(title: Text(label)),
      body: Center(
        child: Text(
          '$label ${AppStrings.comingSoon}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}

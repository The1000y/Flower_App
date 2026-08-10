import 'package:flower_app/core/shared/app_widgets/product_card.dart';
import 'package:flower_app/core/shared/app_widgets/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class PersistenBottomNavBarDemo extends StatelessWidget {
  @override
  final Widget gomeScreen = TestScreen();
  final Widget categoriesScreen = Padding(
    padding: const EdgeInsets.all(30.0),
    child: ProductCard(image: '', name: '', price: 2, onAddToCart: () => {}),
  );
  final Widget cartScreen = Placeholder();
  final Widget profileScreen2 = Placeholder();
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persistent Bottom Navigation Bar Demo',
      home: PersistentTabView(
        tabs: [
          PersistentTabConfig(
            screen: gomeScreen,
            item: ItemConfig(
              icon: Icon(Icons.home),
              title: "home",
              activeForegroundColor: Colors.pink,
            ),
          ),
          PersistentTabConfig(
            screen: categoriesScreen,
            item: ItemConfig(
              icon: Icon(Icons.category),
              title: "Categories",
              activeForegroundColor: Colors.pink,
            ),
          ),
          PersistentTabConfig(
            screen: cartScreen,
            item: ItemConfig(
              icon: Icon(Icons.shopping_cart),
              title: "Cart",
              activeForegroundColor: Colors.pink,
            ),
          ),
          PersistentTabConfig(
            screen: profileScreen2,
            item: ItemConfig(
              icon: Icon(Icons.person),
              title: "Profile",
              activeForegroundColor: Colors.pink,
            ),
          ),
        ],
        navBarBuilder: (navBarConfig) =>
            Style1BottomNavBar(navBarConfig: navBarConfig),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Text("comming soon", style: Theme.of(context).textTheme.titleLarge),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

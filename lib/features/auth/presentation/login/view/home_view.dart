import 'package:flower_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Text(
              context.l10n.comingSoon,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

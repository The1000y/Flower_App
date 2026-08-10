import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Screen'),
      ),
      body: const Center(
        child: CustomButton(
          text: 'Click Me',
          onPressed: null,
          isEnabled: true,
          enabledColor: Colors.pink,
        ),
      ),
    );
  }
}
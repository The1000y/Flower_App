import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.textStyle,
    required this.title,
    required this.onBack,
  });

  final TextStyle? textStyle;
  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back_ios),
      ),
      titleSpacing: 0,
      title: Text(title, style: textStyle),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

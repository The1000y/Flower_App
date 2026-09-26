import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';

/// Only the constant part of the trailing style is hoisted; the colour stays a
/// parameter because the caller supplies it per tile.
const TextStyle _trailingTextStyleTemplate = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w500,
);

TextStyle _trailingTextStyle(Color color) =>
    _trailingTextStyleTemplate.copyWith(color: color);

class ProfileOptionTile extends StatelessWidget {
  final IconData? icon;
  final Widget? leading;
  final String title;
  final Widget? trailing;
  final String? trailingText;
  final Color? trailingTextColor;
  final VoidCallback onTap;

  const ProfileOptionTile({
    super.key,
    this.icon,
    this.leading,
    required this.title,
    required this.onTap,
    this.trailing,
    this.trailingText,
    this.trailingTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            if (leading != null)
              leading!
            else if (icon != null)
              Icon(icon, size: 20, color: Colors.black87),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (trailingText != null)
              Text(
                trailingText!,
                // The colour is dynamic, so only the constant part of the style
                // can be `const`.
                style: _trailingTextStyle(
                  trailingTextColor ?? AppColors.pinkBase,
                ),
              )
            else
              const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

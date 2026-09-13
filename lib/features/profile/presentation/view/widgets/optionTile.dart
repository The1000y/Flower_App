import 'package:flutter/material.dart';


class ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final String? trailingText;
  final VoidCallback onTap;

  const ProfileOptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (trailingText != null)
              Text(
                trailingText!,
                style: const TextStyle(
                  fontSize: 10,
                ),
              )
            else
              const Icon(
                Icons.chevron_right,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
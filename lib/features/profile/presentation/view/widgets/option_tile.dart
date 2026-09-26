import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// A single row in the profile options list (orders, addresses, logout, ...).
class ProfileOptionTile extends StatelessWidget {
  const ProfileOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
    this.trailingText,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  final String? trailingText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: AppColors.blackBase),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blackBase,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (trailingText != null)
              Text(
                trailingText!,
                style: TextStyle(fontSize: 12.sp, color: AppColors.white90),
              )
            else
              Icon(Icons.chevron_right, size: 20.sp, color: AppColors.white90),
          ],
        ),
      ),
    );
  }
}

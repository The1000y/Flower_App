import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';


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
        padding:  EdgeInsets.symmetric(
          horizontal: 16.h,
          vertical: 14.w,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18.h,
            ),
             SizedBox(width: 10.h),
            Expanded(
              child: Text(
                title,
                style:  TextStyle(
                  fontSize: 12.sp,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (trailingText != null)
              Text(
                trailingText!,
                style:  TextStyle(
                  fontSize: 10.sp,
                ),
              )
            else
               Icon(
                Icons.chevron_right,
                size: 18.sp,
              ),
          ],
        ),
      ),
    );
  }
}
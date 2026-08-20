import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/commerce/presentation/categories/view/widgets/filterView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/themes/app_colors/app_color.dart';

class Positionedbottomsheet extends StatelessWidget {
  const Positionedbottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 5.h,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    

                    FilterView(),
                  ],
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.pinkBase,
              borderRadius: BorderRadius.circular(30.sp),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.tune, color: Colors.white),

                SizedBox(width: 8.w),
                Text(
                  'Filter',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

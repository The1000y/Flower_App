import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

enum SortType {
  recommended,
  newest,
  priceLowToHigh,
  priceHighToLow,
}

class BuildSortItemFilter extends StatelessWidget {
  const BuildSortItemFilter({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String title;
  final SortType value;

  final SortType? groupValue;

  final ValueChanged<SortType?> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Container(
        height: 64.h,
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(),

            Radio<SortType>(
              value: value,

              groupValue: groupValue,

              activeColor: Colors.pink,

              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
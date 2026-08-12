import 'dart:developer';

import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final double price;
  final double? oldPrice;
  final int? discount;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    this.oldPrice,
    this.discount,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 320.w,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                image,
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
                errorBuilder: (_, error, stackTrace) {
                  log(
                    'Error loading image++++++++++++++++++++++++++++++++++++++++++++++++++++: $error',
                  );
                  (error);
                  return Center(
                    child: const Icon(Icons.image_not_supported, size: 100),
                  );
                },
              ),
            ),

            SizedBox(height: 12.h),

            Text(
              name,
              style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w500),
            ),

            SizedBox(height: 8.h),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'EGP ${price.toInt()}',
                  style: TextStyle(
                    fontSize: 27.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                if (oldPrice != null) ...[
                  SizedBox(width: 12.w),

                  Text(
                    'EGP ${oldPrice!.toInt()}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color:AppColors.gray,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],

                if (discount != null) ...[
                  SizedBox(width: 10.w),

                  Text(
                    '$discount%',
                    style: TextStyle(fontSize: 20.sp, color: Colors.green),
                  ),
                ],
              ],
            ),

            SizedBox(height: 12.h),

            SizedBox(
              width: 292.w,
              height: 58.h,
              child: ElevatedButton.icon(
                onPressed: onAddToCart,
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.whiteBase,
                  size: 28.sp,
                ),
                label: Text(
                 AppStrings.addToCart,
                  style: TextStyle(fontSize: 22.sp, color: Colors.white),
                ),
               /* style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD81B60),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFD81B60),
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),*/
              ),
            ),
          ],
        ),
      ),
    );
  }
}

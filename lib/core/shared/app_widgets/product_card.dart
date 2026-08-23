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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Product Image
          SizedBox(
            height: 150.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                image,
                width: double.infinity,
                height: 150.h,
                fit: BoxFit.cover,
                errorBuilder: (_, error, stackTrace) {
                  log('Error loading image: $error');

                  return const Center(
                    child: Icon(Icons.image_not_supported, size: 60),
                  );
                },
              ),
            ),
          ),

          SizedBox(height: 8.h),

          /// Product Name
          Text(
            "   $name",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
          ),

          SizedBox(height: 6.h),

          /// Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (oldPrice != null || discount != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //   SizedBox(width: 10.w),
                    Text(
                      'EGP ${price.toInt()}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 15.w),
                    if (oldPrice != null)
                      Flexible(
                        child: Text(
                          '${oldPrice!.toInt()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.black100,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),

                    if (oldPrice != null && discount != null)
                      SizedBox(width: 10.w),

                    if (discount != null)
                      Text(
                        '$discount%',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
            ],
          ),

          SizedBox(height: 8.h),

          /// Add To Cart Button
          SizedBox(
            width: double.infinity,
            height: 45.h,
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.pinkBase),
              ),
              onPressed: onAddToCart,
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.whiteBase,
                size: 20.sp,
              ),
              label: Text(
                AppStrings.addToCart,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
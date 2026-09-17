import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../core/shared/app_widgets/custom_button.dart';

class OrderCardWidget extends StatelessWidget {
  final String orderName;
  final String orderPrice;
  final String orderId;
  final String orderDeliverDate;
  final bool isActive;
  final String imageUrl;

  const OrderCardWidget({
    required this.orderName,
    required this.orderPrice,
    required this.orderId,
    required this.orderDeliverDate,
    required this.isActive,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grayDark),
      ),
      child: Padding(
        padding:  EdgeInsets.all(8.w),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 100.h,
                width: 100.w,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(orderName),
                  Text(orderPrice),
                  Text(
                    isActive
                        ? "Order number $orderId"
                        : "Delivered on $orderDeliverDate",
                  ),
                  CustomButton(
                    text: isActive ? "Track order" : "Reorder",
                    isEnabled: true,
                    onPressed: () {},
                    enabledColor: AppColors.pinkBase,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

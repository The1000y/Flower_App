// lib/features/addresses/presentation/saved_address/view/widgets/address_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/themes/app_colors/app_color.dart';
import '../../../../domain/entities/address_entity.dart';

class AddressCard extends StatelessWidget {
  final AddressEntity address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onSelect;

  const AddressCard({
    super.key,
    required this.address,
    required this.onEdit,
    required this.onDelete,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_on_outlined, color: AppColors.pinkBase, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.city,
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${address.addressLine} - ${address.area}',
                    style: TextStyle(fontSize: 13.sp, color: AppColors.gray),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: AppColors.error, size: 22.sp),
              onPressed: onDelete,
            ),
            IconButton(
              icon: Icon(Icons.edit_outlined, color: AppColors.gray, size: 20.sp),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}
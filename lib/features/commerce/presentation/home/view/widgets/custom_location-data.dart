import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_outlined_button.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flutter/material.dart';

// custom_location-data.dart

class CustomLocationData extends StatelessWidget {
  const CustomLocationData({
    super.key,
    required this.textTheme,
    this.selectedAddress,
    this.addresses = const [],
    this.onAddressTap,
    this.onAddNewAddressTap,
    this.onAddressChanged,
  });

  final TextTheme textTheme;
  final AddressEntity? selectedAddress;
  final List<AddressEntity> addresses;
  final VoidCallback? onAddNewAddressTap;
  final Function(AddressEntity)? onAddressChanged;
  final VoidCallback? onAddressTap;

  @override
  Widget build(BuildContext context) {
    if (addresses.isEmpty) {
      return Center(
        child: CustomOutlinedButton(
          onPressed: onAddNewAddressTap,
          text: AppStrings.addYourAddress,
        ),
      );
    }

    final selectedId =
        addresses.any((address) => address.id == selectedAddress?.id)
        ? selectedAddress?.id
        : null;
    if (addresses.isNotEmpty) {
      return DropdownButton<String>(
        isExpanded: true,

        value: selectedId,

        items: [
          // العناوين الموجودة
          ...addresses.map(
            (addr) => DropdownMenuItem(
              value: addr.id,
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColors.pinkBase,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${addr.label}, ${addr.addressLine}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // إضافة عنوان جديد
          const DropdownMenuItem(
            value: 'add_new_address',
            child: Row(
              children: [
                Icon(Icons.add_location_alt_outlined, size: 18),
                SizedBox(width: 8),
                Text('Add New Address'),
              ],
            ),
          ),
        ],

        onChanged: (selectedId) {
          if (selectedId == null) return;

          // لو اختار إضافة عنوان
          if (selectedId == 'add_new_address') {
            onAddNewAddressTap?.call();
            return;
          }

          // لو اختار عنوان موجود
          final newAddress = addresses.firstWhere(
            (addr) => addr.id == selectedId,
          );

          onAddressChanged?.call(newAddress);
        },
      );
    }

    return SizedBox.shrink();
  }
}

import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_events.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_state.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_event.dart';
// import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class DeliveryAddressSection extends StatelessWidget {
  const DeliveryAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final cubit = context.read<AddressCubit>();
    final cubit2 = context.read<CheckoutCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.deliveryAddress,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<AddressCubit, AddressState>(
            buildWhen: (previous, current) =>
                previous.addressesState != current.addressesState ||
                previous.selectedAddressId != current.selectedAddressId,
            builder: (context, state) {
              final addressesState = state.addressesState;
              final addresses = addressesState.data ?? const [];

              if (addressesState.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (addresses.isEmpty) {
                return Text(
                  addressesState.errorMessage.isNotEmpty
                      ? addressesState.errorMessage
                      : AppStrings.noSavedAddresses,
                );
              }
              return Column(
                children: [
                  for (final address in addresses) ...[
                    if (addresses.indexOf(address) > 0) const SizedBox(height: 16),
                    _AddressTile(
                      address: address,
                      groupValue: state.selectedAddressId ?? '',
                      onSelect: () {
                        cubit.doEvent(
                          SelectAddressEvent(
                            addressId: address.id,
                            selectedAddress: address,
                          ),
                        );
                        cubit2.doEvent(
                          GetEstimationTimeEvent(addressId: address.id),
                        );
                      },
                      // onSelect: () => context.read<CheckoutCubit>().doEvent(
                      //   //هنغير اسمها الى estimation time event لانها بتتغير
                      //   SelectDeliveryAddressEvent(addressId: addresses[i].id),
                      // ),
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              await Navigator.pushNamed(context, Routes.addAddress);
              if (!cubit.isClosed) {
                cubit.doEvent(FetchUserAddressesEvent());
              }
            },
            icon: Icon(Icons.add, color: AppColors.pinkBase, size: 22.sp),
            label: Text(
              AppStrings.addNew,
              style: TextStyle(
                color: AppColors.pinkBase,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  const _AddressTile({
    required this.address,
    required this.groupValue,
    required this.onSelect,
  });

  final AddressEntity address;
  final String groupValue;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final subtitle = [
      address.addressLine,
      address.area,
    ].where((part) => part.isNotEmpty).join(' - ');

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray.withValues(alpha: 0.27),
            blurRadius: 5,
            blurStyle: BlurStyle.outer,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: RadioListTile<String>.adaptive(
        contentPadding: EdgeInsets.zero,
        title: Text(
          address.label ?? '',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        subtitle: Text(subtitle),
        secondary: IconButton(
          icon: Icon(Icons.edit_outlined, color: AppColors.gray, size: 28.sp),
          onPressed: () {
            Navigator.pushNamed(context, Routes.addAddress, arguments: address);
          },
        ),
        value: address.id,
        groupValue: groupValue,
        onChanged: (_) => onSelect(),
      ),
    );
  }
}

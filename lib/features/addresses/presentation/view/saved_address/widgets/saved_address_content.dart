import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/constants/app_strings/app_strings.dart';
import '../../../../../../core/themes/app_colors/app_color.dart';
import '../../../../domain/entities/address_entity.dart';
import '../../../manager/cubit/address_state.dart';
import '../../../manager/cubit/add_address_cubit.dart';
import 'saved_address_animated_list.dart';

class SavedAddressContent extends StatelessWidget {
  const SavedAddressContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressCubit, AddressState>(
      listenWhen: (previous, current) =>
          previous.addressesState.errorMessage !=
          current.addressesState.errorMessage,
      listener: (context, state) {
        if (state.addressesState.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.addressesState.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        final addressesState = state.addressesState;

        if (addressesState.isLoading && addressesState.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final addresses = addressesState.data ?? const <AddressEntity>[];

        if (addresses.isEmpty) {
          return Center(
            child: Text(
              AppStrings.savedAddressEmpty,
              style: TextStyle(color: AppColors.gray, fontSize: 14.sp),
            ),
          );
        }

        return SavedAddressAnimatedList(addresses: addresses);
      },
    );
  }
}

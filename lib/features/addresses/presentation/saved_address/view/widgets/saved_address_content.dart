import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/constants/app_strings/app_strings.dart';
import '../../../../../../core/themes/app_colors/app_color.dart';
import '../../../../domain/entities/address_entity.dart';
import '../../manger/saved_address_state.dart';
import '../../manger/saved_address_view_model.dart';
import 'saved_address_animated_list.dart';

class SavedAddressContent extends StatelessWidget {
  const SavedAddressContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SavedAddressViewModel, SavedAddressState>(
      listener: (context, state) {
        if (state is SavedAddressError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is SavedAddressInitial || (state is SavedAddressLoading && state is! SavedAddressLoaded)) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SavedAddressLoaded && state.addresses.isEmpty) {
          return Center(
            child: Text(
              AppStrings.savedAddressEmpty,
              style: TextStyle(color: AppColors.gray, fontSize: 14.sp),
            ),
          );
        }


        final addresses = state is SavedAddressLoaded ? state.addresses : <AddressEntity>[];
        return SavedAddressAnimatedList(addresses: addresses);
      },
    );
  }
}
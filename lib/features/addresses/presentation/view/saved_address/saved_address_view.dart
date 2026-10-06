import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_events.dart';
import 'package:flower_app/features/addresses/presentation/view/saved_address/widgets/saved_address_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class SavedAddressView extends StatefulWidget {
  const SavedAddressView({super.key});

  @override
  State<SavedAddressView> createState() => _SavedAddressViewState();
}

class _SavedAddressViewState extends State<SavedAddressView> {
  @override
  void initState() {
    super.initState();
    getIt<AddressCubit>().doEvent(FetchUserAddressesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddressCubit>.value(
      value: getIt<AddressCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.whiteBase,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(AppStrings.savedAddressTitle),
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Expanded(
                      child: SavedAddressContent(),
                    ),
                    SizedBox(height: 12.h),
                    CustomButton(
                      text: AppStrings.addNewAddress,
                      isEnabled: true,
                      enabledColor: AppColors.pinkBase,
                      onPressed: () => _goToAddAddress(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _goToAddAddress(BuildContext context) async {
    final result = await Navigator.of(context).pushNamed(Routes.addAddress);
    if (result != null && context.mounted) {
      context.read<AddressCubit>().doEvent(FetchUserAddressesEvent());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address added')),
      );
    }
  }
}
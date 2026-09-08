import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../config/di/di.dart';
import '../../../../../config/routing/routes.dart';
import '../../../../../core/shared/app_widgets/custom_button.dart';
import '../../../../../core/themes/app_colors/app_color.dart';
import '../manger/saved_address_event.dart';
import '../manger/saved_address_view_model.dart';
import 'widgets/saved_address_content.dart';

class SavedAddressView extends StatefulWidget {
  const SavedAddressView({super.key});

  @override
  State<SavedAddressView> createState() => _SavedAddressViewState();
}

class _SavedAddressViewState extends State<SavedAddressView> {
  late final SavedAddressViewModel _savedAddressViewModel;

  @override
  void initState() {
    super.initState();
    _savedAddressViewModel = getIt<SavedAddressViewModel>()..doEvent(LoadAddresses());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _goToAddAddress(BuildContext context) async {
    final result = await Navigator.of(context).pushNamed(Routes.addAddress);
    if (result != null && context.mounted) {
      _savedAddressViewModel.doEvent(LoadAddresses());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SavedAddressViewModel>.value(
      value: _savedAddressViewModel,
      child: Builder(
        builder: (context) => Scaffold(
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
        ),
      ),
    );
  }
}
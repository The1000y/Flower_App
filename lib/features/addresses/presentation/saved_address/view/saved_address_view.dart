import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../config/di/di.dart';
import '../../../../../config/routing/routes.dart';
import '../../../../../core/shared/app_widgets/custom_button.dart';
import '../../../../../core/themes/app_colors/app_color.dart';
import '../../../domain/entities/address_entity.dart';
import '../manger/saved_address_event.dart';
import '../manger/saved_address_state.dart';
import '../manger/saved_address_view_model.dart';
import 'widgets/saved_address_content.dart';

class SavedAddressView extends StatelessWidget {
  const SavedAddressView({super.key});

  Future<void> _goToAddAddress(BuildContext context) async {
    final result = await Navigator.of(context).pushNamed(Routes.addAddress);
    if (result != null && context.mounted) {
      context.read<SavedAddressViewModel>().onEvent(LoadAddresses());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SavedAddressViewModel>()..onEvent(LoadAddresses()),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Saved address'),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Expanded(
                    // Delegating all state listening to a specific content widget
                    child: SavedAddressContent(),
                  ),
                  SizedBox(height: 12.h),
                  CustomButton(
                    text: 'Add new address',
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
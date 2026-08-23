import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/home_event.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/home_state.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class HomeUpdateBanner extends StatelessWidget {
  const HomeUpdateBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      buildWhen: (previous, current) =>
          previous.hasSectionsUpdate != current.hasSectionsUpdate ||
          previous.isRefreshing != current.isRefreshing,
      builder: (context, state) {
        final isVisible = state.hasSectionsUpdate || state.isRefreshing;

        return AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: isVisible
              ? Container(
                  key: const ValueKey('home_update_banner'),
                  width: double.infinity,
                  color: AppColors.lightPink,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppStrings.homeUpdatedBanner,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      if (state.isRefreshing)
                        SizedBox(
                          width: 22.w,
                          height: 22.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      else
                        TextButton(
                          onPressed: () => context
                              .read<HomeViewModel>()
                              .handle(RefreshHomePressed()),
                          child: const Text(
                            AppStrings.refreshAction,
                            style: TextStyle(
                              color: AppColors.pinkBase,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}

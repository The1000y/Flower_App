import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../manager/cubit/occasion_cubit.dart';
import '../manager/cubit/occasion_event.dart';
import '../manager/cubit/occasion_state.dart';
import 'widgets/occasion_tab_bar.dart';
import 'widgets/occasion_tab_view.dart';

class OccasionView extends StatelessWidget {
  const OccasionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OccasionCubit>()..handle(LoadOccasions()),
      child: const _OccasionScaffold(),
    );
  }
}

class _OccasionScaffold extends StatelessWidget {
  const _OccasionScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80.h,
        titleSpacing: 0,
        leadingWidth: 48.w,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 24.w,
            color: AppColors.blackBase,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.occasionTitle,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 20.sp,
                color: AppColors.blackBase,
                height: 1,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              AppStrings.bloomSubtitle,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                color: AppColors.gray,
                height: 1,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<OccasionCubit, OccasionState>(
        buildWhen: (previous, current) =>
            previous.occasions != current.occasions ||
            previous.isLoadingOccasions != current.isLoadingOccasions ||
            previous.occasionsError != current.occasionsError,
        builder: (context, state) {
          if (state.isLoadingOccasions) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.occasionsError.isNotEmpty) {
            return Center(child: Text(state.occasionsError));
          }
          if (state.occasions.isEmpty) {
            return const SizedBox.shrink();
          }

          return DefaultTabController(
            length: state.occasions.length,
            child: Column(
              children: [
                SizedBox(height: 16.h),
                OccasionTabBar(occasions: state.occasions),
                const Expanded(child: OccasionTabView()),
              ],
            ),
          );
        },
      ),
    );
  }
}

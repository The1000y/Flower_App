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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      appBar: AppBar(
        backgroundColor: AppColors.whiteBase,
        elevation: 0,
        toolbarHeight: 80.h,
        automaticallyImplyLeading: false,
        titleSpacing: 16.w,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.blackBase,
                  ),
                  iconSize: 24.w,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                SizedBox(width: 8.w),
                Text(
                  AppStrings.occasionTitle,
                  style: textTheme.titleSmall,
                ),
              ],
            ),
            SizedBox(height: 4.h),

            Padding(
              padding: EdgeInsets.only(left: 32.w),
              child: Text(
                AppStrings.bloomSubtitle,
                style: textTheme.labelMedium,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<OccasionCubit, OccasionState>(
        buildWhen: (previous, current) =>
        previous.occasionsState != current.occasionsState,
        builder: (context, state) {
          final occasionsState = state.occasionsState;

          if (occasionsState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (occasionsState.errorMessage.isNotEmpty) {
            return Center(child: Text(occasionsState.errorMessage));
          }

          final occasions = occasionsState.data ?? const [];
          if (occasions.isEmpty) {
            return const Center(
              child: Text('No occasions available right now.'),
            );
          }

          return DefaultTabController(
            length: occasions.length,
            child: Column(
              children: [
                OccasionTabBar(occasions: occasions),
                const Expanded(child: OccasionTabView()),
              ],
            ),
          );
        },
      ),
    );
  }
}
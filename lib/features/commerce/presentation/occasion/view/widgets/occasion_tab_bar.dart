import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/occasion/occasion_entity.dart';
import '../../manager/cubit/occasion_cubit.dart';
import '../../manager/cubit/occasion_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OccasionTabBar extends StatelessWidget {
  final List<OccasionEntity> occasions;

  const OccasionTabBar({super.key, required this.occasions});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelColor: AppColors.pinkBase,
      unselectedLabelColor: AppColors.gray,
      indicatorColor: AppColors.pinkBase,
      indicatorWeight: 2,
      dividerColor: Colors.transparent,
      onTap: (index) {
        context.read<OccasionCubit>().handle(
          LoadProductsForOccasion(occasions[index].id),
        );
      },
      tabs: occasions.map((occasion) => Tab(text: occasion.name)).toList(),
    );
  }
}
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/cubit/occasion_cubit.dart';
import '../manager/cubit/occasion_event.dart';
import '../manager/cubit/occasion_state.dart';
import 'widgets/occasion_app_bar.dart';
import 'widgets/occasion_tab_bar.dart';
import 'widgets/occasion_tab_view.dart';

class OccasionView extends StatelessWidget {
  const OccasionView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final initialOccasionName = args is String ? args : null;

    return BlocProvider(
      create: (_) => getIt<OccasionCubit>()
        ..handle(LoadOccasions(initialOccasionName: initialOccasionName)),
      child: _OccasionScaffold(initialOccasionName: initialOccasionName),
    );
  }
}

class _OccasionScaffold extends StatelessWidget {
  final String? initialOccasionName;
  const _OccasionScaffold({this.initialOccasionName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      appBar: const OccasionAppBar(),
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

          final activeTabIndex = _resolveInitialTabIndex(occasions);

          return DefaultTabController(
            length: occasions.length,
            initialIndex: activeTabIndex,
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

  int _resolveInitialTabIndex(List<dynamic> occasions) {
    if (initialOccasionName == null) return 0;
    final cleanName = initialOccasionName!.trim().toLowerCase();
    final index = occasions.indexWhere(
          (occ) => occ.name.trim().toLowerCase() == cleanName,
    );
    return index == -1 ? 0 : index;
  }
}
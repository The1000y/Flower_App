import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/domain/entities/home/home_section_type.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/home_event.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/home_state.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/home_view_model.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_section_factory.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_update_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeViewModel>(
      create: (_) => getIt<HomeViewModel>()..handle(LoadHome()),
      child: Scaffold(
        backgroundColor: AppColors.whiteBase,
        body: SafeArea(
          child: BlocListener<HomeViewModel, HomeState>(
            listener: (context, state) {
              if (state.refreshError.isNotEmpty) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.refreshError),
                      backgroundColor: AppColors.error,
                    ),
                  );
              }
            },
            child: Column(
              children: [
                const HomeUpdateBanner(),
                Expanded(
                  child: BlocBuilder<HomeViewModel, HomeState>(
                    builder: (context, state) {
                      final sectionsState = state.sectionsState;

                      if (sectionsState.isLoading &&
                          sectionsState.data == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (sectionsState.errorMessage.isNotEmpty &&
                          sectionsState.data == null) {
                        return Center(
                          child: Text(
                            sectionsState.errorMessage,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      final sections =
                          (sectionsState.data ?? const []).activeSorted;

                      if (sections.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final section in sections)
                              HomeSectionFactory(
                                section: section,
                                state: state,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

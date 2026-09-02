import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/cubit/home_cubit.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/cubit/home_event.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/cubit/home_state.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/build_sections.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_header.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_location-data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeCubit homeCubit;
  @override
  void initState() {
    super.initState();
    homeCubit = getIt.get<HomeCubit>();
    homeCubit.doEvent(GetSectionEvent());
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      body: SafeArea(
        child: BlocProvider.value(
          value: homeCubit,
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final sectionsState = state.sectionsState;

              if (sectionsState.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (sectionsState.errorMessage.isNotEmpty) {
                return Center(
                  child: Text('Error: ${sectionsState.errorMessage}'),
                );
              }
              final sections = sectionsState.data ?? [];

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomHeaderHomeView(),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomLocationData(textTheme: textTheme),
                    ),
                    SizedBox(height: 16),
                    Column(
                      children: List.generate(sections.length, (index) {
                        final section = sections[index];
                        return BuildSections().buildSection(section, textTheme: textTheme);
                      }),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

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

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    print("Home build");
    var textTheme = Theme.of(context).textTheme;
    return BlocProvider(
      create: (context) =>
          getIt.get<HomeCubit>()..doEvent(GetSectionEvent()),
      child: Scaffold(
        backgroundColor: AppColors.whiteBase,
        body: SafeArea(
          child: SingleChildScrollView(
            child: BlocBuilder<HomeCubit, HomeState>(
              // buildWhen: (previous, current) {
              //   return previous.sectionsState != current.sectionsState;
              // },
              builder: (context, state) {
                final sectionsState = state.sectionsState;

                if (sectionsState.isLoading) {
                  return  Center(child: CircularProgressIndicator());
               
                }

                if (sectionsState.errorMessage.isNotEmpty) {
                  return  Center(child: Text(sectionsState.errorMessage));
                  
                }
                final sections = sectionsState.data ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomHeaderHomeView(),
                    ),
                    SizedBox(height: 16),
                    // LOCATION
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomLocationData(textTheme: textTheme),
                    ),
                    SizedBox(height: 16),
                    Column(
                      children: List.generate(sections.length, (index) {
                        final section = sections[index];
                        return BuildSections().buildSection(
                          section,
                          textTheme: textTheme,
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

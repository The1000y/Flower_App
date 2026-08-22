import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/cubit/home_cubit.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/cubit/home_event.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/cubit/home_state.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_best_seller_list.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_category_list.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_header.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_header_collection.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_location-data.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_occasion_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeCubit homeCubit = getIt.get<HomeCubit>();
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocProvider<HomeCubit>(
            create: (context) => homeCubit..doEvent(GetCategoriesEvent()),
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomHeaderOfCollection(
                        textTheme: textTheme,
                        collectionName: AppStrings.categoriesLabel,
                        onTapViewAll: () {},
                      ),
                    ),
                    SizedBox(height: 16),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        final categoriesState = state.categoriesState;

                        if (categoriesState.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (categoriesState.errorMessage.isNotEmpty) {
                          return Center(
                            child: Text(categoriesState.errorMessage),
                          );
                        }

                        if (categoriesState.data != null) {
                          return CustomCategoryList(
                            categories: categoriesState.data!,
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomHeaderOfCollection(
                        textTheme: textTheme,
                        collectionName: AppStrings.bestsellerLabel,
                        onTapViewAll: () {},
                      ),
                    ),
                    SizedBox(height: 16),
                    CustomBestSellerList(),
                    SizedBox(height: 24),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomHeaderOfCollection(
                        textTheme: textTheme,
                        collectionName: AppStrings.ocassionLabel,
                        onTapViewAll: () {},
                      ),
                    ),
                    SizedBox(height: 16),
                    CustomOccasionrList(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

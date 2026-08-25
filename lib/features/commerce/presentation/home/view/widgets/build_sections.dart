import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/commerce/domain/entities/home/section_entity.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/cubit/home_cubit.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/cubit/home_state.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_best_seller_list.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_category_list.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_header_collection.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_occasion_list.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

 class BuildSections {
  Widget buildSection(SectionEntity section, {required TextTheme textTheme}) {
    switch (section.type) {
      case "Categories":
        return Column(
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
                  return const Center(child: CircularProgressIndicator());
                }

                if (categoriesState.errorMessage.isNotEmpty) {
                  return Center(child: Text(categoriesState.errorMessage));
                }

                if (categoriesState.data != null) {
                  return CustomCategoryList(categories: categoriesState.data!);
                }

                return const SizedBox.shrink();
              },
            ),
            SizedBox(height: 16),
          ],
        );

      case "BestSeller":
        return Column(
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
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                final bestSellerState = state.bestSellerState;

                if (bestSellerState.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (bestSellerState.errorMessage.isNotEmpty) {
                  return Center(child: Text(bestSellerState.errorMessage));
                }

                if (bestSellerState.data != null) {
                  return CustomBestSellerList(
                    bestSellerlist: bestSellerState.data!,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            // SizedBox(height: 24),
            SizedBox(height: 16),
          ],
        );

      case "Occasions":
        return Column(
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
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                final occasionsState = state.occasionState;
                if(occasionsState.isLoading){
                  return const Center(child: CircularProgressIndicator());
                }
                if(occasionsState.errorMessage.isNotEmpty){
                  return Center(child: Text(occasionsState.errorMessage));
                }
                if(occasionsState.data != null){
                  return CustomOccasionrList(occasionList: occasionsState.data!);
                }
                return const SizedBox.shrink();
              },
            ),
            SizedBox(height: 16),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

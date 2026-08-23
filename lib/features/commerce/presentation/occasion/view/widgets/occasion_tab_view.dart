import 'package:flower_app/core/shared/app_widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../manager/cubit/occasion_cubit.dart';
import '../../manager/cubit/occasion_state.dart';

class OccasionTabView extends StatelessWidget {
  const OccasionTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OccasionCubit, OccasionState>(
      buildWhen: (previous, current) =>
      previous.products != current.products ||
          previous.isLoadingProducts != current.isLoadingProducts ||
          previous.productsError != current.productsError,
      builder: (context, state) {
        if (state.isLoadingProducts) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.productsError.isNotEmpty) {
          return Center(child: Text(state.productsError));
        }

        return GridView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: state.products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 17.h,
            mainAxisExtent: 280.h,
          ),
          itemBuilder: (context, index) {
            final product = state.products[index];
            return ProductCard(
              image: product.imageUrl,
              name: product.name,
              price: product.price,
              oldPrice: product.originalPrice,
              discount: product.discountPercentage?.toInt(),
            );
          },
        );
      },
    );
  }
}
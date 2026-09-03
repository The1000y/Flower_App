import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flower_app/features/commerce/presentation/bestseller/manager/cubit/bestseller_cubit.dart';
import 'package:flower_app/features/commerce/presentation/bestseller/manager/cubit/bestseller_event.dart';
import 'package:flower_app/features/commerce/presentation/bestseller/manager/cubit/bestseller_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class BestsellerView extends StatefulWidget {
  const BestsellerView({super.key});

  @override
  State<BestsellerView> createState() => _BestsellerViewState();
}

class _BestsellerViewState extends State<BestsellerView> {
  late BestsellerCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<BestsellerCubit>()..doEvent(GetBestsellerListEvent());
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.blackBase),
            onPressed: () => Navigator.pop(context),
          ),
          titleSpacing: 0,
          title: Text(
            AppStrings.bestsellerLabel,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
          ),
        ),
        body: BlocBuilder<BestsellerCubit, BestsellerState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorMessage),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => _cubit.getBestsellerList(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final items = state.data ?? [];
            if (items.isEmpty) {
              return const Center(child: Text('No items found'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    AppStrings.bloomSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.black30,
                        ),
                  ),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 0.62,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return BestsellerProductCard(item: items[index]);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class BestsellerProductCard extends StatelessWidget {
  final BestSellerEntity item;
  const BestsellerProductCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.productDetails,
        arguments: item.id,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                child: Container(
                  width: double.infinity,
                  color: AppColors.lightPink,
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.image, size: 40)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.blackBase,
                          fontWeight: FontWeight.w500,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        '${item.currency} ${item.price}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.blackBase,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                      ),
                      if (item.originalPrice > 0) ...[
                        SizedBox(width: 4.w),
                        Text(
                          '${item.originalPrice}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.black30,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 10.sp,
                              ),
                        ),
                      ],
                      if (item.discountPercentage > 0) ...[
                        SizedBox(width: 4.w),
                        Text(
                          '${item.discountPercentage}%',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.sp,
                              ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: double.infinity,
                    height: 36.h,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement add to cart logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pinkBase,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      icon: Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 16.sp),
                      label: Text(
                        AppStrings.addToCart,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

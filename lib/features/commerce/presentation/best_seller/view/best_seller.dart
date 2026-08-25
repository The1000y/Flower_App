import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/presentation/best_seller/manager/cubit/best_seller_cubit.dart';
import 'package:flower_app/features/commerce/presentation/best_seller/manager/cubit/best_seller_event.dart';
import 'package:flower_app/features/commerce/presentation/best_seller/manager/cubit/best_seller_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class BestSeller extends StatefulWidget {
  const BestSeller({super.key});

  @override
  State<BestSeller> createState() => _BestSellerState();
}

class _BestSellerState extends State<BestSeller> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<BestSellerCubit>().doEvent(LoadMoreBestSellerEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<BestSellerCubit>()..doEvent(GetBestSellerEvent()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios_new, color: AppColors.blackBase),
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
        body: BlocBuilder<BestSellerCubit, BestSellerState>(
          builder: (context, state) {
            if (state.isLoading && (state.data == null || state.data!.isEmpty)) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage.isNotEmpty &&
                (state.data == null || state.data!.isEmpty)) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorMessage),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<BestSellerCubit>().getBestSeller(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final products = state.data ?? [];
            if (products.isEmpty) {
              return const Center(child: Text('No best sellers found'));
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
                    controller: _scrollController,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 0.65,
                    ),
                    itemCount:
                        products.length + (state.isFetchingMore ? 2 : 0),
                    itemBuilder: (context, index) {
                      if (index < products.length) {
                        return BestSellerProductCard(product: products[index]);
                      } else {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
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

class BestSellerProductCard extends StatelessWidget {
  final ProductEntity product;
  const BestSellerProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.productDetails,
        arguments: product.id,
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
                    product.imageUrl,
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
                    product.name,
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
                        '${product.currency} ${product.price.toInt()}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.blackBase,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                      ),
                      if (product.originalPrice != null) ...[
                        SizedBox(width: 4.w),
                        Text(
                          '${product.originalPrice!.toInt()}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.black30,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 10.sp,
                              ),
                        ),
                      ],
                      if (product.discountPercentage != null) ...[
                        SizedBox(width: 4.w),
                        Text(
                          '${product.discountPercentage!.toInt()}%',
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pinkBase,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      icon: Icon(Icons.shopping_cart_outlined,
                          color: Colors.white, size: 16.sp),
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

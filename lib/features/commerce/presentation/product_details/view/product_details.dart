import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_event.dart';
import 'package:flower_app/features/commerce/presentation/product_details/manager/cubit/product_details_cubit.dart';
import 'package:flower_app/features/commerce/presentation/product_details/manager/cubit/product_details_event.dart';
import 'package:flower_app/features/commerce/presentation/product_details/manager/cubit/product_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ProductDetails extends StatefulWidget {
  final int productId;

  const ProductDetails({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ProductDetailsCubit>()
            ..doEvent(
              GetProductDetailsEvent(widget.productId),
            ),
        ),
        BlocProvider(
          create: (context) => getIt<CartCubit>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.errorMessage.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorMessage),
                    ElevatedButton(
                      onPressed: () => context
                          .read<ProductDetailsCubit>()
                          .getProductDetails(widget.productId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final product = state.data;

            if (product == null) {
              return const Center(
                child: Text('Product not found'),
              );
            }

            return SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 440.h,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: AppColors.lightPink,
                                ),
                                child: PageView.builder(
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentImageIndex = index;
                                    });
                                  },
                                  itemCount: product.images.length,
                                  itemBuilder: (context, index) {
                                    return Image.network(
                                      product.images[index],
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Center(
                                        child: Icon(
                                          Icons.image,
                                          size: 50,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Back Button
                              Positioned(
                                top: 44.h,
                                left: 16.w,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new,
                                      size: 20,
                                    ),
                                    color: AppColors.blackBase,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),

                              // Image Indicators
                              Positioned(
                                bottom: 20.h,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: List.generate(
                                    product.images.length,
                                    (index) => AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                      ),
                                      width: 8.w,
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _currentImageIndex == index
                                            ? AppColors.pinkBase
                                            : AppColors.black20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Product Information
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 20.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${product.currency} ${product.price.toInt()}',
                                      style:
                                          textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.sp,
                                        color: AppColors.blackBase,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          AppStrings.statusLabel,
                                          style: textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.blackBase,
                                          ),
                                        ),
                                        Text(
                                          product.status,
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: AppColors.blackBase,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                SizedBox(height: 4.h),

                                Text(
                                  AppStrings.taxNotice,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: AppColors.black30,
                                  ),
                                ),

                                SizedBox(height: 16.h),

                                Text(
                                  product.name,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.blackBase,
                                  ),
                                ),

                                SizedBox(height: 24.h),

                                Text(
                                  AppStrings.description,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.blackBase,
                                  ),
                                ),

                                SizedBox(height: 8.h),

                                Text(
                                  product.description,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.blackBase,
                                    height: 1.4,
                                  ),
                                ),

                                SizedBox(height: 24.h),

                                Text(
                                  AppStrings.bouquetInclude,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.blackBase,
                                  ),
                                ),

                                SizedBox(height: 8.h),

                                ...product.includes.map(
                                  (item) => _buildIncludeItem(
                                    context,
                                    '${item.name}:${item.quantity}',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Add To Cart Button
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: CustomButton(
                      text: AppStrings.addToCart,
                      onPressed: () {
                        context.read<CartCubit>().doEvent(
                              AddToCartEvent(
                                productId: product.id,
                                quantity: 1,
                              ),
                            );
                      },
                      isEnabled: true,
                      enabledColor: AppColors.pinkBase,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildIncludeItem(
    BuildContext context,
    String text,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.blackBase,
            ),
      ),
    );
  }
}
import 'package:flower_app/core/shared/app_widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../manager/cubit/occasion_cubit.dart';
import '../../manager/cubit/occasion_event.dart';
import '../../manager/cubit/occasion_state.dart';

class OccasionTabView extends StatefulWidget {
  const OccasionTabView({super.key});

  @override
  State<OccasionTabView> createState() => _OccasionTabViewState();
}

class _OccasionTabViewState extends State<OccasionTabView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final cubit = context.read<OccasionCubit>();
    final state = cubit.state;
    if (state.isLoadingMore || state.productsState.isLoading) return;
    if (state.pagination?.hasNextPage != true) return;
    final threshold = _scrollController.position.maxScrollExtent - 200.h;
    if (_scrollController.position.pixels >= threshold) {
      cubit.handle(LoadMoreProducts());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OccasionCubit, OccasionState>(
      buildWhen: (previous, current) =>
      previous.productsState != current.productsState ||
          previous.isLoadingMore != current.isLoadingMore,
      builder: (context, state) {
        final productsState = state.productsState;

        if (productsState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (productsState.errorMessage.isNotEmpty) {
          return Center(child: Text(productsState.errorMessage));
        }

        final products = productsState.data ?? const [];

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(16.w),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 17.h,
                  mainAxisExtent: 280.h,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final product = products[index];
                    return ProductCard(
                      image: product.imageUrl,
                      name: product.name,
                      price: product.price,
                      oldPrice: product.originalPrice,
                      discount: product.discountPercentage?.toInt(),
                    );
                  },
                  childCount: products.length,
                ),
              ),
            ),
            if (state.isLoadingMore)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        );
      },
    );
  }
}
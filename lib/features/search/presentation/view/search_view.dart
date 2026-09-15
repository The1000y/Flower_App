import 'dart:async';

import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flower_app/core/shared/app_widgets/product_card.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/search/presentation/manger/cubit/search_cubit.dart';
import 'package:flower_app/features/search/presentation/manger/cubit/search_event.dart';
import 'package:flower_app/features/search/presentation/manger/cubit/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final cubit = context.read<SearchCubit>();
    final state = cubit.state;
    if (state.isLoadingMore || state.resultState.isLoading) return;
    if (state.pagination?.hasNextPage != true) return;
    final threshold = _scrollController.position.maxScrollExtent - 200.h;
    if (_scrollController.position.pixels >= threshold) {
      cubit.doEvent(LoadMoreSearchEvent());
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.read<SearchCubit>().doEvent(SearchProductsEvent(value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Search',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: CustomTextFormField(
              label: '',
              hintText: 'Search for any product',
              controller: _searchController,
              prefixIcon: const Icon(Icons.search),
              onChanged: _onQueryChanged,
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                return _buildBody(context, state);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, SearchState state) {
    final resultState = state.resultState;

    if (state.query.trim().isEmpty) {
      return Center(
        child: Text(
          'Start typing to search',
          style: TextStyle(color: AppColors.black30, fontSize: 16.sp),
        ),
      );
    }

    if (resultState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (resultState.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(resultState.errorMessage, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () =>
                  context.read<SearchCubit>().doEvent(SearchProductsEvent(state.query)),
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      );
    }

    final products = resultState.data ?? [];
    if (products.isEmpty) {
      return Center(
        child: Text(
          AppStrings.noResult,
          style: TextStyle(color: AppColors.black30, fontSize: 16.sp),
        ),
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(16.w),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              mainAxisExtent: 280.h,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final ProductEntity product = products[index];
              return GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.productDetails,
                  arguments: product.id,
                ),
                child: ProductCard(
                  id: product.id,
                  image: product.imageUrl,
                  name: product.name,
                  price: product.price,
                  oldPrice: product.originalPrice,
                  discount: product.discountPercentage?.round(),
                ),
              );
            }, childCount: products.length),
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
  }
}
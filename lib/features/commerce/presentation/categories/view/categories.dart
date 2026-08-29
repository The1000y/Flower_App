import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../config/di/di.dart';
import '../../../../../config/routing/routes.dart';
import '../../../../../core/shared/app_widgets/custom_text_form_field.dart';
import '../../../../../core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import '../manager/cubit/categories_cubit.dart';
import '../manager/cubit/categories_event.dart';
import '../manager/cubit/categories_state.dart';
import 'widgets/buildSortItemfFilter.dart';
import 'widgets/filterView.dart';
import 'widgets/tabBarView_widget.dart';

class Categories_view extends StatelessWidget {
  const Categories_view({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CategoriesCubit>()
        ..doEvent(GetCategoriesEvent())
        ..doEvent(GetProductsEvent()),
      child: const _CategoriesContent(),
    );
  }
}

class _CategoriesContent extends StatefulWidget {
  const _CategoriesContent();

  @override
  State<_CategoriesContent> createState() => _CategoriesContentState();
}

class _CategoriesContentState extends State<_CategoriesContent> {
  SortType? selectedSort;

  void _reload() {
    context.read<CategoriesCubit>()
      ..doEvent(GetCategoriesEvent())
      ..doEvent(GetProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        final categoriesState = state.categoriesState;
        final productsState = state.productsState;

        if (categoriesState.isLoading || productsState.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (categoriesState.errorMessage.isNotEmpty ||
            productsState.errorMessage.isNotEmpty) {
          final message = categoriesState.errorMessage.isNotEmpty
              ? categoriesState.errorMessage
              : productsState.errorMessage;
          return Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message, textAlign: TextAlign.center),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: _reload,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final categories = categoriesState.data ?? <CategoryEntity>[];
        final products = productsState.data ?? [];
        if (categories.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('No categories found')),
          );
        }

        return DefaultTabController(
          length: categories.length,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                SizedBox(height: 50.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, Routes.search),
                          child: AbsorbPointer(
                            child: CustomTextFormField(
                              label: '',
                              hintText: 'Search',
                              prefixIcon: const Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      IconButton(
                        onPressed: () => _showFilter(context),
                        tooltip: 'Filter products',
                        icon: const Icon(Icons.filter_list),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: AppColors.pinkBase,
                  unselectedLabelColor: AppColors.gray,
                  indicatorColor: AppColors.pinkBase,
                  indicatorWeight: 2,
                  dividerColor: Colors.transparent,
                  tabs: [
                    for (final category in categories) Tab(text: category.name),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      for (final category in categories)
                        TabbarviewWidget(
                          category: category.name,
                          products: products,
                          sortType: selectedSort,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: Builder(
              builder: (context) => FloatingActionButton.extended(
                onPressed: () => _showFilter(context),
                icon: const Icon(Icons.tune),
                label: const Text('Filter'),
                backgroundColor: AppColors.pinkBase,
                foregroundColor: Colors.white,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        );
      },
    );
  }

  Future<void> _showFilter(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (_) => FilterView(
        selectedSort: selectedSort,
        onChanged: (value) => setState(() => selectedSort = value),
      ),
    );
  }
}

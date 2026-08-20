import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/presentation/categories/view/widgets/positionedBottomSheet.dart';
import 'package:flower_app/features/commerce/presentation/categories/view/widgets/tabBarView_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../core/shared/app_widgets/custom_text_form_field.dart';
import '../dummy/appCategories.dart';

class Categories_view extends StatefulWidget {
  const Categories_view({super.key});

  @override
  State<Categories_view> createState() => _Categories_viewState();
}

class _Categories_viewState extends State<Categories_view> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        backgroundColor: Colors.white,

        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 50.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: CustomTextFormField(
                            label: '',
                            hintText: 'Search',
                            prefixIcon: const Icon(Icons.search),
                          ),
                        ),
                      ),

                      SizedBox(width: 8.w),

                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          height: 60.h,
                          width: 58.w,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: const Icon(Icons.filter_list),
                        ),
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

                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Hand Bouquet'),
                    Tab(text: 'Vases'),
                    Tab(text: 'Boxes'),
                    Tab(text: 'Jewelry'),
                    Tab(text: 'Gift'),
                    Tab(text: 'Card'),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    children: const [
                      TabbarviewWidget(category: AppCategories.all),
                      TabbarviewWidget(category: AppCategories.handBouquet),
                      TabbarviewWidget(category: AppCategories.vases),
                      TabbarviewWidget(category: AppCategories.boxes),
                      TabbarviewWidget(category: AppCategories.jewelry),
                      TabbarviewWidget(category: AppCategories.gift),
                      TabbarviewWidget(category: AppCategories.card),
                    ],
                  ),
                ),
              ],
            ),
            Positionedbottomsheet(),
          ],
        ),
      ),
    );
  }
}

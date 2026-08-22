import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/product_card.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'widgets/occasion_tab_view.dart';

class OccasionView extends StatefulWidget {
  const OccasionView({super.key});

  @override
  State<OccasionView> createState() => _OccasionViewState();
}

class _OccasionViewState extends State<OccasionView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: AppOccasions.all.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(AppStrings.occasionTitle),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.bloomSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppColors.pinkBase,
              unselectedLabelColor: AppColors.gray,
              indicatorColor: AppColors.pinkBase,
              indicatorWeight: 2,
              dividerColor: Colors.transparent,
              tabs: AppOccasions.all
                  .map((occasion) => Tab(text: occasion))
                  .toList(),
            ),
            Expanded(
              child: TabBarView(
                children: AppOccasions.all
                    .map((occasion) => OccasionTabView(occasion: occasion))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
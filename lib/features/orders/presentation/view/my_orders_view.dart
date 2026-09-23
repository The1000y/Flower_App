import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/orders/presentation/manager/cubit/orders_cubit.dart';
import 'package:flower_app/features/orders/presentation/manager/orders_state.dart';
import 'package:flower_app/features/orders/presentation/view/widgets/orders_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../config/routing/routes.dart';

class MyOrdersView extends StatelessWidget {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersCubit, OrdersState>(
      listenWhen: (previous, current) => previous.sideEffect != current.sideEffect,
      listener: (context, state) {
        if (state.sideEffect == OrdersSideEffect.navigateToTrack) {
          Navigator.pushNamed(context, Routes.trackOrder, arguments: state.selectedOrderId);
          context.read<OrdersCubit>().resetSideEffect();
        }else if (state.sideEffect == OrdersSideEffect.navigateToCart) {
          Navigator.pushNamed(context, Routes.cart, arguments: state.selectedOrderId);
          context.read<OrdersCubit>().resetSideEffect();
        }
      },
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(AppStrings.myOrdersTitle),
              bottom: TabBar(
                tabs: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: const Text(AppStrings.tabActive),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: const Text(AppStrings.tabCompleted),
                  ),
                ],
              ),
            ),
            body: state.baseState == OrdersBaseState.loading && state.activeOrders.isEmpty && state.completedOrders.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : state.baseState == OrdersBaseState.error
                    ? Center(child: Text(state.errorMessage))
                    : TabBarView(
                        children: [
                          OrdersListWidget(
                            orders: state.activeOrders,
                            onActionPressed: (id) =>
                                context.read<OrdersCubit>().trackOrderTapped(id),
                            onLoadMore: () =>
                                context.read<OrdersCubit>().fetchOrders(isLoadMore: true),
                          ),
                          OrdersListWidget(
                            orders: state.completedOrders,
                            onActionPressed: (id) =>
                                context.read<OrdersCubit>().reorderTapped(id),
                            onLoadMore: () =>
                                context.read<OrdersCubit>().fetchOrders(isLoadMore: true),
                          ),
                        ],
                      ),
          ),
        );
      },
    );
  }
}

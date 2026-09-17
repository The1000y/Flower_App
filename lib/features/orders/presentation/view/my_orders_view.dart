import 'package:flower_app/config/di/di.dart';

import 'package:flower_app/features/orders/presentation/manager/cubit/orders_cubit.dart';
import 'package:flower_app/features/orders/presentation/manager/orders_state.dart';
import 'package:flower_app/features/orders/presentation/view/widgets/order_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class MyOrdersView extends StatelessWidget {
  const MyOrdersView({super.key});

  // static List<OrderEntity> activeOrders = [
  //   OrderEntity(
  //     orderName: "Red roses",
  //     orderPrice: "EGP 600",
  //     orderId: "123456",
  //     orderDeliverDate: "",
  //     isActive: true,
  //     imageUrl: "https://example.com/rose.png",
  //     // حط أي لينك صورة وهمي
  //   ),
  //   OrderEntity(
  //     orderName: "Red roses",
  //     orderPrice: "EGP 600",
  //     orderId: "123456",
  //     orderDeliverDate: "",
  //     isActive: true,
  //     imageUrl: "https://example.com/rose.png",
  //     // حط أي لينك صورة وهمي
  //   ),
  //   OrderEntity(
  //     orderName: "Red roses",
  //     orderPrice: "EGP 600",
  //     orderId: "123456",
  //     orderDeliverDate: "",
  //     isActive: true,
  //     imageUrl: "https://example.com/rose.png",
  //     // حط أي لينك صورة وهمي
  //   ),
  //   OrderEntity(
  //     orderName: "Red roses",
  //     orderPrice: "EGP 600",
  //     orderId: "123456",
  //     orderDeliverDate: "",
  //     isActive: true,
  //     imageUrl: "https://example.com/rose.png",
  //     // حط أي لينك صورة وهمي
  //   ),
  //   OrderEntity(
  //     orderName: "Red roses",
  //     orderPrice: "EGP 600",
  //     orderId: "123456",
  //     orderDeliverDate: "",
  //     isActive: true,
  //     imageUrl: "https://example.com/rose.png",
  //     // حط أي لينك صورة وهمي
  //   ),
  //   // ممكن تكرر الـ OrderEntity ده كمان مرتين عشان اللستة تكبر
  // ]; //todo dummy data
  // static List<OrderEntity> completedOrders = [
  //   OrderEntity(
  //     orderName: "Red roses",
  //     orderPrice: "EGP 600",
  //     orderId: "123456",
  //     orderDeliverDate: "20-25-1",
  //     isActive: false,
  //     imageUrl: "https://example.com/rose.png", // حط أي لينك صورة وهمي
  //   ),
  //   OrderEntity(
  //     orderName: "Red roses",
  //     orderPrice: "EGP 600",
  //     orderId: "123456",
  //     orderDeliverDate: "20-25-1",
  //     isActive: false,
  //     imageUrl: "https://example.com/rose.png", // حط أي لينك صورة وهمي
  //   ),
  //   OrderEntity(
  //     orderName: "Red roses",
  //     orderPrice: "EGP 600",
  //     orderId: "123456",
  //     orderDeliverDate: "20-25-1",
  //     isActive: false,
  //     imageUrl: "https://example.com/rose.png", // حط أي لينك صورة وهمي
  //   ),
  //   OrderEntity(
  //     orderName: "Red roses",
  //     orderPrice: "EGP 600",
  //     orderId: "123456",
  //     orderDeliverDate: "20-25-1",
  //     isActive: false,
  //     imageUrl: "https://example.com/rose.png", // حط أي لينك صورة وهمي
  //   ),
  //   OrderEntity(
  //     orderName: "Red roses",
  //     orderPrice: "EGP 600",
  //     orderId: "123456",
  //     orderDeliverDate: "20-25-1",
  //     isActive: false,
  //     imageUrl: "https://example.com/rose.png", // حط أي لينك صورة وهمي
  //   ),
  //   // ممكن تكرر الـ OrderEntity ده كمان مرتين عشان اللستة تكبر
  // ]; //todo dummy data

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrdersCubit>()..fetchOrders(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("My orders"),
            bottom: TabBar(
              tabs: [
                Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Text("Active"),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Text("Completed"),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                  if (state is OrdersLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is OrdersSuccess) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        final currentOrder = state.activeOrders[index];
                        return OrderCardWidget(
                          orderName: currentOrder.orderName,
                          orderPrice: currentOrder.orderPrice,
                          orderId: currentOrder.orderId,
                          orderDeliverDate: currentOrder.orderDeliverDate,
                          isActive: currentOrder.isActive,
                          imageUrl: currentOrder.imageUrl,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 20.h);
                      },
                      itemCount: state.activeOrders.length,
                      padding: EdgeInsets.all(16.r),
                    );
                  } else if (state is OrdersError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
              BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                  if (state is OrdersLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is OrdersSuccess) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        final currentOrder = state.completedOrders[index];
                        return OrderCardWidget(
                          orderName: currentOrder.orderName,
                          orderPrice: currentOrder.orderPrice,
                          orderId: currentOrder.orderId,
                          orderDeliverDate: currentOrder.orderDeliverDate,
                          isActive: currentOrder.isActive,
                          imageUrl: currentOrder.imageUrl,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 20.h);
                      },
                      itemCount: state.completedOrders.length,
                      padding: EdgeInsets.all(16.r),
                    );
                  } else if (state is OrdersError) {
                    return Text(state.message);
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

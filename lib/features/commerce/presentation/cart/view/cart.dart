import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/features/commerce/domain/use_case/add_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_cart_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/remove_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/update_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_event.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'widgets/cart_items_list.dart';

class Card_view extends StatefulWidget {
  const Card_view({super.key});

  @override
  State<Card_view> createState() => CardViewState();
}

class CardViewState extends State<Card_view> {
  late final CartCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = CartCubit(
      getCartUseCase: getIt<GetCartUseCase>(),
      addCartItemUseCase: getIt<AddCartItemUseCase>(),
      updateCartItemUseCase: getIt<UpdateCartItemUseCase>(),
      removeCartItemUseCase: getIt<RemoveCartItemUseCase>(),
    );

    _cubit.doEvent(GetCartItemsEvent());
  }

  // يتم استدعاؤها كل مرة ندخل فيها على Cart
  void refreshCart() {
    _cubit.doEvent(GetCartItemsEvent());
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
          title: const Text('Cart'),
          backgroundColor: Colors.white,
        ),
        body: BlocBuilder<CartCubit, CartState>(
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
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: refreshCart,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final subtotal = state.cartItems.fold<double>(
              0,
              (previousValue, item) =>
                  previousValue + item.lineSubtotal,
            );

            final deliveryFee = state.totalPrice > subtotal
                ? state.totalPrice - subtotal
                : 0.0;

            return Column(
              children: [
                Expanded(
                  child: CartItemsList(
                    items: state.cartItems,
                    onDelete: (cartItemId) {
                      _cubit.doEvent(
                        RemoveCartItemEvent(
                          cartItemId: cartItemId,
                        ),
                      );
                    },
                    onQuantityChanged: (cartItemId, newQuantity) {
                      _cubit.doEvent(
                        UpdateCartItemEvent(
                          cartItemId: cartItemId,
                          quantity: newQuantity,
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 20.h),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sub total:',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${subtotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'delivery Fee:',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${deliveryFee.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10.h),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '\$${state.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: const Text('Checkout'),
                ),

                SizedBox(height: 20.h),
              ],
            );
          },
        ),
      ),
    );
  }
}
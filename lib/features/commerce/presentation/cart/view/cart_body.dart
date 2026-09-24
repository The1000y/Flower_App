
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_event.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_state.dart';
import 'package:flower_app/features/commerce/presentation/cart/view/widgets/cart_items_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';


class CartBody extends StatelessWidget {
  final VoidCallback onRetry;

  const CartBody({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (previous, current) {
        return previous.isLoading != current.isLoading ||
            previous.errorMessage != current.errorMessage ||
            previous.data != current.data;
      },
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
                  onPressed: onRetry,
                  child: const Text(AppStrings.retry),
                ),
              ],
            ),
          );
        }

        final cart = state.data;

        final subtotal =
            cart?.items.fold<double>(
              0,
              (previousValue, item) =>
                  previousValue + item.lineSubtotal,
            ) ??
            0.0;

        final totalPrice = cart?.total ?? 0.0;

        final deliveryFee =
            totalPrice > subtotal ? totalPrice - subtotal : 0.0;

        return Column(
          children: [
            Expanded(
              child: CartItemsList(
                items: cart?.items ?? [],
                onDelete: (cartItemId) {
                  context.read<CartCubit>().doEvent(
                        RemoveCartItemEvent(
                          cartItemId: cartItemId,
                        ),
                      );
                },
                onQuantityChanged: (cartItemId, newQuantity) {
                  context.read<CartCubit>().doEvent(
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
                      const Text(
                        AppStrings.subtotal,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${AppStrings.currencyEGP}${subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        AppStrings.deliveryFee,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${AppStrings.currencyEGP}${deliveryFee.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
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
                      const Text(
                        AppStrings.total,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${AppStrings.currencyEGP}${totalPrice.toStringAsFixed(2)}',
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
              child: const Text(AppStrings.checkout),
            ),

            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}


import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_events.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_state.dart';
import 'package:flower_app/features/addresses/presentation/view/add_address/address_view.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_event.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_state.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_location-data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'widgets/cart_items_list.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressCubit>().doEvent(FetchUserAddressesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(AppStrings.navCart),
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CartCubit>().doEvent(GetCartItemsEvent());
                    },
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
                (previousValue, item) => previousValue + item.lineSubtotal,
              ) ??
              0.0;

          final totalPrice = cart?.total ?? 0.0;

          final deliveryFee = totalPrice > subtotal
              ? totalPrice - subtotal
              : 0.0;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<AddressCubit, AddressState>(
                  builder: (context, addressState) {
                    if (addressState.selectedAddress == null &&
                        addressState.locationState.data != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.read<AddressCubit>().doEvent(
                          SetClosestAddressEvent(
                            currentLocation: addressState.locationState.data!,
                          ),
                        );
                      });
                    }

                    return CustomLocationData(
                      textTheme: Theme.of(context).textTheme,
                      selectedAddress: addressState.selectedAddress,
                      addresses: addressState.userAddresses,
                      onAddNewAddressTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: getIt.get<AddressCubit>(),
                              child: const AddressView(),
                            ),
                          ),
                        );
                      },
                      onAddressChanged: (newAddress) {
                        context.read<AddressCubit>().doEvent(
                          SelectAddressEvent(selectedAddress: newAddress),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: CartItemsList(
                  items: cart?.items ?? [],
                  loadingProductIds: state.loadingProductIds,
                  onDelete: (cartItemId) {
                    context.read<CartCubit>().doEvent(
                      RemoveCartItemEvent(cartItemId: cartItemId),
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.subtotal,
                          style: const TextStyle(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.deliveryFee,
                          style: const TextStyle(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.total,
                          style: const TextStyle(
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
      ),
    );
  }
}

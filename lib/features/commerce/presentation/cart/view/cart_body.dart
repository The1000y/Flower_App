import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_events.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_state.dart';
import 'package:flower_app/features/addresses/presentation/view/address_view.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_entity.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_event.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_state.dart';
import 'package:flower_app/features/commerce/presentation/cart/view/widgets/cart_items_list.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_location_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Renders the cart screen from [CartState].
///
/// The widget only decides *what* to show (spinner / error / cart); every rule
/// about how the cart changes lives in [CartCubit].
class CartBody extends StatelessWidget {
  final VoidCallback onRetry;

  const CartBody({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      // Only the cart-wide slices matter here. Per-item loading and optimistic
      // quantities are handled inside each [CartItem], so this builder does not
      // rebuild the whole screen for a single line.
      buildWhen: (previous, current) =>
          previous.data != current.data ||
          previous.fetch != current.fetch ||
          previous.clear != current.clear,
      builder: (context, state) {
        if (state.isFetching) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage.isNotEmpty) {
          return _ErrorView(message: state.errorMessage, onRetry: onRetry);
        }

        return _CartContent(cart: state.cart);
      },
    );
  }
}

class _CartContent extends StatelessWidget {
  final CartEntity cart;

  const _CartContent({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _AddressSection(),
        Expanded(
          child: CartItemsList(
            items: cart.items,
            onDelete: (cartItemId) => context.read<CartCubit>().doEvent(
              RemoveCartItemEvent(cartItemId: cartItemId),
            ),
            onQuantityChanged: (cartItemId, productId, newQuantity) =>
                context.read<CartCubit>().doEvent(
                  UpdateCartItemEvent(
                    cartItemId: cartItemId,
                    productId: productId,
                    quantity: newQuantity,
                  ),
                ),
          ),
        ),
        SizedBox(height: 20.h),
        _OrderSummary(cart: cart),
        _CheckoutButton(totalPrice: cart.total),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text(AppStrings.retry),
          ),
        ],
      ),
    );
  }
}

class _AddressSection extends StatelessWidget {
  const _AddressSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                SelectAddressEvent(
                  selectedAddress: newAddress,
                  addressId: newAddress.id,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final CartEntity cart;

  const _OrderSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    final subtotal = cart.items.fold<double>(
      0,
      (runningTotal, item) => runningTotal + item.lineSubtotal,
    );
    final total = cart.total;
    final deliveryFee = total > subtotal ? total - subtotal : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _SummaryRow(
            label: AppStrings.subtotal,
            value: '${AppStrings.currencyEGP}${subtotal.toStringAsFixed(2)}',
          ),
          _SummaryRow(
            label: AppStrings.deliveryFee,
            value: '${AppStrings.currencyEGP}${deliveryFee.toStringAsFixed(2)}',
          ),
          SizedBox(height: 10.h),
          _SummaryRow(
            label: AppStrings.total,
            value: '${AppStrings.currencyEGP}${total.toStringAsFixed(2)}',
            emphasized: true,
          ),
        ],
      ),
    );
  }
}

/// A label/value row in the order summary.
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasized;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: emphasized ? 18 : 16,
      fontWeight: FontWeight.bold,
      color: emphasized ? Colors.black : null,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}

class _CheckoutButton extends StatelessWidget {
  final double totalPrice;

  const _CheckoutButton({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
   
   return Padding(
     padding: const EdgeInsets.all(16.0),
     child: CustomButton(text: AppStrings.checkout, onPressed: () => Navigator.pushNamed(
          context,
          Routes.checkout,
          arguments: totalPrice.toStringAsFixed(2),
        ), isEnabled: true, enabledColor: AppColors.pinkBase,),
   );
  }
}

import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_events.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_event.dart';
import 'package:flower_app/features/commerce/presentation/cart/view/cart_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
    getIt.get<AddressCubit>().doEvent(FetchUserAddressesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddressCubit>.value(value: getIt.get<AddressCubit>()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(AppStrings.navCart),
          backgroundColor: Colors.white,
        ),
        body: CartBody(
          onRetry: () {
            context.read<CartCubit>().doEvent(GetCartItemsEvent());
          },
        ),
      ),
    );
  }
}

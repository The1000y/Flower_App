
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_event.dart';
import 'package:flower_app/features/commerce/presentation/cart/view/cart_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';


class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(AppStrings.navCart),
        backgroundColor: Colors.white,
      ),
      body: CartBody(
        onRetry: () {
          context.read<CartCubit>().doEvent(
                GetCartItemsEvent(),
              );
        },
      ),
    );
  }
}


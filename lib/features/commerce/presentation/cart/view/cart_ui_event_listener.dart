import 'dart:async';

import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_snack_bar.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_ui_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Turns the Cart feature's one-shot [CartUiEvent]s into user feedback.
///
/// It is mounted exactly once, above the [Navigator] (via
/// `MaterialApp.builder`), so an add-to-cart action triggered from any screen
/// produces a single snackbar and the confirmation is not tied to the screen
/// that started it. Because it listens to the events stream instead of the
/// state, a rebuild never replays a message and the cubit stays free of any UI
/// concern.
class CartUiEventListener extends StatefulWidget {
  const CartUiEventListener({super.key, required this.child});

  final Widget child;

  @override
  State<CartUiEventListener> createState() => _CartUiEventListenerState();
}

class _CartUiEventListenerState extends State<CartUiEventListener> {
  late final StreamSubscription<CartUiEvent> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = context.read<CartCubit>().uiEvents.listen(_onUiEvent);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _onUiEvent(CartUiEvent event) {
    if (!mounted) return;

    switch (event) {
      case AddToCartSuccessUiEvent():
        CustomSnackBar.showSuccess(
          context,
          message: AppStrings.productAddedToCart,
        );
      case AddToCartFailureUiEvent(:final message):
        CustomSnackBar.showError(
          context,
          message: message.isEmpty ? AppStrings.somethingWentWrong : message,
        );
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

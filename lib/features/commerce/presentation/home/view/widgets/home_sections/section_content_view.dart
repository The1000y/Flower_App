import 'package:flower_app/config/base/base_state.dart';
import 'package:flutter/material.dart';

class SectionContentView<T> extends StatelessWidget {
  final BaseState<List<T>> sectionState;
  final double loadingHeight;
  final Widget Function(BuildContext context, List<T> items) builder;

  const SectionContentView({
    super.key,
    required this.sectionState,
    required this.builder,
    this.loadingHeight = 120,
  });

  @override
  Widget build(BuildContext context) {
    if (sectionState.isLoading) {
      return SizedBox(
        height: loadingHeight,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (sectionState.errorMessage.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          sectionState.errorMessage,
          textAlign: TextAlign.center,
        ),
      );
    }

    final items = sectionState.data;

    if (items == null || items.isEmpty) {
      return const SizedBox.shrink();
    }

    return builder(context, items);
  }
}

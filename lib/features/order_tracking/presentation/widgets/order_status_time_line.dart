import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/app_colors/app_color.dart';
import '../../domain/entities/order_step_entity.dart';

class OrderStatusTimeline extends StatelessWidget {
  const OrderStatusTimeline({
    super.key,
    required this.steps,
    required this.currentIndex,
    this.stepHeight = 80, // every row, so every line, is the same height
    this.dotSize = 24,
    this.lineWidth = 2,
    this.duration = const Duration(milliseconds: 700),
    this.activeColor,
    this.inactiveColor,
  });

  final List<OrderStepEntity> steps;
  final int currentIndex;
  final double stepHeight;
  final double dotSize;
  final double lineWidth;
  final Duration duration;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? AppColors.pinkBase;
    final inactive = inactiveColor ?? AppColors.white70;

    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          _TimelineStep(
            step: steps[i],
            reached: i <= currentIndex,
            isLast: i == steps.length - 1,
            height: stepHeight,
            dotSize: dotSize,
            lineWidth: lineWidth,
            duration: duration,
            active: active,
            inactive: inactive,
          ),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.step,
    required this.reached,
    required this.isLast,
    required this.height,
    required this.dotSize,
    required this.lineWidth,
    required this.duration,
    required this.active,
    required this.inactive,
  });

  final OrderStepEntity step;
  final bool reached;
  final bool isLast;
  final double height;
  final double dotSize;
  final double lineWidth;
  final Duration duration;
  final Color active;
  final Color inactive;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: height, // fixed => all lines identical
      // One value 0..1 drives the whole step: first the dot fills,
      // then the line below it grows. Reversing plays it backwards.
      // No `begin` => the first build shows the final state without animating.
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: reached ? 1 : 0),
        duration: duration,
        builder: (context, t, _) {
          final dotT = const Interval(
            0.0,
            0.4,
            curve: Curves.easeOut,
          ).transform(t);
          final lineT = const Interval(
            0.4,
            1.0,
            curve: Curves.easeInOut,
          ).transform(t);

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: dotSize,
                child: Column(
                  children: [
                    _Dot(
                      progress: dotT,
                      size: dotSize,
                      active: active,
                      inactive: inactive,
                    ),
                    if (!isLast)
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            width: lineWidth,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ColoredBox(color: inactive),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: FractionallySizedBox(
                                    widthFactor: 1,
                                    heightFactor: lineT,
                                    child: ColoredBox(color: active),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(4),
                    // Date fades in when the step is reached
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      layoutBuilder: (current, previous) => Stack(
                        alignment: Alignment.centerLeft,
                        children: [...previous, if (current != null) current],
                      ),
                      child: step.dateTime == null
                          ? const SizedBox.shrink(key: ValueKey('no-date'))
                          : Text(
                              DateFormat(
                                'dd MMM yyyy - h:mm',
                              ).format(step.dateTime!),
                              key: const ValueKey('has-date'),
                              // not the date itself, so rebuilds don't re-animate
                              style: textTheme.bodyMedium,
                              maxLines: 1,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    required this.progress,
    required this.size,
    required this.active,
    required this.inactive,
  });

  final double progress; // 0..1
  final double size;
  final Color active;
  final Color inactive;

  @override
  Widget build(BuildContext context) {
    final color = Color.lerp(inactive, active, progress)!;
    // slight overshoot for a "pop"
    final innerScale = Curves.easeOutBack.transform(progress);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Transform.scale(
          scale: innerScale,
          child: Container(
            width: size / 2,
            height: size / 2,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

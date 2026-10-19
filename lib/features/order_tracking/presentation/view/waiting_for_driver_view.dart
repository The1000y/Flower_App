import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_strings/app_strings.dart';
import '../../../../core/themes/app_colors/app_color.dart';

class WaitingForDriverView extends StatefulWidget {
  const WaitingForDriverView({super.key});

  @override
  State<WaitingForDriverView> createState() => _WaitingForDriverViewState();
}

class _WaitingForDriverViewState extends State<WaitingForDriverView>
    with SingleTickerProviderStateMixin {
  static const double _radarSize = 120;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: _radarSize,
              height: _radarSize,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Three ripples, evenly spread over the loop.
                  for (final delay in const [0.0, 1 / 3, 2 / 3])
                    _Ripple(
                      animation: _controller,
                      delay: delay,
                      size: _radarSize,
                    ),
                  const CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.lightPink,
                    child: Icon(
                      Icons.two_wheeler,
                      color: AppColors.pinkBase,
                      size: 52,
                    ),
                  ),
                ],
              ),
            ),

            const Gap(56),

            Text(
              AppStrings.waitingForDriverTitle,
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            Text(
              AppStrings.waitingForDriverSubtitle,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.gray),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Ripple extends StatelessWidget {
  const _Ripple({
    required this.animation,
    required this.delay,
    required this.size,
  });

  final Animation<double> animation;
  final double delay;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final t = (animation.value + delay) % 1.0;
        return Opacity(
          opacity: (1 - t) * 0.35,
          child: Transform.scale(
            scale: 1 + t,
            child: Container(
              width: size,
              height: size,
              decoration: const BoxDecoration(
                color: AppColors.pinkBase,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}

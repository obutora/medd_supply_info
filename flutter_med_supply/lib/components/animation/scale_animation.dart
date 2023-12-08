import 'package:flutter/widgets.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';

class ScaleAnimation extends StatelessWidget {
  const ScaleAnimation({
    super.key,
    required this.child,
    required this.duration,
    required this.delay,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return CustomAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      delay: delay,
      control: Control.play,
      curve: Curves.easeOutCirc,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }
}

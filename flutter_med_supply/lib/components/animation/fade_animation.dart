import 'package:flutter/widgets.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';

class FadeAnimation extends StatelessWidget {
  const FadeAnimation({
    super.key,
    required this.child,
    required this.duration,
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return CustomAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      control: Control.play,
      curve: Curves.easeOutCirc,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(600 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

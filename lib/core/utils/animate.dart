import 'package:flutter/widgets.dart';

Future<void> animateDoubleNotifier({
  required ValueNotifier<double> notifier,
  required AnimationController controller,
  required double value,
  Curve curve = Curves.easeInCubic,
}) async {
  final Animation<double> tween = Tween<double>(
    begin: notifier.value,
    end: value,
  ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInCubic));
  tween.addListener(() => notifier.value = tween.value);

  // Reset the animation controller to its initial state
  controller.reset();

  // Start the animation by moving it forward
  await controller.forward();
}

Future<void> animateAlignmentNotifier({
  required ValueNotifier<Alignment> notifier,
  required AnimationController controller,
  required Alignment value,
  Curve curve = Curves.easeInCubic,
}) async {
  final Animation<Alignment> tween = AlignmentTween(
    begin: notifier.value,
    end: value,
  ).animate(CurvedAnimation(parent: controller, curve: curve));
  tween.addListener(() => notifier.value = tween.value);

  // Reset the animation controller to its initial state
  controller.reset();

  // Start the animation by moving it forward
  await controller.forward();
}

Future<void> animateOffsetNotifier({
  required ValueNotifier<Offset> notifier,
  required AnimationController controller,
  required Offset value,
  Curve curve = Curves.easeInCubic,
}) async {
  final Animation<Offset> tween = Tween<Offset>(
    begin: notifier.value,
    end: value,
  ).animate(CurvedAnimation(parent: controller, curve: curve));

  tween.addListener(() => notifier.value = tween.value);

  // Reset the animation controller to its initial state
  controller.reset();

  // Start the animation by moving it forward
  await controller.forward();
}

Future<void> animateNotifier<T>({
  required ValueNotifier<T> notifier,
  required AnimationController controller,
  required T value,
  Curve curve = Curves.easeInCubic,
}) async {
  final Animation<T> tween = Tween<T>(
    begin: notifier.value,
    end: value,
  ).animate(CurvedAnimation(parent: controller, curve: curve));

  tween.addListener(() => notifier.value = tween.value);

  // Reset the animation controller to its initial state
  controller.reset();

  // Start the animation by moving it forward
  await controller.forward();
}

Future<void> animate<T>({
  required AnimationController controller,
  required T begin,
  required T end,
  required ValueChanged<T> onAnimate,
  Curve curve = Curves.easeInCubic,
}) async {
  final Animation<T> tween = Tween<T>(
    begin: begin,
    end: end,
  ).animate(CurvedAnimation(parent: controller, curve: curve));

  tween.addListener(() => onAnimate(tween.value));

  // Reset the animation controller to its initial state
  controller.reset();

  // Start the animation by moving it forward
  await controller.forward();
}

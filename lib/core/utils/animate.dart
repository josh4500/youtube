import 'dart:async';

import 'package:flutter/widgets.dart';

typedef AnimationNotifierTransformer<T> = double Function(T);

class AnimationNotifier<T> extends ChangeNotifier
    with AnimationEagerListenerMixin {
  AnimationNotifier({
    required T value,
    required Duration duration,
    this.curve = Curves.easeIn,
    required TickerProvider vsync,
  })  : _currentValue = value,
        _duration = duration,
        _vsync = vsync,
        _animationController = AnimationController(
          vsync: vsync,
          duration: duration,
        ),
        _tween = Tween<T>(begin: value, end: value) {
    _animationController.addListener(_handleAnimationChange);
  }

  final Duration _duration;
  final Curve curve;
  final TickerProvider _vsync;
  final AnimationController _animationController;
  late Tween<T> _tween;
  T _currentValue;

  T get value => _currentValue;

  set value(T newValue) {
    if (newValue != _currentValue) {
      _currentValue = newValue;
      _tween.begin = newValue;
      notifyListeners();
    }
  }

  bool get isAnimating => _animationController.isAnimating;

  Future<void> start({
    T? begin,
    required T end,
    Duration? duration,
    Tween<T> Function(T? begin, T? end)? createTween,
    bool Function(T value)? updateWhen,
  }) async {
    final tween = createTween?.call(begin ?? _currentValue, end) ??
        Tween<T>(begin: begin ?? _currentValue, end: end);
    _tween = tween;
    _animationController.duration = duration ?? _duration;
    _animationController.value = 0.0;

    final animation = _tween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: curve,
      ),
    );

    animation.addListener(() {
      _currentValue = animation.value;
      if (updateWhen?.call(_currentValue) ?? true) notifyListeners();
    });

    await _animationController.forward();
  }

  void stop({bool canceled = true}) {
    _animationController.stop(canceled: canceled);
  }

  void _handleAnimationChange() {
    _currentValue = _tween.transform(
      _animationController.value,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Animation<double> toAnimation({
    AnimationNotifierTransformer<T>? transformer,
  }) {
    return _NotifierAnimation<T>(this, transformer);
  }
}

class _NotifierAnimation<T> extends Animation<double> with ChangeNotifier {
  _NotifierAnimation(this._notifier, this._transformer) {
    _notifier.addListener(_valueChanged);
  }

  final AnimationNotifier<T> _notifier;
  final AnimationNotifierTransformer<T>? _transformer;

  @override
  double get value => _transformer != null
      ? _transformer(_notifier.value)
      : _notifier.value as double;

  void _valueChanged() {
    notifyListeners();
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners) {
      _notifier.removeListener(_valueChanged);
    }
  }

  @override
  AnimationStatus get status => _notifier.isAnimating
      ? AnimationStatus.forward
      : AnimationStatus.completed;

  @override
  void addStatusListener(AnimationStatusListener listener) {}

  @override
  void removeStatusListener(AnimationStatusListener listener) {}
}

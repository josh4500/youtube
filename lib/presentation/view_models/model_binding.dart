import 'package:flutter/widgets.dart';

class _ModelBindingScope<T> extends InheritedWidget {
  const _ModelBindingScope({
    super.key,
    required this.bindingState,
    required super.child,
  });

  final _ModelBindingState<T> bindingState;

  @override
  bool updateShouldNotify(_ModelBindingScope oldWidget) => true;
}

class ModelBinding<T> extends StatefulWidget {
  const ModelBinding({
    super.key,
    required this.model,
    required this.child,
    this.onUpdate,
    this.commands = const <Type, ModelBindingAction>{},
  });

  final T model;
  final Widget child;
  final ValueChanged<T>? onUpdate;
  final Map<Type, ModelBindingAction> commands;

  static T of<T>(BuildContext context) {
    final scope =
        context.findAncestorWidgetOfExactType<_ModelBindingScope<T>>();
    if (scope == null) {
      throw Exception('');
    }
    return scope.bindingState.currentModel;
  }

  static void update<T>(BuildContext context, T value) {
    final scope =
        context.findAncestorWidgetOfExactType<_ModelBindingScope<T>>();
    if (scope == null) {
      throw Exception('');
    }
    scope.bindingState.updateModelValue(value);
  }

  @override
  State<ModelBinding<T>> createState() => _ModelBindingState<T>();
}

abstract class ModelBindingAction {}

class _ModelBindingState<T> extends State<ModelBinding<T>> {
  late T currentModel;

  @override
  void initState() {
    super.initState();
    currentModel = widget.model;
  }

  @override
  void didUpdateWidget(covariant ModelBinding<T> oldWidget) {
    currentModel = widget.model;
    super.didUpdateWidget(oldWidget);
  }

  void updateModelValue(T value) {
    if (value != currentModel) {
      currentModel = value;
      widget.onUpdate?.call(value);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ModelBindingScope<T>(bindingState: this, child: widget.child);
  }
}

extension ModelBindingExtension on BuildContext {
  T provide<T>() {
    return ModelBinding.of<T>(this);
  }
}

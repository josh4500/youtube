import 'package:flutter/widgets.dart';

class ModelBinding<T> extends StatefulWidget {
  const ModelBinding({
    super.key,
    required this.model,
    required this.child,
  });

  final T model;
  final Widget child;

  static T of<T>(BuildContext context) {
    final scope = context.findAncestorStateOfType<_ModelBindingState<T>>();
    if (scope == null) {
      throw Exception('');
    }
    return scope.currentModel;
  }

  static void update<T>(BuildContext context, T value) {
    final scope = context.findAncestorStateOfType<_ModelBindingState<T>>();
    if (scope == null) {
      throw Exception('');
    }
    scope.updateModelValue(value);
  }

  @override
  State<ModelBinding<T>> createState() => _ModelBindingState<T>();
}

class _ModelBindingState<T> extends State<ModelBinding<T>> {
  late T currentModel;

  @override
  void initState() {
    super.initState();
    currentModel = widget.model;
  }

  void updateModelValue(T value) {
    if (value != currentModel) {
      currentModel = value;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

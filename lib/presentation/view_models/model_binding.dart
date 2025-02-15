import 'package:flutter/widgets.dart';

typedef StateUpdater<T> = T Function(T current);

/// `_ModelBindingScope` is an `InheritedWidget` used to expose the
/// `_ModelBindingState` to the widget tree. This allows widgets in the
/// subtree to access the current model and listen for updates.
class _ModelBindingScope<T> extends InheritedWidget {
  const _ModelBindingScope({
    super.key,
    required this.model,
    required super.child,
  });

  /// Holds a reference to the `_ModelBindingState`, where the model data
  /// and its update methods are managed.
  final T model;

  /// Determines whether widgets that depend on `_ModelBindingScope` should
  /// rebuild when `bindingState` changes. It compares the `currentModel` of
  /// the old and new state instances.
  @override
  bool updateShouldNotify(_ModelBindingScope oldWidget) {
    return oldWidget.model != model;
  }
}

/// `ModelBindingAction` defines an action with a `perform` function that can
/// be executed on demand. It is used to create commands associated with
/// specific types.
abstract class ModelBindingAction {
  ModelBindingAction({required this.perform});

  /// A callback function that executes the action associated with this command.
  final void Function() perform;
}

/// `ModelBinding` is a `StatefulWidget` that provides a way to manage a model
/// and expose it to its descendant widgets. It supports model updates and
/// command execution based on action types.
class ModelBinding<T> extends StatefulWidget {
  const ModelBinding({
    super.key,
    required this.model,
    required this.child,
    this.onUpdate,
    this.commands = const <Type, ModelBindingAction>{},
  });

  /// The initial model data.
  final T model;

  /// The widget subtree that can access the model data.
  final Widget child;

  /// An optional callback triggered whenever the model is updated.
  final ValueChanged<T>? onUpdate;

  /// A map of commands associated with specific action types.
  final Map<Type, ModelBindingAction> commands;

  /// Retrieves the current model value of type `T` from the nearest
  /// `_ModelBindingScope` ancestor widget.
  static T of<T>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ModelBindingScope<T>>()!
        .model;
  }

  /// Similar to `of`, but returns `null` if `_ModelBindingScope` is not found
  /// in the ancestor hierarchy, allowing for nullable access.
  static T? maybeOf<T>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ModelBindingScope<T>>()
        ?.model;
  }

  /// Updates the model value by finding the nearest `_ModelBindingScope` and
  /// calling `updateModelValue` with the new value.
  static void update<T>(BuildContext context, StateUpdater<T> updater) {
    context
        .findAncestorStateOfType<_ModelBindingState<T>>()!
        .updateModelValue(updater);
  }

  /// Executes a command action by its type, if found in the `commands` map
  /// within the nearest `_ModelBindingScope`.
  static void performAction<T>(BuildContext context, Type action) {
    context
        .findAncestorStateOfType<_ModelBindingState<T>>()!
        .performAction(action);
  }

  static Widget withNotifier<T>({
    required ValueNotifier<T> notifier,
    required Widget Function(
      BuildContext context,
      T value,
      Widget? child,
    ) builder,
    required Widget child,
  }) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (
        BuildContext context,
        T value,
        Widget? childWidget,
      ) {
        return ModelBinding<T>(
          model: value,
          child: childWidget!,
        );
      },
      child: child,
    );
  }

  static Widget withNotifierSelector<T extends Listenable, S>({
    required T notifier,
    required S Function(T notifier) selector,
    required Widget Function(
      BuildContext context,
      S value,
      Widget? child,
    ) builder,
    required Widget child,
  }) {
    return NotifierSelector(
      notifier: notifier,
      selector: selector,
      builder: (
        BuildContext context,
        S value,
        Widget? childWidget,
      ) {
        return ModelBinding<S>(
          model: value,
          child: childWidget!,
        );
      },
      child: child,
    );
  }

  @override
  State<ModelBinding<T>> createState() => _ModelBindingState<T>();
}

/// `_ModelBindingState` manages the model data and provides methods to update
/// the model and perform actions. It also holds the current model value.
class _ModelBindingState<T> extends State<ModelBinding<T>> {
  late T currentModel;

  @override
  void initState() {
    super.initState();
    currentModel = widget.model;
  }

  @override
  void didUpdateWidget(covariant ModelBinding<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentModel = widget.model;
  }

  /// Updates the model value if it has changed and triggers `onUpdate` callback
  /// if provided. Calls `setState` to rebuild widgets depending on this model.
  void updateModelValue(StateUpdater<T> updater) {
    final value = updater(currentModel);
    if (value != currentModel) {
      currentModel = value;
      widget.onUpdate?.call(value);
      setState(() {});
    }
  }

  /// Executes a command action by its type if it exists in `commands`.
  void performAction(Type action) {
    widget.commands[action]?.perform();
  }

  @override
  Widget build(BuildContext context) {
    return _ModelBindingScope<T>(model: currentModel, child: widget.child);
  }
}

class NotifierSelector<T extends Listenable, S> extends StatefulWidget {
  const NotifierSelector({
    super.key,
    required this.notifier,
    required this.selector,
    required this.builder,
    this.child,
  });

  final T notifier;
  final S Function(T notifier) selector;
  final Widget Function(BuildContext context, S value, Widget? child) builder;
  final Widget? child;

  @override
  State<NotifierSelector<T, S>> createState() => _NotifierSelectorState<T, S>();
}

class _NotifierSelectorState<T extends Listenable, S>
    extends State<NotifierSelector<T, S>> {
  late S currentState;
  @override
  void initState() {
    super.initState();
    currentState = widget.selector(widget.notifier);
    widget.notifier.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant NotifierSelector<T, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notifier != widget.notifier) {
      oldWidget.notifier.removeListener(_listener);
      currentState = widget.selector(widget.notifier);
      widget.notifier.addListener(_listener);
    }
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    if (!mounted) {
      return;
    }
    final newState = widget.selector(widget.notifier);
    if (newState != currentState) {
      currentState = newState;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, currentState, widget.child);
  }
}

/// `ModelBindingExtension` adds convenience methods to `BuildContext`
/// for accessing the current model or a nullable model.
extension ModelBindingExtension on BuildContext {
  /// Provides the current model of type `T` from the nearest `ModelBinding`.
  T provide<T>() {
    return ModelBinding.of<T>(this);
  }

  /// Provides the current model of type `T` if it exists, otherwise `null`.
  T? maybeProvide<T>() {
    return ModelBinding.maybeOf<T>(this);
  }
}

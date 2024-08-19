import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/models.dart';

/// An index notifier use for tab or IndexStack.
///
/// Provide value through [ModelBinding] for use within [TabIndexListenerMixin]
class IndexNotifier<T extends Enum> extends ValueNotifier<T> {
  IndexNotifier(super.value);
  int get currentIndex => value.index;
}

/// Listen to IndexNotifier for index changes
///
/// Use [onIndexChanged] within state Tab widget. [IndexNotifier] must be provided
/// through [ModelBinding]
mixin TabIndexListenerMixin<T extends StatefulWidget> on State<T> {
  IndexNotifier? _indexNotifier;

  Enum get currentTabIndex => _indexNotifier!.value;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Assuming IndexNotifier is provided higher in the widget tree
    final notifier = ModelBinding.of<IndexNotifier>(context);
    if (notifier != _indexNotifier) {
      _indexNotifier?.removeListener(_onIndexChanged);
      _indexNotifier = notifier;
      _indexNotifier?.addListener(_onIndexChanged);
    }
  }

  @override
  void dispose() {
    _indexNotifier?.removeListener(_onIndexChanged);
    super.dispose();
  }

  void _onIndexChanged() {
    onIndexChanged(_indexNotifier?.currentIndex ?? 0);
  }

  /// Called when the Tab index changes
  void onIndexChanged(int newIndex);
}

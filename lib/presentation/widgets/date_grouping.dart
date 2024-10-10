import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef ItemIndexer<E> = E Function(int index);
typedef ItemHeadGetter<E> = int Function(E item);
typedef SeparatorWidgetBuilder<E> = Widget Function(E item);
typedef SeparatorComparator<E> = bool Function(E a, E b);
typedef IndexWidgetBuilder = Widget Function(BuildContext context, int index);
typedef BuildAsFirst<E> = bool Function(E currentItemBuild);

enum SeparatedPosition {
  before,
  after;

  bool get isBefore => this == SeparatedPosition.before;
}

class GroupValue<E> {
  int value = 0;

  /// Segment to group multiple sub heads.
  ///
  /// if
  ///
  int applyHeadSeg = -1;

  late SeparatedPosition position;

  /// List of heads available in order of items build
  List<int> heads = [];

  /// Index of heads
  List<int> indexes = [];

  /// Callback to check if item is the first item of the list
  late BuildAsFirst<E> checker;
}

class GroupValueProvider<E> extends InheritedWidget {
  const GroupValueProvider({
    super.key,
    required this.group,
    required super.child,
  });

  final GroupValue<E> group;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static _findAncestorAssertion<E>(GroupValueProvider<E>? ancestor) {
    assert(
      ancestor != null,
      'Ensure to have a GroupValueProvider widget as an ancestor, or use DefaultGroupValue as an ancestor',
    );
  }

  static GroupValue<E> of<E>(BuildContext context) {
    final ancestor =
        context.findAncestorWidgetOfExactType<GroupValueProvider<E>>();
    _findAncestorAssertion<E>(ancestor);
    return ancestor!.group;
  }

  static void updateValueOf<E>(BuildContext context, int value) {
    final ancestor =
        context.findAncestorWidgetOfExactType<GroupValueProvider<E>>();
    _findAncestorAssertion(ancestor);
    ancestor!.group.value = value;
  }

  static void updateHeadsOf<E>(BuildContext context, int value, int index) {
    final ancestor =
        context.findAncestorWidgetOfExactType<GroupValueProvider<E>>();
    _findAncestorAssertion(ancestor);
    ancestor!.group.heads.add(value);
    ancestor.group.indexes.add(index);
  }
}

class DefaultGroupProvider<E> extends StatefulWidget {
  const DefaultGroupProvider({
    super.key,
    this.applyHeadSeg,
    required this.buildAsFirst,
    required this.child,
    this.position = SeparatedPosition.before,
  });

  final int? applyHeadSeg;
  final SeparatedPosition position;
  final BuildAsFirst<E> buildAsFirst;
  final Widget child;

  @override
  State<DefaultGroupProvider<E>> createState() =>
      _DefaultGroupProviderState<E>();
}

class _DefaultGroupProviderState<E> extends State<DefaultGroupProvider<E>> {
  GroupValue<E> group = GroupValue<E>();

  @override
  void didUpdateWidget(covariant DefaultGroupProvider<E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.position != widget.position) group = GroupValue<E>();
  }

  @override
  Widget build(BuildContext context) {
    return GroupValueProvider(
      group: group
        ..position = widget.position
        ..checker = widget.buildAsFirst
        ..applyHeadSeg = widget.applyHeadSeg ?? -1,
      child: widget.child,
    );
  }
}

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

bool _canGroup<E>(
  E prevOrNextItem,
  E currentItem,
  GroupValue<E> group,
  SeparatorComparator<E> comparator,
  ItemHeadGetter<E> itemHeadGetter,
  int localIndex,
) {
  final currentHead = itemHeadGetter(currentItem);
  final prevOrNextHead = itemHeadGetter(prevOrNextItem);
  final comparatorResult = comparator(currentItem, prevOrNextItem);
  final applyHeadSeg = group.applyHeadSeg;

  if (currentHead > applyHeadSeg && comparatorResult) {
    return true;
  }

  if (currentHead < group.value && localIndex >= 0) {
    final currentHeadIndex = group.heads.indexOf(currentHead);

    if (currentHeadIndex >= 0) {
      int attrLocalIndex = group.indexes[currentHeadIndex];

      if (localIndex != attrLocalIndex) {
        if (prevOrNextHead < currentHead || prevOrNextHead > currentHead) {
          if (prevOrNextHead < currentHead || prevOrNextHead > currentHead) {
            group.indexes.insert(currentHeadIndex, localIndex);
            attrLocalIndex = localIndex;
          }
        }
      }

      return group.position.isBefore
          ? prevOrNextHead <= currentHead && attrLocalIndex == localIndex
          : prevOrNextHead > currentHead && attrLocalIndex == localIndex;
    } else {
      group.heads
        ..remove(currentHead)
        ..add(currentHead)
        ..sort();
      final headIndex = group.heads.indexOf(currentHead);
      group.indexes[headIndex] = localIndex;
      return true;
    }
  }

  return currentHead != group.value || prevOrNextHead != currentHead;
}

Widget _separatorLogicBuilder<E>(
  BuildContext context,
  IndexWidgetBuilder separatorBuilder,
  SeparatorComparator<E> comparator,
  ItemHeadGetter<E> itemHeadGetter,
  ItemIndexer<E> indexer, {
  int localIndex = -1,
  int localChildCount = 1,
}) {
  final group = GroupValueProvider.of<E>(context);
  final E currentItem = indexer(localIndex);
  final E prevOrNextItem;
  final applyHeadSeg = group.applyHeadSeg;
  bool lastOrFirstItem = false;

  if (group.position.isBefore) {
    if (localIndex <= 0) {
      prevOrNextItem = currentItem;
      lastOrFirstItem = true;
    } else {
      prevOrNextItem = indexer(localIndex - 1);
    }
  } else {
    if (localIndex + 1 >= localChildCount || localIndex <= 0) {
      prevOrNextItem = currentItem;
      lastOrFirstItem = true;
    } else {
      prevOrNextItem = indexer(localIndex + 1);
    }
  }

  final currentHead = itemHeadGetter(currentItem);
  final canGroup = lastOrFirstItem && currentHead > applyHeadSeg ||
      _canGroup(
        prevOrNextItem,
        currentItem,
        group,
        comparator,
        itemHeadGetter,
        localIndex,
      );
  Widget separatorWidget = const SizedBox();

  if (group.checker(currentItem) || canGroup) {
    separatorWidget = separatorBuilder(context, localIndex);
  }

  if (currentHead > group.value) {
    GroupValueProvider.updateValueOf<E>(context, currentHead);
  }

  if (group.heads.isEmpty || currentHead > group.heads.last) {
    GroupValueProvider.updateHeadsOf<E>(context, currentHead, localIndex);
  }

  return separatorWidget;
}

class SliverSingleGroup<E> extends StatelessWidget {
  const SliverSingleGroup({
    super.key,
    this.separatorAlignment = Alignment.centerLeft,
    required this.sliver,
    required this.separatorBuilder,
    required this.item,
    required this.itemHeadGetter,
  });

  final Alignment separatorAlignment;
  final E item;
  final ItemHeadGetter<E> itemHeadGetter;
  final SeparatorWidgetBuilder<E> separatorBuilder;
  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    final separatorWidget = Align(
      alignment: separatorAlignment,
      child: _separatorLogicBuilder<E>(
        context,
        (BuildContext _, int __) => separatorBuilder(item),
        (E _, E __) => false,
        itemHeadGetter,
        (int _) => item,
      ),
    );

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(child: separatorWidget),
        sliver,
      ],
    );
  }
}

class SliverGroupList<E> extends StatelessWidget {
  const SliverGroupList({
    super.key,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.itemIndexer,
    required this.comparator,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.findChildIndexCallback,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
    required this.childCount,
    required this.itemHeadGetter,
  });

  final int childCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final int? Function(Widget, int) semanticIndexCallback;
  final int? Function(Key)? findChildIndexCallback;
  final int semanticIndexOffset;
  final IndexWidgetBuilder itemBuilder;
  final IndexWidgetBuilder separatorBuilder;
  final SeparatorComparator<E> comparator;
  final ItemHeadGetter<E> itemHeadGetter;
  final ItemIndexer<E> itemIndexer;

  @override
  Widget build(BuildContext context) {
    final group = GroupValueProvider.of<E>(context);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final localIndex = index ~/ 2;
          if (group.position.isBefore ? index.isEven : index.isOdd) {
            return _separatorLogicBuilder(
              context,
              separatorBuilder,
              comparator,
              itemHeadGetter,
              itemIndexer,
              localIndex: localIndex,
              localChildCount: childCount,
            );
          }

          return itemBuilder(context, localIndex);
        },
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        findChildIndexCallback: findChildIndexCallback,
        semanticIndexCallback: semanticIndexCallback,
        semanticIndexOffset: semanticIndexOffset,
        childCount: childCount * 2,
      ),
    );
  }
}

class GroupList<E> extends StatelessWidget {
  const GroupList({
    super.key,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.comparator,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    required this.scrollDirection,
    this.controller,
    this.primary,
    this.physics,
    required this.shrinkWrap,
    this.padding,
    this.itemExtent,
    this.itemExtentBuilder,
    this.prototypeItem,
    this.findChildIndexCallback,
    required this.itemCount,
    this.cacheExtent,
    required this.dragStartBehavior,
    required this.keyboardDismissBehavior,
    this.restorationId,
    required this.clipBehavior,
    this.semanticChildCount,
    required this.itemHeadGetter,
    required this.itemIndexer,
  });

  final Axis scrollDirection;
  final bool reverse = false;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final double? itemExtent;
  final double? Function(int, SliverLayoutDimensions)? itemExtentBuilder;
  final Widget? prototypeItem;
  final int? Function(Key)? findChildIndexCallback;
  final int itemCount;
  final int? semanticChildCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  final IndexWidgetBuilder itemBuilder;
  final IndexWidgetBuilder separatorBuilder;
  final SeparatorComparator<E> comparator;
  final ItemHeadGetter<E> itemHeadGetter;
  final ItemIndexer<E> itemIndexer;

  int? get localChildCount => itemCount * 2;
  @override
  Widget build(BuildContext context) {
    final group = GroupValueProvider.of<E>(context);
    return ListView.builder(
      physics: physics,
      padding: padding,
      reverse: reverse,
      primary: primary,
      controller: controller,
      itemExtent: itemExtent,
      shrinkWrap: shrinkWrap,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
      restorationId: restorationId,
      scrollDirection: scrollDirection,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      findChildIndexCallback: findChildIndexCallback,
      prototypeItem: prototypeItem,
      keyboardDismissBehavior: keyboardDismissBehavior,
      itemExtentBuilder: itemExtentBuilder,
      dragStartBehavior: dragStartBehavior,
      semanticChildCount: semanticChildCount,
      itemBuilder: (BuildContext context, int index) {
        final localIndex = index ~/ 2;

        if (group.position.isBefore ? index.isEven : index.isOdd) {
          return _separatorLogicBuilder(
            context,
            separatorBuilder,
            comparator,
            itemHeadGetter,
            itemIndexer,
            localIndex: localIndex,
            localChildCount: itemCount,
          );
        }

        return itemBuilder(context, localIndex);
      },
      itemCount: itemCount,
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:youtube_clone/core.dart';

typedef DateTimeIndexer = DateTime Function(int index);
typedef DateWidgetBuilder = Widget Function(DateTime date);
typedef SeparatorComparator = bool Function(DateTime a, DateTime b);
typedef IndexWidgetBuilder = Widget Function(BuildContext context, int index);
typedef BuildAsFirst = bool Function(DateTime currentDateBuild);

class GroupValue {
  DateHead value = DateHead.today;
  DateHead lastBuildValue = DateHead.today;
  List<DateHead> heads = [];
  List<int> indexes = [];
  BuildAsFirst checker = (DateTime currentDateBuild) => false;
}

class SeparatorWidget extends StatelessWidget {
  const SeparatorWidget({super.key, required this.date});
  final DateTime date;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Text(
        date.header,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class DefaultGroupValue extends StatefulWidget {
  const DefaultGroupValue({
    super.key,
    required this.buildAsFirst,
    required this.child,
  });
  final BuildAsFirst buildAsFirst;
  final Widget child;

  @override
  State<DefaultGroupValue> createState() => _DefaultGroupValueState();
}

class _DefaultGroupValueState extends State<DefaultGroupValue> {
  final GroupValue group = GroupValue();

  @override
  Widget build(BuildContext context) {
    return DateGroup(
      group: group
        ..value = DateHead.today
        ..checker = widget.buildAsFirst,
      child: widget.child,
    );
  }
}

class DateGroup extends InheritedWidget {
  const DateGroup({
    super.key,
    required this.group,
    required super.child,
  });

  final GroupValue group;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static _findAncestorAssertion(DateGroup? ancestor) {
    assert(
      ancestor != null,
      'Ensure to have a DateGroup widget as an ancestor, or use DefaultGroupingController as an ancestor',
    );
  }

  static GroupValue of(BuildContext context) {
    final ancestor = context.findAncestorWidgetOfExactType<DateGroup>();
    _findAncestorAssertion(ancestor);
    return ancestor!.group;
  }

  static void updateValueOf(BuildContext context, DateHead value) {
    final ancestor = context.findAncestorWidgetOfExactType<DateGroup>();
    _findAncestorAssertion(ancestor);
    ancestor!.group.value = value;
  }

  static void updateHeadsOf(BuildContext context, DateHead value, int index) {
    final ancestor = context.findAncestorWidgetOfExactType<DateGroup>();
    _findAncestorAssertion(ancestor);
    ancestor!.group.heads.add(value);
    ancestor.group.indexes.add(index);
  }
}

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

Widget _separatorLogicBuilder(
  BuildContext context,
  IndexWidgetBuilder separatorBuilder,
  SeparatorComparator comparator,
  DateTimeIndexer indexer,
  int localIndex,
) {
  final group = DateGroup.of(context);
  final currentDate = indexer(localIndex);
  final previousDate = localIndex == 0 ? currentDate : indexer(localIndex - 1);

  final currentHead = currentDate.asHeader;
  final previousHead = previousDate.asHeader;
  final comparatorResult = comparator(currentDate, previousDate);

  final canGroup = currentHead.index > DateHead.month.index &&
          comparatorResult ||
      (currentHead.index < group.value.index
          ? () {
              if (previousHead.index < currentHead.index) {
                if (group.heads.length >= 2) {
                  return previousHead.index <
                      group.heads[group.heads.indexOf(currentHead) - 1].index;
                }
              } else if (currentDate == previousDate) {
                final headIndex = group.heads
                    .indexOf(currentHead)
                    .clamp(0, group.heads.length - 1);
                return group.indexes[headIndex] <= localIndex;
              }
              return previousHead != currentHead;
            }()
          : currentHead.index != group.value.index &&
              (previousHead != currentHead || localIndex <= 0));
  Widget separatorWidget = const SizedBox();

  if (localIndex <= 0 && group.checker(currentDate) || canGroup) {
    separatorWidget = separatorBuilder(context, localIndex);
  }

  // Updates new DateGroup value
  if (currentHead.index > group.value.index) {
    DateGroup.updateValueOf(context, currentHead);
  }

  if (group.heads.isEmpty || currentHead.index > group.heads.last.index) {
    DateGroup.updateHeadsOf(context, currentHead, localIndex);
  }

  return separatorWidget;
}

class SliverSingleDateGroup extends StatelessWidget {
  const SliverSingleDateGroup({
    super.key,
    this.separatorAlignment = Alignment.centerLeft,
    required this.child,
    required this.separatorBuilder,
    required this.date,
  });
  final Alignment separatorAlignment;
  final DateTime date;
  final DateWidgetBuilder separatorBuilder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Align(
            alignment: separatorAlignment,
            child: _separatorLogicBuilder(
              context,
              (context, index) => separatorBuilder(date),
              (a, b) => false,
              (index) => date,
              -1,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class SliverDateGroupList extends StatelessWidget {
  const SliverDateGroupList({
    super.key,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.indexedDateItem,
    required this.comparator,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.findChildIndexCallback,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
    this.childCount,
  });

  final int? childCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final int? Function(Widget, int) semanticIndexCallback;
  final int? Function(Key)? findChildIndexCallback;
  final int semanticIndexOffset;
  final IndexWidgetBuilder itemBuilder;
  final IndexWidgetBuilder separatorBuilder;
  final SeparatorComparator comparator;
  final DateTimeIndexer indexedDateItem;

  int? get localChildCount => childCount == null ? null : childCount! * 2;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final localIndex = index ~/ 2;

          if (index.isEven) {
            return _separatorLogicBuilder(
              context,
              separatorBuilder,
              comparator,
              indexedDateItem,
              localIndex,
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
        childCount: localChildCount,
      ),
    );
  }
}

class DateGroupList extends StatelessWidget {
  const DateGroupList({
    super.key,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.comparator,
    required this.indexedDateItem,
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
    this.itemCount,
    this.cacheExtent,
    required this.dragStartBehavior,
    required this.keyboardDismissBehavior,
    this.restorationId,
    required this.clipBehavior,
    this.semanticChildCount,
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
  final int? itemCount;
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
  final SeparatorComparator comparator;
  final DateTimeIndexer indexedDateItem;

  int? get localChildCount => itemCount == null ? null : itemCount! * 2;
  @override
  Widget build(BuildContext context) {
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

        if (index.isEven) {
          return _separatorLogicBuilder(
            context,
            separatorBuilder,
            comparator,
            indexedDateItem,
            localIndex,
          );
        }

        return itemBuilder(context, localIndex);
      },
      itemCount: itemCount,
    );
  }
}

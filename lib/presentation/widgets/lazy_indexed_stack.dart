import 'package:flutter/material.dart';

class LazyIndexedStack extends StatefulWidget {
  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final Clip clipBehavior;
  final StackFit sizing;
  final int? index;
  final List<Widget> children;

  const LazyIndexedStack({
    super.key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.clipBehavior = Clip.hardEdge,
    this.sizing = StackFit.loose,
    this.index = 0,
    this.children = const <Widget>[],
  });

  @override
  State<LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  late int _lastIndex = widget.index ?? 0;
  late int index = widget.index ?? 0;
  final List<Widget> _lazyChildren = [];
  final Set<int> _addedChildren = {};

  @override
  void initState() {
    super.initState();
    if (widget.children.isNotEmpty) {
      _lazyChildren.addAll(
        List.generate(widget.children.length, (index) {
          return const SizedBox();
        }),
      );
      _lazyChildren.insert(index, widget.children[index]);
      _addedChildren.add(index);
    }
  }

  @override
  void didUpdateWidget(covariant LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    index = widget.index ?? 0;
    if (_lastIndex != index) {
      _lazyChildren.insert(_lastIndex, const SizedBox());
      _addedChildren.remove(_lastIndex);
      _lastIndex = index;
    }
    _updateChildren();
  }

  void _updateChildren() {
    if (widget.children.isNotEmpty) {
      if (!_addedChildren.contains(index)) {
        _lazyChildren.insert(index, widget.children[index]);
        _addedChildren.add(index);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: index,
      children: _lazyChildren,
    );
  }
}

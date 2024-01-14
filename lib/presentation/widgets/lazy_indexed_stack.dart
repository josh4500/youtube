// MIT License
//
// Copyright (c) 2024 Ajibola Akinmosin (https://github.com/josh4500)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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

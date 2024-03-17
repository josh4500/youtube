// Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of {{ project }} nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RouletteScroll<T> extends StatefulWidget {
  const RouletteScroll({
    super.key,
    required this.items,
    required this.controller,
    required this.onPageChange,
    this.initialValue,
  });

  final T? initialValue;
  final List<T> items;
  final PageController controller;
  final ValueChanged<T> onPageChange;

  @override
  State<RouletteScroll<T>> createState() => RouletteScrollState<T>();
}

class RouletteScrollState<T> extends State<RouletteScroll<T>> {
  bool switcher = true;
  List<T> effectiveItems = <T>[];
  late final int _extra = ((widget.items.length + 1) / 2).ceil();

  int get addedExtra => _extra - 1;
  int get totalItems => widget.items.length;
  late final T middleItem;
  late final T beforeMiddleItem;
  late final T beforeLastItem;

  late final T beforeBMiddleItem;
  late final T beforeBLastItem;

  bool firstTurn = false;

  T get lastItem => widget.items.last;
  T get firstItem => widget.items.first;

  final ValueNotifier<int> currentPageIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    final Iterable<T> extraItems =
        widget.items.getRange(addedExtra, widget.items.length);
    effectiveItems = <T>[...extraItems, ...widget.items];
    final int initialIndex = widget.items.indexWhere(
      (T element) => element == widget.initialValue,
    );

    if (initialIndex >= addedExtra) {
      effectiveItems.addAll(
        List<T>.generate(_extra, (int index) => widget.items[index]),
      );
    }

    middleItem = effectiveItems[addedExtra * 2];
    beforeMiddleItem = effectiveItems[(addedExtra * 2) - 1];
    beforeBMiddleItem = effectiveItems[(addedExtra * 2) - 2];

    beforeLastItem = widget.items[widget.items.length - 2];
    beforeBLastItem = widget.items[widget.items.length - 3];

    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      firstTurn = true;
      final int newIndex =
          initialIndex >= 0 ? addedExtra + initialIndex : addedExtra;

      widget.controller.jumpToPage(newIndex);
      Future<int>.microtask(() => currentPageIndex.value = newIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: 50,
          width: 80,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey,
                width: 1.5,
              ),
              bottom: BorderSide(
                color: Colors.grey,
                width: 1.5,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: widget.controller,
              scrollDirection: Axis.vertical,
              onPageChanged: (int pageIndex) {
                final T currentItem = effectiveItems[pageIndex];
                currentPageIndex.value = pageIndex;

                if (firstTurn) {
                  final ScrollDirection dir =
                      widget.controller.position.userScrollDirection;
                  final bool f = dir == ScrollDirection.reverse;

                  final bool a = effectiveItems.last == lastItem && f;
                  final bool b = effectiveItems.last == middleItem && f;
                  final bool c = effectiveItems.last == lastItem && !f;
                  final bool d = effectiveItems.first == firstItem && !f;
                  if (currentItem == beforeMiddleItem && (switcher || f) && a) {
                    effectiveItems.removeRange(0, addedExtra);

                    effectiveItems.addAll(
                      List<T>.generate(
                        _extra,
                        (int index) => widget.items[index],
                      ),
                    );
                    switcher = !switcher && !f;

                    setState(() {});
                    currentPageIndex.value = pageIndex - addedExtra;
                    _gotoPage(pageIndex - addedExtra);
                  } else if (currentItem == beforeLastItem &&
                      (!switcher || f) &&
                      b) {
                    effectiveItems.removeRange(0, addedExtra);
                    effectiveItems.addAll(
                      List<T>.generate(
                        widget.items.length - _extra,
                        (int index) => widget.items[index + _extra],
                      ),
                    );
                    switcher = !switcher && !f;
                    setState(() {});
                    currentPageIndex.value = pageIndex - addedExtra;
                    _gotoPage(pageIndex - addedExtra);
                  } else if (currentItem == lastItem && (switcher || !f) && c) {
                    effectiveItems.removeRange(
                      (effectiveItems.length - addedExtra) + 1,
                      effectiveItems.length,
                    );

                    effectiveItems.insertAll(
                      0,
                      List<T>.generate(
                        addedExtra,
                        (int index) => widget.items[index],
                      ),
                    );
                    switcher = !switcher && !f;

                    setState(() {});
                    currentPageIndex.value = widget.items.length - 1;
                    _gotoPage(widget.items.length - 1);
                  } else if (currentItem == middleItem &&
                      (!switcher || !f) &&
                      d) {
                    effectiveItems.removeRange(
                      effectiveItems.length - _extra,
                      effectiveItems.length,
                    );

                    effectiveItems.insertAll(
                      0,
                      List<T>.generate(
                        addedExtra,
                        (int index) => widget.items[index + addedExtra],
                      ),
                    );
                    switcher = !switcher && !f;
                    setState(() {});
                    currentPageIndex.value = widget.items.length;
                    _gotoPage(widget.items.length);
                  } else if (currentItem == beforeBLastItem && c) {
                    effectiveItems.removeRange(
                      (effectiveItems.length - addedExtra) + 1,
                      effectiveItems.length,
                    );

                    effectiveItems.insertAll(
                      0,
                      List<T>.generate(
                        addedExtra,
                        (int index) => widget.items[index],
                      ),
                    );
                    switcher = !switcher && !f;

                    setState(() {});
                    currentPageIndex.value = widget.items.length - 3;
                    _gotoPage(widget.items.length - 3);
                  } else if (currentItem == beforeBMiddleItem && b) {
                    effectiveItems.removeRange(
                      effectiveItems.length - _extra,
                      effectiveItems.length,
                    );

                    effectiveItems.insertAll(
                      0,
                      List<T>.generate(
                        addedExtra,
                        (int index) => widget.items[index + addedExtra],
                      ),
                    );
                    switcher = !switcher && !f;
                    setState(() {});

                    currentPageIndex.value = widget.items.length - 2;
                    _gotoPage(widget.items.length - 2);
                  }

                  if (currentItem == middleItem &&
                      !(a || b || c || d) &&
                      switcher) {
                    effectiveItems.removeRange(
                      effectiveItems.length - _extra,
                      effectiveItems.length,
                    );

                    effectiveItems.insertAll(
                      0,
                      List<T>.generate(
                        addedExtra,
                        (int index) => widget.items[index + addedExtra],
                      ),
                    );
                    switcher = !switcher && !f;
                    setState(() {});
                    currentPageIndex.value = widget.items.length + addedExtra;
                    widget.controller
                        .jumpToPage(widget.items.length + addedExtra);
                  }
                } else {
                  firstTurn = true;
                }
                widget.onPageChange(currentItem);
              },
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  child: ListenableBuilder(
                    listenable: currentPageIndex,
                    builder: (BuildContext context, _) {
                      return Text(
                        effectiveItems[index].toString(),
                        style: currentPageIndex.value != index
                            ? const TextStyle(color: Color(0x30D3D3D3))
                            : null,
                      );
                    },
                  ),
                );
              },
              itemCount: effectiveItems.length,
            ),
          ),
        ),
      ],
    );
  }

  void _gotoPage(int index) {
    widget.controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 75),
      curve: Curves.bounceIn,
    );
  }
}

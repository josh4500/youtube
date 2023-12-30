import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RouletteScroll<T> extends StatefulWidget {
  final T? initialValue;
  final List<T> items;
  final PageController controller;
  final ValueChanged<T> onPageChange;

  const RouletteScroll({
    super.key,
    required this.items,
    required this.controller,
    required this.onPageChange,
    this.initialValue,
  });

  @override
  State<RouletteScroll<T>> createState() => RouletteScrollState<T>();
}

class RouletteScrollState<T> extends State<RouletteScroll<T>> {
  bool switcher = true;
  List<T> effectiveItems = [];
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

  final currentPageIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    final extraItems = widget.items.getRange(addedExtra, widget.items.length);
    effectiveItems = [...extraItems, ...widget.items];
    final initialIndex = widget.items.indexWhere(
      (element) => element == widget.initialValue,
    );

    if (initialIndex >= addedExtra) {
      effectiveItems.addAll(
        List.generate(_extra, (index) => widget.items[index]),
      );
    }

    middleItem = effectiveItems[addedExtra * 2];
    beforeMiddleItem = effectiveItems[(addedExtra * 2) - 1];
    beforeBMiddleItem = effectiveItems[(addedExtra * 2) - 2];

    beforeLastItem = widget.items[widget.items.length - 2];
    beforeBLastItem = widget.items[widget.items.length - 3];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      firstTurn = true;
      final newIndex =
          initialIndex >= 0 ? addedExtra + initialIndex : addedExtra;

      widget.controller.jumpToPage(newIndex);
      Future.microtask(() => currentPageIndex.value = newIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
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
              onPageChanged: (pageIndex) {
                final currentItem = effectiveItems[pageIndex];
                currentPageIndex.value = pageIndex;

                if (firstTurn) {
                  final dir = widget.controller.position.userScrollDirection;
                  final f = dir == ScrollDirection.reverse;

                  final a = effectiveItems.last == lastItem && f;
                  final b = effectiveItems.last == middleItem && f;
                  final c = effectiveItems.last == lastItem && !f;
                  final d = effectiveItems.first == firstItem && !f;
                  if (currentItem == beforeMiddleItem && (switcher || f) && a) {
                    effectiveItems.removeRange(0, addedExtra);

                    effectiveItems.addAll(
                      List.generate(_extra, (index) => widget.items[index]),
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
                      List.generate(
                        (widget.items.length - _extra),
                        (index) => widget.items[index + _extra],
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
                      List.generate(addedExtra, (index) => widget.items[index]),
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
                      List.generate(
                        addedExtra,
                        (index) => widget.items[index + addedExtra],
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
                      List.generate(addedExtra, (index) => widget.items[index]),
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
                      List.generate(
                        addedExtra,
                        (index) => widget.items[index + addedExtra],
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
                      List.generate(
                        addedExtra,
                        (index) => widget.items[index + addedExtra],
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
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  child: ListenableBuilder(
                      listenable: currentPageIndex,
                      builder: (context, _) {
                        return Text(
                          effectiveItems[index].toString(),
                          style: currentPageIndex.value != index
                              ? const TextStyle(color: Color(0x30D3D3D3))
                              : null,
                        );
                      }),
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

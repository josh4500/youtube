import 'package:flutter/material.dart';

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

  bool firstTurn = false;

  T get lastItem => widget.items.last;

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
      effectiveItems = [
        ...widget.items,
        ...widget.items.getRange(0, addedExtra),
      ];
      middleItem = effectiveItems[addedExtra * 2];
      beforeMiddleItem = effectiveItems[(addedExtra * 2) - 1];
    } else {
      middleItem = effectiveItems[addedExtra * 2];
      beforeMiddleItem = effectiveItems[(addedExtra * 2) - 1];
    }

    beforeLastItem = widget.items[widget.items.length - 2];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      firstTurn = true;
      final newIndex = initialIndex >= 0
          ? initialIndex >= addedExtra
              ? initialIndex
              : addedExtra + initialIndex
          : addedExtra;
      widget.controller.jumpToPage(
        newIndex,
        // duration: const Duration(milliseconds: 200),
        // curve: Curves.ease,
      );
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
              controller: widget.controller,
              scrollDirection: Axis.vertical,
              clipBehavior: Clip.none,
              onPageChanged: (pageIndex) {
                final currentItem = effectiveItems[pageIndex];
                currentPageIndex.value = pageIndex;

                final a = effectiveItems.last == lastItem;
                final b = effectiveItems.last == middleItem;

                if (firstTurn) {
                  if (currentItem == beforeMiddleItem && switcher && a) {
                    effectiveItems.removeRange(0, addedExtra);

                    effectiveItems.addAll(
                      List.generate(_extra, (index) => widget.items[index]),
                    );
                    switcher = !switcher;

                    setState(() {});
                    currentPageIndex.value = pageIndex - addedExtra;
                    widget.controller.jumpToPage(pageIndex - addedExtra);

                    print('Generated A');
                  } else if (currentItem == beforeLastItem && !switcher && b) {
                    effectiveItems.removeRange(0, addedExtra);
                    effectiveItems.addAll(
                      List.generate(
                        (widget.items.length - _extra),
                        (index) => widget.items[index + _extra],
                      ),
                    );
                    switcher = !switcher;
                    setState(() {});
                    currentPageIndex.value = pageIndex - addedExtra;
                    widget.controller.jumpToPage(pageIndex - addedExtra);
                    print('Generated B');
                  }
                  // else if (currentItem == lastItem && switcher && a) {
                  //   effectiveItems.removeRange(
                  //     (effectiveItems.length - addedExtra) + 1,
                  //     effectiveItems.length,
                  //   );
                  //
                  //   effectiveItems.insertAll(
                  //     0,
                  //     List.generate(addedExtra, (index) => widget.items[index]),
                  //   );
                  //   switcher = !switcher;
                  //
                  //   setState(() {});
                  //   currentPageIndex.value = widget.items.length - 1;
                  //   widget.controller.jumpToPage(widget.items.length - 1);
                  //   print('Generated C');
                  // }
                  // else if (currentItem == middleItem && switcher) {
                  //   effectiveItems.removeRange(
                  //     effectiveItems.length - _extra,
                  //     effectiveItems.length,
                  //   );
                  //   effectiveItems.insertAll(
                  //     0,
                  //     List.generate(
                  //         _extra, (index) => widget.items[index + _extra]),
                  //   );
                  //   switcher = !switcher;
                  //   setState(() {});
                  // print('Generated C');
                  // }
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
}

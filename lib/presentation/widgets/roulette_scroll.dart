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
  final ValueNotifier<int> currentPageIndex = ValueNotifier<int>(0);
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      final index = widget.items.indexOf(widget.initialValue as T);
      currentPageIndex.value = index;
      WidgetsBinding.instance.addPostFrameCallback((Duration _) {
        // if (index >= 0) {
        //   Scrollable.ensureVisible(
        //     GlobalObjectKey(currentPageIndex.value).currentContext!,
        //     curve: Curves.easeInOut,
        //   );
        // }
      });
    }
  }

  @override
  void dispose() {
    currentPageIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        IgnorePointer(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(height: 32, width: 80),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey, width: 1.5),
                    bottom: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: ListWheelScrollView.useDelegate(
              itemExtent: 40.0,
              onSelectedItemChanged: (int index) {
                currentPageIndex.value = index;
                widget.onPageChange(widget.items[index]);
              },
              useMagnifier: true,
              physics: const PageScrollPhysics(),
              diameterRatio: 22,
              //controller: controller,
              childDelegate: ListWheelChildLoopingListDelegate(
                children: List.generate(widget.items.length, (int index) {
                  return ListenableBuilder(
                    listenable: currentPageIndex,
                    builder: (BuildContext context, Widget? _) {
                      return Text(
                        widget.items[index].toString(),
                        style: currentPageIndex.value != index
                            ? const TextStyle(color: Color(0x30D3D3D3))
                            : null,
                      );
                    },
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

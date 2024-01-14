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

class HistorySearchTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const HistorySearchTextField({super.key, this.controller, this.focusNode});

  @override
  State<HistorySearchTextField> createState() => _HistorySearchTextFieldState();
}

class _HistorySearchTextFieldState extends State<HistorySearchTextField>
    with TickerProviderStateMixin {
  late final TextEditingController _effectiveController;
  late final FocusNode _effectiveFocusNode;
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _effectiveController = widget.controller ?? TextEditingController();
    _effectiveFocusNode = widget.focusNode ?? FocusNode();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      animationBehavior: AnimationBehavior.preserve,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    _effectiveFocusNode.addListener(_focusNodeListener);
  }

  void _focusNodeListener() {
    if (_effectiveFocusNode.hasFocus) {
      _controller.forward();
    } else if (_effectiveController.text.isEmpty) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      color: const Color(0xff2c2c2c),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.search),
          ),
          Expanded(
            child: TextField(
              focusNode: _effectiveFocusNode,
              controller: _effectiveController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'Search watch history',
              ),
            ),
          ),
          ListenableBuilder(
            listenable: _effectiveController,
            builder: (context, child) {
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInCubic,
                opacity: _effectiveController.text.isNotEmpty ? 1 : 0,
                child: child!,
              );
            },
            child: IconButton(
              onPressed: () {
                _effectiveController.clear();
                _focusNodeListener();
              },
              icon: const Icon(Icons.clear),
            ),
          ),
          SizeTransition(
            sizeFactor: _animation,
            axis: Axis.horizontal,
            axisAlignment: 0,
            child: ColoredBox(
              color: Colors.white12,
              child: TextButton(
                onPressed: () {
                  _effectiveFocusNode.unfocus();
                  _effectiveController.clear();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

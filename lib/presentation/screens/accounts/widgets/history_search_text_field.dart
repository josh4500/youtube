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
import 'package:youtube_clone/presentation/themes.dart';

class HistorySearchTextField extends StatefulWidget {
  const HistorySearchTextField({super.key, this.controller, this.focusNode});
  final TextEditingController? controller;
  final FocusNode? focusNode;

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
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(YTIcons.search_outlined),
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
            builder: (BuildContext context, Widget? child) {
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInCubic,
                opacity: _effectiveController.text.isNotEmpty ? 1 : 0,
                child: child,
              );
            },
            child: IconButton(
              onPressed: () {
                _effectiveController.clear();
                _focusNodeListener();
              },
              icon: const Icon(YTIcons.close_outlined, size: 18),
            ),
          ),
          SizeTransition(
            sizeFactor: _animation,
            axis: Axis.horizontal,
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
          ),
        ],
      ),
    );
  }
}

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

class LinkTvScreen extends StatefulWidget {
  const LinkTvScreen({super.key});

  @override
  State<LinkTvScreen> createState() => _LinkTvScreenState();
}

class _LinkTvScreenState extends State<LinkTvScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Link with TV code'),
      ),
      body: Column(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                child: TextFormField(
                  keyboardAppearance: Brightness.dark,
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLength: 15,
                  onTapOutside: (PointerDownEvent event) {
                    _focusNode.requestFocus();
                  },
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  autofocus: true,
                  cursorOpacityAnimates: true,
                  cursorColor: context.theme.primaryColor,
                  decoration: InputDecoration(
                    border:  OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: context.theme.primaryColor,
                      ),
                    ),
                    enabledBorder:  OutlineInputBorder(
                      borderSide: BorderSide(
                        color: context.theme.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder:  OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: context.theme.primaryColor,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Colors.white,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Colors.white,
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: context.theme.primaryColor,
                    ),
                    labelText: 'Enter TV code',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.grey),
                  padding: WidgetStateProperty.all(
                    const EdgeInsetsDirectional.symmetric(
                      vertical: 8,
                      horizontal: 24,
                    ),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
                child: const Text(
                  'Link',
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(thickness: 1, height: 0),
        ],
      ),
    );
  }
}

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

import '../../network_image/custom_network_image.dart';

class ViewableSlidesContext extends StatefulWidget {
  const ViewableSlidesContext({super.key});

  @override
  State<ViewableSlidesContext> createState() => _ViewableSlidesContextState();
}

class _ViewableSlidesContextState extends State<ViewableSlidesContext> {
  final pageController = PageController(viewportFraction: 0.92);
  int slideCount = 4;
  final ValueNotifier<int> slidePageIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final ViewableStyle theme = context.theme.appStyles.viewableVideoStyle;
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(height: 320),
      child: PageView.builder(
        itemCount: slideCount,
        controller: pageController,
        onPageChanged: (int index) => slidePageIndex.value = index,
        itemBuilder: (BuildContext context, int slideIndex) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: theme.backgroundColor,
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: CustomNetworkImage('https://picsum.photos/450/900'),
                fit: BoxFit.cover,
              ),
            ),
            child: ListenableBuilder(
              listenable: slidePageIndex,
              builder: (context, _) {
                return Visibility(
                  visible: slidePageIndex.value == slideIndex,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${slideIndex + 1}/$slideCount',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

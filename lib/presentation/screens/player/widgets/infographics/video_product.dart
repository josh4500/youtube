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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'infographics_notification.dart';

class VideoProduct extends StatefulWidget {
  const VideoProduct({super.key});

  @override
  State<VideoProduct> createState() => _VideoProductState();
}

class _VideoProductState extends State<VideoProduct>
    with TickerProviderStateMixin {
  late AnimationController sizeController;
  late Animation<double> sizeAnimation;

  @override
  void initState() {
    super.initState();
    sizeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    sizeAnimation = CurvedAnimation(
      parent: sizeController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white54, width: .85),
      ),
      child: CustomInkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => sizeAnimation.value == 0
            ? sizeController.forward()
            : sizeController.reverse(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            SizeTransition(
              axis: Axis.horizontal,
              sizeFactor: sizeAnimation,
              axisAlignment: 1,
              fixedCrossAxisSizeFactor: 1,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Products',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8),
                      SizedBox(width: 24),
                    ],
                  ),
                  CustomInkWell(
                    padding: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      CloseInfographicsNotification().dispatch(context);
                    },
                    child: const Icon(
                      YTIcons.close_circle_outlined,
                      size: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

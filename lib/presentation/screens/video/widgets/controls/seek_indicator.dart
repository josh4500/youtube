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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum SeekNotificationType {
  none,
  speedUp2X,
  pullUp,
  slideLeftOrRight,
  slideFrame,
  release;

  bool get isSlideSeeking {
    return this == slideLeftOrRight || this == slideFrame || this == release;
  }

  bool get isSlideFrame => this == slideFrame;
  bool get isNone => this == none;
}

class SeekIndicator extends StatelessWidget {
  const SeekIndicator({
    super.key,
    required this.valueListenable,
  });
  final ValueListenable<SeekNotificationType> valueListenable;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SeekNotificationType>(
      valueListenable: valueListenable,
      builder: (
        BuildContext context,
        SeekNotificationType type,
        Widget? childWidget,
      ) {
        if (type.isNone || type.isSlideFrame) {
          return const SizedBox();
        }
        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (type == SeekNotificationType.speedUp2X) ...[
                const Text('2X'),
                const SizedBox(width: 4),
                const Icon(Icons.fast_forward),
              ] else if (type == SeekNotificationType.pullUp) ...[
                const Icon(Icons.expand_less),
                const SizedBox(width: 4),
                const Text('Pull up for precise seeking'),
              ] else if (type == SeekNotificationType.slideLeftOrRight) ...[
                const Icon(Icons.linear_scale),
                const SizedBox(width: 4),
                const Text('Slide left or right to seek'),
              ] else if (type == SeekNotificationType.release)
                const Text('Release to cancel')
              else
                const SizedBox(width: 80),
            ],
          ),
        );
      },
    );
  }
}

class SeekIndicatorClipper extends CustomClipper<Path> {
  SeekIndicatorClipper({super.reclip, this.forward = true});
  final bool forward;
  @override
  Path getClip(Size size) {
    final Path path = Path();

    if (forward) {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width * .2, size.height);
      path.quadraticBezierTo(0, size.height * .5, size.width * .2, 0);
    } else {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width * .8, size.height);
      path.quadraticBezierTo(size.width, size.height * .5, size.width * .8, 0);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}

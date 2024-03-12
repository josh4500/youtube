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

import 'dart:math';

import 'package:flutter/material.dart';

// TODO: Use clipper to create if channel is live
class ChannelAvatar extends StatelessWidget {
  final double? size;
  final VoidCallback? onTap;
  const ChannelAvatar({super.key, this.size, this.onTap});

  @override
  Widget build(BuildContext context) {
    bool hasLive = Random().nextBool();
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: size ?? 50,
            height: size ?? 50,
            padding: hasLive ? const EdgeInsets.all(1) : null,
            decoration: const BoxDecoration(
              color: Colors.white12,
              image: DecorationImage(
                image: NetworkImage('https://i.pravatar.cc/300'),
                fit: BoxFit.cover,
              ),
              shape: BoxShape.circle,
            ),
          ),
          // if (hasLive)
          //   Positioned(
          //     bottom: -1,
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 1.5,
          //       ),
          //       decoration: BoxDecoration(
          //         color: const Color(0xFFFF0000),
          //         borderRadius: BorderRadius.circular(2),
          //       ),
          //       child: const Text(
          //         'Live',
          //         style: TextStyle(
          //           fontSize: 12,
          //           fontWeight: FontWeight.w400,
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}

class LiveCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..color = const Color(0xFFFF0000)
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

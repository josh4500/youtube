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

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'network_image/custom_network_image.dart';

const List<Color> _avatarColor = <Color>[
  Color(0xFF512DA7),
  Color(0xFF0288d1),
  Color(0xFF0098A6),
  Color(0xFF7E57C2),
  Color(0xFF689F39),
  Color(0xFFBF360C),
  Color(0xFF5C6BC0),
  Color(0xFFAA47BC),
  Color(0xFF5D4038),
  Color(0xFF33691E),
  Color(0xFF78909C),
  Color(0xFF00887A),
  Color(0xFFF5511E),
  Color(0xFF7A1FA2),
  Color(0xFF00579C),
  Color(0xFF465A65),
  Color(0xFFEF6C00),
  Color(0xFFEC407A),
  Color(0xFFC2175B),
  Color(0xFF004C3F),
];

// TODO(Josh): Use clipper to create if channel is live
class AccountAvatar extends StatelessWidget {
  const AccountAvatar({
    super.key,
    this.size = 50,
    this.name = 'Joshua john',
    this.imageUrl = 'https://i.pravatar.cc/300',
    this.border,
    this.onTap,
  });
  final Border? border;
  final double size;
  final String name;
  final String? imageUrl;
  final VoidCallback? onTap;

  Color _computeColorFromText(String text) {
    final hash = text.hashCode;
    final int colorIndex = hash % _avatarColor.length;
    return _avatarColor[colorIndex];
  }

  @override
  Widget build(BuildContext context) {
    final bool hasLive = Random().nextBool();
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            width: size,
            height: size,
            padding: hasLive ? const EdgeInsets.all(1) : null,
            decoration: BoxDecoration(
              color: Colors.white12,
              image: DecorationImage(
                image: CustomNetworkImage(
                  imageUrl!,
                  replacement: ImageReplacement(
                    text: name,
                    color: _computeColorFromText(name),
                    size: const Size.square(200),
                    textStyle: const TextStyle(
                      fontSize: 72,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                fit: BoxFit.cover,
              ),
              border: border,
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
    final Paint paint = Paint()
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

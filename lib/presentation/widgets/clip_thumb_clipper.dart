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

class ClipThumbClipper extends CustomClipper<Path> {
  static const count = 24;

  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    final mover = (height / count);

    var path = Path();
    // Left side
    path.moveTo(0, 0);
    for (int i = 1; i < count + 1; i++) {
      path.lineTo(i.isOdd ? mover : 0, mover * i);
    }

    // Right side
    path.lineTo(width, height);
    for (int i = count + 1; i >= -1 + 1; i--) {
      path.lineTo(width - (i.isOdd ? mover : 0), mover * i);
    }

    // Closing the path
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}

extension EvenExtension on int {
  bool get isEven => this % 2 == 0;
  bool get isOdd => this % 2 != 0;
}

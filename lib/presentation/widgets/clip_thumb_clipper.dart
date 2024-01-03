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

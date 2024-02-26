import 'package:flutter/rendering.dart';

class Vector3 {
  final double x;
  final double y;
  final double z;

  Vector3(this.x, this.y, this.z);
}

Matrix4 scaleOnAxisToMatrix(double scale, Vector3 axis) {
  Matrix4 matrix = Matrix4.identity();
  matrix.setEntry(0, 0, axis.x * scale);
  matrix.setEntry(1, 1, axis.y * scale);
  matrix.setEntry(2, 2, axis.z * scale);
  matrix.setEntry(3, 3, 0);
  return matrix;
}

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

/// A class that provides a placeholder image with a background color and optional text.
///
/// This is useful for situations where the actual image is not yet loaded or unavailable.
class ImageReplacement {
  /// Creates an instance of [ImageReplacement].
  ///
  /// Required arguments:
  /// * [color]: The background color of the placeholder image.
  /// * [text]: The text to display on the image (optional). Only the first character will be used.
  /// * [size]: The size of the placeholder image.
  ///
  /// Optional argument:
  /// * [textStyle]: The style of the text displayed on the image.
  ImageReplacement({
    required this.color,
    required this.text,
    required this.size,
    this.textStyle,
  });

  /// The background color of the placeholder image.
  final ui.Color color;

  /// The text to display on the image (optional). Only the first character will be used.
  final String? text;

  /// The style of the text displayed on the image.
  final TextStyle? textStyle;

  /// The size of the placeholder image.
  final ui.Size size;

  /// Creates a PNG image representation of the placeholder.
  ///
  /// This method asynchronously generates a PNG image with the specified background color and optional text.
  ///
  /// Returns a `Future<Uint8List?>` that resolves to a list of bytes representing the PNG image,
  /// or null if there's an error during image creation.
  Future<Uint8List?> create() async {
    final paint = ui.Paint();
    final pictureRecorder = ui.PictureRecorder();
    final canvas = ui.Canvas(pictureRecorder);

    paint.color = color;
    paint.isAntiAlias = true;

    // Added background to canvas
    canvas.drawCircle(
      Offset(size.halfWidth, size.halfHeight),
      size.halfWidth,
      paint,
    );

    if (text != null) {
      final splitText = text!.split(' ');
      final initials = splitText.first.length == 2 ? splitText.first : text![0];
      final textPainter = TextPainter(
        text: TextSpan(
          text: initials,
          style: textStyle,
        ),
        textDirection: ui.TextDirection.ltr,
        maxLines: 1,
        textAlign: TextAlign.center,
      );
      textPainter.layout(
        minWidth: size.halfWidth,
        maxWidth: size.width,
      );

      final xCenter = (size.width - textPainter.width) / 2;
      final yCenter = (size.height - textPainter.height) / 2;
      final textOffset = Offset(xCenter, yCenter);

      // Added text to canvas
      textPainter.paint(canvas, textOffset);
    }

    final pic = pictureRecorder.endRecording();
    final ui.Image img = await pic.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData?.buffer.asUint8List();

    return buffer;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageReplacement &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          text == other.text &&
          size == other.size &&
          textStyle == other.textStyle;

  @override
  int get hashCode =>
      color.hashCode ^ text.hashCode ^ size.hashCode ^ textStyle.hashCode;
}

/// Extension methods for [ui.Size] class.
///
/// This extension adds properties for accessing half width and half height of the size object.
extension SieExtension on ui.Size {
  /// Returns half the height of the size object.
  double get halfHeight => height / 2;

  /// Returns half the width of the size object.
  double get halfWidth => width / 2;
}

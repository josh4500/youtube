import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class IconSpan extends InlineSpan {
  const IconSpan(
    this.data, {
    this.color,
    this.semanticsLabel,
    this.recognizer,
  });

  final IconData? data;

  final Color? color;

  /// An alternative semantics label for this [IconSpan].
  ///
  /// If present, the semantics of this span will contain this value instead
  /// of the actual text_widgets.
  ///
  /// This is useful for replacing abbreviations or shorthands with the full
  /// text_widgets value:
  ///
  /// ```dart
  /// const TextSpan(text_widgets: r'$$', semanticsLabel: 'Double dollars')
  /// ```
  final String? semanticsLabel;

  final GestureRecognizer? recognizer;

  String? get text =>
      data != null ? String.fromCharCode(data!.codePoint) : null;

  @override
  void build(
    ParagraphBuilder builder, {
    TextScaler textScaler = TextScaler.noScaling,
    List<PlaceholderDimensions>? dimensions,
  }) {
    assert(debugAssertIsValid());

    final TextStyle fontStyle = TextStyle(
      inherit: false,
      fontFamily: data?.fontFamily,
      package: data?.fontPackage,
      color: color,
      fontFamilyFallback: data?.fontFamilyFallback,
      height: 1.0,
      leadingDistribution: TextLeadingDistribution.even,
    );

    builder.pushStyle(fontStyle.getTextStyle(textScaler: textScaler));

    if (text != null) {
      try {
        builder.addText(text!);
      } on ArgumentError catch (exception, stack) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: exception,
            stack: stack,
            library: 'painting library',
            context: ErrorDescription('while building a TextSpan'),
            silent: true,
          ),
        );
        // Use a Unicode replacement character as a substitute for invalid text_widgets.
        builder.addText('\uFFFD');
      }
    }

    builder.pop();
  }

  @override
  int? codeUnitAtVisitor(int index, Accumulator offset) {
    final String? text = this.text;
    if (text == null) {
      return null;
    }
    final int localOffset = index - offset.value;
    assert(localOffset >= 0);
    offset.increment(text.length);
    return localOffset < text.length ? text.codeUnitAt(localOffset) : null;
  }

  @override
  RenderComparison compareTo(InlineSpan other) {
    if (identical(this, other)) {
      return RenderComparison.identical;
    }
    if (other.runtimeType != runtimeType) {
      return RenderComparison.layout;
    }
    final TextSpan textSpan = other as TextSpan;
    if (textSpan.text != text || (style == null) != (textSpan.style == null)) {
      return RenderComparison.layout;
    }
    RenderComparison result = recognizer == textSpan.recognizer
        ? RenderComparison.identical
        : RenderComparison.metadata;
    if (style != null) {
      final RenderComparison candidate = style!.compareTo(textSpan.style!);
      if (candidate.index > result.index) {
        result = candidate;
      }
      if (result == RenderComparison.layout) {
        return result;
      }
    }
    return result;
  }

  @override
  void computeSemanticsInformation(
    List<InlineSpanSemanticsInformation> collector,
  ) {
    assert(debugAssertIsValid());

    if (text != null) {
      collector.add(
        InlineSpanSemanticsInformation(
          text!,
          semanticsLabel: semanticsLabel,
          recognizer: recognizer,
        ),
      );
    }
  }

  @override
  void computeToPlainText(
    StringBuffer buffer, {
    bool includeSemanticsLabels = true,
    bool includePlaceholders = true,
  }) {
    assert(debugAssertIsValid());
    if (semanticsLabel != null && includeSemanticsLabels) {
      buffer.write(semanticsLabel);
    } else if (text != null) {
      buffer.write(text);
    }
  }

  @override
  InlineSpan? getSpanForPositionVisitor(
    TextPosition position,
    Accumulator offset,
  ) {
    final String? text = this.text;
    if (text == null || text.isEmpty) {
      return null;
    }
    final TextAffinity affinity = position.affinity;
    final int targetOffset = position.offset;
    final int endOffset = offset.value + text.length;

    if (offset.value == targetOffset && affinity == TextAffinity.downstream ||
        offset.value < targetOffset && targetOffset < endOffset ||
        endOffset == targetOffset && affinity == TextAffinity.upstream) {
      return this;
    }
    offset.increment(text.length);
    return null;
  }

  @override
  bool visitChildren(InlineSpanVisitor visitor) {
    if (text != null && !visitor(this)) {
      return false;
    }
    return true;
  }

  @override
  bool visitDirectChildren(InlineSpanVisitor visitor) => true;
}

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'custom_rich_text.dart';

typedef FormatterAction = void Function(String text);

class CustomText extends StatelessWidget {
  const CustomText(
    String this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.formatters = const <TextFormatter>[],
    this.formatterActions = const <TextFormatter, FormatterAction>{},
  }) : textSpan = null;

  const CustomText.rich(
    InlineSpan this.textSpan, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.formatters = const <TextFormatter>[],
    this.formatterActions = const <TextFormatter, FormatterAction>{},
  }) : data = null;

  /// The text_widgets to display.
  ///
  /// This will be null if a [textSpan] is provided instead.
  final String? data;

  /// The text_widgets to display as a [InlineSpan].
  ///
  /// This will be null if [data] is provided instead.
  final InlineSpan? textSpan;

  /// If non-null, the style to use for this text_widgets.
  ///
  /// If the style's "inherit" property is true, the style will be merged with
  /// the closest enclosing [DefaultTextStyle]. Otherwise, the style will
  /// replace the closest enclosing [DefaultTextStyle].
  final TextStyle? style;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// How the text_widgets should be aligned horizontally.
  final TextAlign? textAlign;

  /// The directionality of the text_widgets.
  ///
  /// This decides how [textAlign] values like [TextAlign.start] and
  /// [TextAlign.end] are interpreted.
  ///
  /// This is also used to disambiguate how to render bidirectional text_widgets. For
  /// example, if the [data] is an English phrase followed by a Hebrew phrase,
  /// in a [TextDirection.ltr] context the English phrase will be on the left
  /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
  /// context, the English phrase will be on the right and the Hebrew phrase on
  /// its left.
  ///
  /// Defaults to the ambient [Directionality], if any.
  final TextDirection? textDirection;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  final Locale? locale;

  /// Whether the text_widgets should break at soft line breaks.
  ///
  /// If false, the glyphs in the text_widgets will be positioned as if there was unlimited horizontal space.
  final bool? softWrap;

  /// How visual overflow should be handled.
  ///
  /// If this is null [TextStyle.overflow] will be used, otherwise the value
  /// from the nearest [DefaultTextStyle] ancestor will be used.
  final TextOverflow? overflow;

  /// {@macro flutter.painting.textPainter.textScaler}
  final TextScaler? textScaler;

  /// An optional maximum number of lines for the text_widgets to span, wrapping if necessary.
  /// If the text_widgets exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text_widgets will not wrap. Otherwise, text_widgets will be wrapped at the
  /// edge of the box.
  ///
  /// If this is null, but there is an ambient [DefaultTextStyle] that specifies
  /// an explicit number for its [DefaultTextStyle.maxLines], then the
  /// [DefaultTextStyle] value will take precedence. You can use a [RichText]
  /// widget directly to entirely override the [DefaultTextStyle].
  final int? maxLines;

  /// {@template flutter.widgets.Text.semanticsLabel}
  /// An alternative semantics label for this text_widgets.
  ///
  /// If present, the semantics of this widget will contain this value instead
  /// of the actual text_widgets. This will overwrite any of the semantics labels applied
  /// directly to the [TextSpan]s.
  ///
  /// This is useful for replacing abbreviations or shorthands with the full
  /// text_widgets value:
  ///
  /// ```dart
  /// const Text(r'$$', semanticsLabel: 'Double dollars')
  /// ```
  /// {@endtemplate}
  final String? semanticsLabel;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis? textWidthBasis;

  /// {@macro dart.ui.textHeightBehavior}
  final ui.TextHeightBehavior? textHeightBehavior;

  /// The color to use when painting the selection.
  ///
  /// This is ignored if [SelectionContainer.maybeOf] returns null
  /// in the [BuildContext] of the [Text] widget.
  ///
  /// If null, the ambient [DefaultSelectionStyle] is used (if any); failing
  /// that, the selection color defaults to [DefaultSelectionStyle.defaultColor]
  /// (semi-transparent grey).
  final Color? selectionColor;

  final List<TextFormatter> formatters;
  final Map<TextFormatter, FormatterAction> formatterActions;

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);

    TextStyle? effectiveTextStyle = style;
    if (style == null || style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(style);
    }
    if (MediaQuery.boldTextOf(context)) {
      effectiveTextStyle = effectiveTextStyle!
          .merge(const TextStyle(fontWeight: FontWeight.bold));
    }

    final SelectionRegistrar? registrar = SelectionContainer.maybeOf(context);

    final TextScaler textScaler = switch (this.textScaler) {
      null => MediaQuery.textScalerOf(context),
      TextScaler _ => this.textScaler!,
    };

    // TODO(josh4500): Build more text span based on formatter

    final TextSpan effectiveText = TextSpan(
      style: effectiveTextStyle,
      text: data,
      children: textSpan != null ? <InlineSpan>[textSpan!] : null,
    );

    Widget result = CustomRichText(
      textAlign: textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
      // RichText uses Directionality.of to obtain a default if this is null.
      textDirection: textDirection,
      // RichText uses Localizations.localeOf to obtain a default if this is null
      locale: locale,
      softWrap: softWrap ?? defaultTextStyle.softWrap,
      overflow:
          overflow ?? effectiveTextStyle?.overflow ?? defaultTextStyle.overflow,
      textScaler: textScaler,
      maxLines: maxLines ?? defaultTextStyle.maxLines,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis ?? defaultTextStyle.textWidthBasis,
      textHeightBehavior: textHeightBehavior ??
          defaultTextStyle.textHeightBehavior ??
          DefaultTextHeightBehavior.maybeOf(context),
      selectionRegistrar: registrar,
      selectionColor: selectionColor ??
          DefaultSelectionStyle.of(context).selectionColor ??
          DefaultSelectionStyle.defaultColor,
      text: effectiveText,
    );

    if (registrar != null) {
      final MouseCursor effectiveCursor =
          DefaultSelectionStyle.of(context).mouseCursor ??
              SystemMouseCursors.text;
      result = MouseRegion(
        cursor: effectiveCursor,
        child: result,
      );
    }

    if (semanticsLabel != null) {
      result = Semantics(
        textDirection: textDirection,
        label: semanticsLabel,
        child: ExcludeSemantics(
          child: result,
        ),
      );
    }

    return result;
  }
}

enum TextFormatter {
  url,
  timage,
  hashTag,
}

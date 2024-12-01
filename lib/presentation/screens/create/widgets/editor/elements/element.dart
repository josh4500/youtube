import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../notifications/editor_notification.dart';

class DurationRange {
  const DurationRange({required this.start, required this.end});

  final Duration start;
  final Duration end;
}

abstract class VideoElementData {
  VideoElementData({
    this.range = const DurationRange(start: Duration.zero, end: Duration.zero),
    this.alignment,
    int? id,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch;

  final int id;
  final DurationRange range;
  final FractionalOffset? alignment;
}

enum TextElementDecoration {
  normal,
  bordered,
  background,
  transparentBackground,
}

class TextElement extends VideoElementData {
  TextElement({
    super.range,
    super.id,
    super.alignment,
    required this.text,
    required this.textAlign,
    required this.style,
    required this.readOutLoad,
    this.decoration = TextElementDecoration.normal,
  }) : assert(text.trim().isNotEmpty, 'Text cannot be empty');

  final String text;
  final TextAlign textAlign;
  final TextStyle style;
  final bool readOutLoad;
  final TextElementDecoration decoration;

  TextElement copyWith({
    String? text,
    TextAlign? textAlign,
    TextStyle? style,
    bool? readOutLoad,
    DurationRange? range,
    FractionalOffset? alignment,
    TextElementDecoration? decoration,
  }) {
    return TextElement(
      id: id,
      range: range ?? this.range,
      alignment: alignment ?? this.alignment,
      text: text ?? this.text,
      textAlign: textAlign ?? this.textAlign,
      style: style ?? this.style,
      readOutLoad: readOutLoad ?? this.readOutLoad,
      decoration: decoration ?? this.decoration,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextElement &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          textAlign == other.textAlign &&
          style == other.style &&
          readOutLoad == other.readOutLoad &&
          decoration == other.decoration;

  @override
  int get hashCode =>
      text.hashCode ^
      textAlign.hashCode ^
      style.hashCode ^
      readOutLoad.hashCode ^
      decoration.hashCode;

  @override
  String toString() {
    return 'TextElement{text: $text}';
  }
}

class DragHitNotification extends EditorNotification {
  DragHitNotification({
    required this.hit,
    this.dragging = false,
    this.hitDelete = false,
  });

  final bool dragging;
  final bool hitDelete;
  final DragHit hit;
}

class DragHit {
  DragHit({
    this.hitLeft = false,
    this.hitRight = false,
    this.hitTop = false,
    this.hitBottom = false,
    this.hitXCenter = false,
    this.hitYCenter = false,
  });

  final bool hitLeft;
  final bool hitRight;
  final bool hitTop;
  final bool hitBottom;
  final bool hitXCenter;
  final bool hitYCenter;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DragHit &&
          runtimeType == other.runtimeType &&
          hitLeft == other.hitLeft &&
          hitRight == other.hitRight &&
          hitTop == other.hitTop &&
          hitBottom == other.hitBottom &&
          hitXCenter == other.hitXCenter &&
          hitYCenter == other.hitYCenter;

  @override
  int get hashCode =>
      hitLeft.hashCode ^
      hitRight.hashCode ^
      hitTop.hashCode ^
      hitBottom.hashCode ^
      hitXCenter.hashCode ^
      hitYCenter.hashCode;
}

class VideoElement extends StatefulWidget {
  const VideoElement({super.key});

  @override
  State<VideoElement> createState() => _VideoElementState();
}

class _VideoElementState extends State<VideoElement> {
  final GlobalKey itemKey = GlobalKey();
  final alignmentNotifier = ValueNotifier(FractionalOffset.center);
  Offset panStartOffset = Offset.zero;

  @override
  void didUpdateWidget(covariant VideoElement oldWidget) {
    super.didUpdateWidget(oldWidget);
    final data = context.provide<VideoElementData>();
    if (data.alignment != null) {
      alignmentNotifier.value = data.alignment!;
    }
  }

  @override
  void dispose() {
    alignmentNotifier.dispose();
    super.dispose();
  }

  void handlePanEnd(
    DragEndDetails details,
    BoxConstraints constraints,
  ) {
    final position = details.globalPosition;
    final maxWidth = constraints.maxWidth;
    final maxHeight = constraints.maxHeight;
    final hitDelete = maxHeight - position.dy <= 56 &&
        (position.dx - maxWidth / 2).abs() <= 56 / 2;
    DragHitNotification(
      hit: DragHit(),
      hitDelete: hitDelete,
    ).dispatch(context);

    if (!hitDelete) {
      final data = context.provide<VideoElementData>();
      final VideoElementData updatedElement;
      // TODO(josh4500): Check for type
      updatedElement = (data as TextElement).copyWith(
        alignment: alignmentNotifier.value,
      );

      UpdateElementNotification(element: updatedElement).dispatch(context);
    }
  }

  void handlePanStart(
    DragStartDetails details,
    BoxConstraints constraints,
  ) {
    panStartOffset = details.localPosition;
    final data = context.provide<VideoElementData>();
    UpdateElementNotification(
      element: data,
      swapToLast: true,
    ).dispatch(context);
  }

  void handlePanUpdate(
    DragUpdateDetails details,
    BoxConstraints constraints,
  ) {
    final position = details.globalPosition;
    final maxWidth = constraints.maxWidth;
    final maxHeight = constraints.maxHeight;

    alignmentNotifier.value = FractionalOffset(
      position.dx / maxWidth,
      position.dy / maxHeight,
    );

    DragHitNotification(
      hit: DragHit(
        hitTop: position.dy.abs() <= 24,
        hitLeft: position.dx.abs() <= 24,
        hitRight: position.dx.abs() >= maxWidth - 24,
        hitBottom: position.dy >= maxHeight - 24,
        hitXCenter: (position.dx - maxWidth / 2).abs() <= 6,
        hitYCenter: (position.dy - maxHeight / 2).abs() <= 6,
      ),
      dragging: true,
      hitDelete: maxHeight - position.dy <= 56 &&
          (position.dx - maxWidth / 2).abs() <= 56 / 2,
    ).dispatch(context);
  }

  @override
  Widget build(BuildContext context) {
    final data = context.provide<VideoElementData>();
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        return ValueListenableBuilder(
          valueListenable: alignmentNotifier,
          builder: (
            BuildContext context,
            Alignment alignment,
            Widget? childWidget,
          ) {
            return Align(
              alignment: alignment,
              child: childWidget,
            );
          },
          child: GestureDetector(
            onPanStart: (details) => handlePanStart(details, constraints),
            onPanEnd: (details) => handlePanEnd(details, constraints),
            onPanUpdate: (details) => handlePanUpdate(details, constraints),
            child: _VideoElementItem(
              key: itemKey,
              child: switch (data) {
                TextElement _ => const _TextElementWidget(),
                _ => const Placeholder(),
              },
            ),
          ),
        );
      },
    );
  }
}

class _VideoElementItem extends StatelessWidget {
  const _VideoElementItem({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

class _TextElementWidget extends StatefulWidget {
  const _TextElementWidget();

  @override
  State<_TextElementWidget> createState() => _TextElementWidgetState();
}

class _TextElementWidgetState extends State<_TextElementWidget> {
  final call = CallOutLink();
  @override
  Widget build(BuildContext context) {
    final data = context.provide<VideoElementData>() as TextElement;

    return GestureDetector(
      onTap: call.controller.show,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CallOut(
          link: call,
          padding: EdgeInsets.zero,
          buildContent: (BuildContext context) {
            return SizedBox(
              width: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Edit',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const Divider(height: 0, color: Colors.black),
                  InkWell(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Timing',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const Divider(height: 0, color: Colors.black),
                  InkWell(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Add Voice',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          child: Text(
            data.text,
            style: data.style,
            textAlign: data.textAlign,
          ),
        ),
      ),
    );
  }
}

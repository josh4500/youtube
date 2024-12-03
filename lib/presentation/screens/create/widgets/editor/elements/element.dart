import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../notifications/editor_notification.dart';
import 'sticker_scaffold.dart';

class DurationRange {
  const DurationRange({required this.start, required this.end});

  final Duration start;
  final Duration end;
}

abstract class VideoElementData {
  VideoElementData({
    this.range = const DurationRange(start: Duration.zero, end: Duration.zero),
    this.alignment = FractionalOffset.center,
    int? id,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch;

  final int id;
  final DurationRange range;
  final FractionalOffset alignment;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoElementData &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
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
      super == other &&
          other is TextElement &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => super.hashCode ^ id.hashCode;
}

class StickerElement extends VideoElementData {
  StickerElement({
    super.range,
    super.alignment,
    super.id,
    required this.color,
  });

  final Color color;
}

class QaStickerElement extends StickerElement {
  QaStickerElement({
    super.range,
    super.alignment,
    super.id,
    required this.text,
    required super.color,
  });

  final String text;

  QaStickerElement copyWith({
    String? text,
    Color? color,
    FractionalOffset? alignment,
  }) {
    return QaStickerElement(
      id: id,
      text: text ?? this.text,
      color: color ?? this.color,
      alignment: alignment ?? this.alignment,
    );
  }
}

class AddYStickerElement extends StickerElement {
  AddYStickerElement({
    super.range,
    super.alignment,
    super.id,
    required this.prompt,
    required super.color,
  });

  final String prompt;

  AddYStickerElement copyWith({
    String? prompt,
    Color? color,
    FractionalOffset? alignment,
  }) {
    return AddYStickerElement(
      id: id,
      prompt: prompt ?? this.prompt,
      color: color ?? this.color,
      alignment: alignment ?? this.alignment,
    );
  }
}

class PollStickerElement extends StickerElement {
  PollStickerElement({
    super.range,
    super.alignment,
    super.id,
    required this.options,
    required this.question,
    required super.color,
  });

  final String question;
  final List<String> options;

  PollStickerElement copyWith({
    Color? color,
    List<String>? options,
    FractionalOffset? alignment,
    String? question,
  }) {
    return PollStickerElement(
      id: id,
      options: options ?? this.options,
      question: question ?? this.question,
      color: color ?? this.color,
      alignment: alignment ?? this.alignment,
    );
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final element = context.provide<VideoElementData>();
    alignmentNotifier.value = element.alignment;
  }

  @override
  void didUpdateWidget(covariant VideoElement oldWidget) {
    super.didUpdateWidget(oldWidget);
    final element = context.provide<VideoElementData>();
    alignmentNotifier.value = element.alignment;
  }

  @override
  void dispose() {
    alignmentNotifier.dispose();
    super.dispose();
  }

  void handlePanEnd(
    DragEndDetails details,
    BoxConstraints constraints,
    VideoElementData element,
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
      final VideoElementData updatedElement;
      if (element is TextElement) {
        updatedElement = element.copyWith(
          alignment: alignmentNotifier.value,
        );
      } else if (element is QaStickerElement) {
        updatedElement = element.copyWith(
          alignment: alignmentNotifier.value,
        );
      } else if (element is AddYStickerElement) {
        updatedElement = element.copyWith(
          alignment: alignmentNotifier.value,
        );
      } else {
        updatedElement = (element as PollStickerElement).copyWith(
          alignment: alignmentNotifier.value,
        );
      }

      UpdateElementNotification(element: updatedElement).dispatch(context);
    } else {
      DeleteElementNotification(elementId: element.id).dispatch(context);
    }
  }

  void handlePanStart(
    DragStartDetails details,
    BoxConstraints constraints,
    VideoElementData element,
  ) {
    panStartOffset = details.localPosition;
    UpdateElementNotification(
      element: element,
      swapToLast: true,
    ).dispatch(context);
  }

  void handlePanUpdate(
    DragUpdateDetails details,
    BoxConstraints constraints,
  ) {
    final lPosition = details.localPosition;
    final gPosition = details.globalPosition;
    final maxWidth = constraints.maxWidth;
    final maxHeight = constraints.maxHeight;

    final offset = alignmentNotifier.value;
    alignmentNotifier.value = FractionalOffset(
      offset.dx + details.delta.dx / maxWidth,
      offset.dy + details.delta.dy / maxHeight,
    );
    // hitTop: gPosition.dy.abs() <= 24,
    // hitLeft: gPosition.dx.abs() <= 24,
    // hitRight: gPosition.dx.abs() >= maxWidth - 24,
    // hitBottom: gPosition.dy >= maxHeight - 24,
    // hitXCenter: (gPosition.dx - maxWidth / 2).abs() <= 6,
    // hitYCenter: (gPosition.dy - maxHeight / 2).abs() <= 6,
    DragHitNotification(
      hit: DragHit(
        hitTop: gPosition.dy - panStartOffset.dy <= 56,
        hitLeft: gPosition.dx - panStartOffset.dx <= 24,
        hitRight: maxWidth + 24 - gPosition.dx - lPosition.dx <= 24,
        hitBottom: maxHeight - gPosition.dy - panStartOffset.dy <= 56,
        hitXCenter: (gPosition.dx - maxWidth / 2).abs() <= 6,
        hitYCenter: (gPosition.dy - maxHeight / 2).abs() <= 6,
      ),
      dragging: true,
      hitDelete: maxHeight - gPosition.dy <= 56 &&
          (gPosition.dx - maxWidth / 2).abs() <= 56 / 2,
    ).dispatch(context);
  }

  void handleOnTap(StickerElement element) {
    OpenStickerEditorNotification(type: element.runtimeType).dispatch(context);
  }

  @override
  Widget build(BuildContext context) {
    final element = context.provide<VideoElementData>();
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
            onTap: element is StickerElement
                ? () => handleOnTap(
                      element,
                    )
                : null,
            onPanEnd: (details) => handlePanEnd(
              details,
              constraints,
              element,
            ),
            onPanStart: (details) => handlePanStart(
              details,
              constraints,
              element,
            ),
            onPanUpdate: (details) => handlePanUpdate(details, constraints),
            child: _VideoElementItem(
              key: itemKey,
              child: switch (element) {
                TextElement _ => const _TextElementWidget(),
                QaStickerElement _ => const StickerScaffold(
                    type: QaStickerElement,
                    child: _QaElementWidget(),
                  ),
                AddYStickerElement _ => const StickerScaffold(
                    type: AddYStickerElement,
                    child: _AddYElementWidget(),
                  ),
                PollStickerElement _ => const StickerScaffold(
                    type: PollStickerElement,
                    child: _PollElementWidget(),
                  ),
                _ => const SizedBox(),
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

class StickerContentPlaceholder extends StatelessWidget {
  const StickerContentPlaceholder({super.key, required this.type});

  final Type type;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          type == PollStickerElement ? Alignment.centerLeft : Alignment.center,
      child: Text(
        {
          QaStickerElement: 'Ask a question',
          AddYStickerElement: 'Add a prompt',
          PollStickerElement: 'Ask a question',
        }[type]!,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _QaElementWidget extends StatelessWidget {
  const _QaElementWidget();

  @override
  Widget build(BuildContext context) {
    final element = context.provide<VideoElementData>() as QaStickerElement;
    if (element.text.isEmpty) {
      return const StickerContentPlaceholder(type: QaStickerElement);
    }
    return Text(
      element.text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _AddYElementWidget extends StatelessWidget {
  const _AddYElementWidget();

  @override
  Widget build(BuildContext context) {
    final element = context.provide<VideoElementData>() as AddYStickerElement;
    if (element.prompt.isEmpty) {
      return const StickerContentPlaceholder(type: QaStickerElement);
    }
    return Text(
      element.prompt,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _PollElementWidget extends StatelessWidget {
  const _PollElementWidget();

  @override
  Widget build(BuildContext context) {
    final element = context.provide<VideoElementData>() as PollStickerElement;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (element.question.isNotEmpty) ...[
          Text(
            element.question,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
        ],
        ...List.generate(
          element.options.length,
          (int index) => Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              element.options[index],
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '0 vote',
          style: TextStyle(fontSize: 10, color: Colors.black),
        ),
      ],
    );
  }
}

class _TextElementWidget extends StatefulWidget {
  const _TextElementWidget();

  @override
  State<_TextElementWidget> createState() => _TextElementWidgetState();
}

class _TextElementWidgetState extends State<_TextElementWidget> {
  final CallOutLink callOutLink = CallOutLink();

  @override
  Widget build(BuildContext context) {
    final element = context.provide<VideoElementData>() as TextElement;

    return GestureDetector(
      onTap: callOutLink.show,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CallOut(
          link: callOutLink,
          padding: EdgeInsets.zero,
          buildContent: (BuildContext context) {
            return SizedBox(
              width: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      callOutLink.hide();
                      OpenTextEditorNotification(
                        element: element,
                      ).dispatch(context);
                    },
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
                    onTap: () {
                      callOutLink.hide();
                      OpenTimelineNotification().dispatch(context);
                    },
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
                    onTap: () {
                      callOutLink.hide();
                      OpenTextEditorNotification(
                        element: element.copyWith(readOutLoad: true),
                      ).dispatch(context);
                    },
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
            element.text,
            style: element.style,
            textAlign: element.textAlign,
          ),
        ),
      ),
    );
  }
}

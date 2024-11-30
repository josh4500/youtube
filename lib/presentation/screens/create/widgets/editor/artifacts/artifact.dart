import 'package:flutter/material.dart';
import 'package:youtube_clone/core/utils/normalization.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../notifications/editor_notification.dart';

class DurationRange {
  DurationRange({required this.start, required this.end});

  final Duration start;
  final Duration end;
}

abstract class ArtifactData {
  ArtifactData({required this.range, this.alignment});

  final DurationRange range;
  final Alignment? alignment;
}

enum TextArtifactDecoration {
  normal,
  bordered,
  background,
  transparentBackground,
}

class TextArtifact extends ArtifactData {
  TextArtifact({
    required super.range,
    super.alignment,
    required this.text,
    required this.textAlign,
    required this.style,
    required this.readOutLoad,
    this.decoration = TextArtifactDecoration.normal,
  }) : assert(text.trim().isNotEmpty, 'Text cannot be empty');

  final String text;
  final TextAlign textAlign;
  final TextStyle style;
  final bool readOutLoad;
  final TextArtifactDecoration decoration;

  TextArtifact copyWith({
    String? text,
    TextAlign? textAlign,
    TextStyle? style,
    bool? readOutLoad,
    DurationRange? range,
    Alignment? alignment,
    TextArtifactDecoration? decoration,
  }) {
    return TextArtifact(
      range: range ?? this.range,
      alignment: alignment ?? this.alignment,
      text: text ?? this.text,
      textAlign: textAlign ?? this.textAlign,
      style: style ?? this.style,
      readOutLoad: readOutLoad ?? this.readOutLoad,
      decoration: decoration ?? this.decoration,
    );
  }
}

class DragHitNotification extends EditorNotification {
  DragHitNotification({required this.hit});

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

class Artifact extends StatefulWidget {
  const Artifact({super.key});

  @override
  State<Artifact> createState() => _ArtifactState();
}

class _ArtifactState extends State<Artifact> {
  final GlobalKey itemKey = GlobalKey();
  final alignmentNotifier = ValueNotifier(Alignment.center);

  Size get itemSize {
    return itemKey.currentContext!.size!;
  }

  Offset panStartOffset = Offset.zero;

  Offset get itemOffset {
    return (itemKey.currentContext!.findRenderObject()! as RenderBox)
        .globalToLocal(Offset.zero);
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
    DragHitNotification(hit: DragHit()).dispatch(context);
  }

  void handlePanStart(
    DragStartDetails details,
    BoxConstraints constraints,
  ) {
    panStartOffset = details.localPosition;
  }

  void handlePanUpdate(
    DragUpdateDetails details,
    BoxConstraints constraints,
  ) {
    final position = details.globalPosition;
    final maxWidth = constraints.maxWidth;
    final maxHeight = constraints.maxHeight;

    alignmentNotifier.value = Alignment(
      (position.dx / maxWidth).clamp(0, 1).normalizeRange(-1, 1),
      (position.dy / maxHeight).clamp(0, 1).normalizeRange(-1, 1),
    );

    final offset = itemOffset;

    final bool hitTop = position.dy.abs() <= 24;
    final bool hitLeft = offset.dx.abs() <= 24;
    final bool hitRight = offset.dx.abs() + itemSize.width >= maxWidth - 24;
    final bool hitBottom = position.dy + itemSize.height >= maxHeight - 24;
    final bool hitXCenter = (position.dx - maxWidth / 2).abs() <= 6;
    final bool hitYCenter = (position.dy - maxHeight / 2).abs() <= 6;

    DragHitNotification(
      hit: DragHit(
        hitTop: hitTop,
        hitLeft: hitLeft,
        hitRight: hitRight,
        hitBottom: hitBottom,
        hitXCenter: hitXCenter,
        hitYCenter: hitYCenter,
      ),
    ).dispatch(context);
  }

  @override
  Widget build(BuildContext context) {
    final data = context.provide<ArtifactData>();
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        return GestureDetector(
          onPanStart: (details) => handlePanStart(details, constraints),
          onPanEnd: (details) => handlePanEnd(details, constraints),
          onPanUpdate: (details) => handlePanUpdate(details, constraints),
          child: ValueListenableBuilder(
            valueListenable: alignmentNotifier,
            builder: (
              BuildContext context,
              Alignment alignment,
              Widget? childWidget,
            ) {
              return Align(
                alignment: data.alignment ?? alignment,
                child: childWidget,
              );
            },
            child: _ArtifactItem(
              key: itemKey,
              child: switch (data) {
                TextArtifact _ => const _TextArtifactWidget(),
                _ => const Placeholder(),
              },
            ),
          ),
        );
      },
    );
  }
}

class _ArtifactItem extends StatelessWidget {
  const _ArtifactItem({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

class _TextArtifactWidget extends StatefulWidget {
  const _TextArtifactWidget();

  @override
  State<_TextArtifactWidget> createState() => _TextArtifactWidgetState();
}

class _TextArtifactWidgetState extends State<_TextArtifactWidget> {
  final call = CallOutLink(
    offset: const Offset(0, 70),
  );
  @override
  Widget build(BuildContext context) {
    final data = context.provide<ArtifactData>() as TextArtifact;

    return GestureDetector(
      onTap: call.controller.show,
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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

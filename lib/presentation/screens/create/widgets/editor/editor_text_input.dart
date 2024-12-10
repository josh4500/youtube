import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../notifications/editor_notification.dart';
import 'element.dart';

class EditorTextInput extends StatefulWidget {
  const EditorTextInput({super.key});

  @override
  State<EditorTextInput> createState() => _EditorTextInputState();
}

class _EditorTextInputState extends State<EditorTextInput> {
  final FocusNode focusNode = FocusNode();
  final _controller = TextEditingController();
  final ValueNotifier<TextStyle> _styleNotifier = ValueNotifier(
    const TextStyle(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.w700,
    ),
  );
  final ValueNotifier<TextAlign> _textAlignNotifier = ValueNotifier(
    TextAlign.center,
  );
  final ValueNotifier<TextElementDecoration> _textDecorationNotifier =
      ValueNotifier(
    TextElementDecoration.normal,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final element = context.provide<TextElement?>();
    if (element != null) {
      _controller.text = element.text;
      _styleNotifier.value = element.style;
      _textAlignNotifier.value = element.textAlign;
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    _styleNotifier.dispose();
    _textAlignNotifier.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final element = context.provide<TextElement?>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                YTIcons.audio_track_outlined,
                color: Colors.white24,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text(
                  'YouTube Sans',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  focusNode.unfocus();
                  if (_controller.text.isNotEmpty) {
                    if (element == null) {
                      CreateElementNotification(
                        element: TextElement(
                          text: _controller.text.trim(),
                          textAlign: _textAlignNotifier.value,
                          style: _styleNotifier.value,
                          decoration: _textDecorationNotifier.value,
                          readOutLoad: false,
                        ),
                      ).dispatch(context);
                    } else {
                      UpdateElementNotification(
                        element: element.copyWith(
                          text: _controller.text.trim(),
                          textAlign: _textAlignNotifier.value,
                          style: _styleNotifier.value,
                          readOutLoad: false,
                        ),
                      ).dispatch(context);
                      CloseElementEditorNotification().dispatch(context);
                    }

                    _controller.clear();
                  } else {
                    if (element != null) {
                      DeleteElementNotification(
                        elementId: element.id,
                      ).dispatch(context);
                    }
                    CloseElementEditorNotification().dispatch(context);
                  }
                },
                child: const Text(
                  'DONE',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: SliderTheme(
                  data: const SliderThemeData(
                    activeTrackColor: Colors.white24,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: Colors.white,
                    trackHeight: 1,
                    overlayColor: Colors.white10,
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: _styleNotifier,
                    builder: (
                      BuildContext context,
                      TextStyle style,
                      Widget? _,
                    ) {
                      return Slider(
                        value: style.fontSize ?? 14,
                        min: 12,
                        max: 100,
                        onChanged: (double value) {
                          _styleNotifier.value = style.copyWith(
                            fontSize: value,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: focusNode.requestFocus,
                  child: Container(
                    height: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(right: 24.0),
                    child: ListenableBuilder(
                      listenable: Listenable.merge([
                        _styleNotifier,
                        _textAlignNotifier,
                      ]),
                      builder: (
                        BuildContext context,
                        Widget? _,
                      ) {
                        final style = _styleNotifier.value;
                        final textAlign = _textAlignNotifier.value;
                        return TextField(
                          style: style,
                          focusNode: focusNode,
                          controller: _controller,
                          textAlign: textAlign,
                          cursorColor: style.color ?? Colors.white,
                          maxLines: null,
                          decoration: const InputDecoration.collapsed(
                            hintText: '',
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  final index = _textAlignNotifier.value.index;
                  if (index == TextAlign.values.length - 1) {
                    _textAlignNotifier.value = TextAlign.values.first;
                  } else {
                    final nextTextAlign = TextAlign.values[index + 1];
                    if (nextTextAlign == TextAlign.start ||
                        nextTextAlign == TextAlign.end) {
                      _textAlignNotifier.value = TextAlign.values.first;
                    } else {
                      _textAlignNotifier.value = nextTextAlign;
                    }
                  }
                },
                child: ValueListenableBuilder(
                  valueListenable: _textAlignNotifier,
                  builder: (
                    BuildContext context,
                    TextAlign textAlign,
                    Widget? _,
                  ) {
                    return Icon(
                      switch (textAlign) {
                        TextAlign.left => Icons.format_align_left,
                        TextAlign.right => Icons.format_align_right,
                        TextAlign.center => Icons.format_align_center,
                        TextAlign.justify => Icons.format_align_justify,
                        TextAlign.start => Icons.format_align_left,
                        TextAlign.end => Icons.format_align_right,
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  final index = _textDecorationNotifier.value.index;
                  if (index == TextElementDecoration.values.length - 1) {
                    _textDecorationNotifier.value =
                        TextElementDecoration.values.first;
                  } else {
                    final nextDecoration =
                        TextElementDecoration.values[index + 1];
                    _textDecorationNotifier.value = nextDecoration;
                  }
                },
                child: ValueListenableBuilder(
                  valueListenable: _textDecorationNotifier,
                  builder: (
                    BuildContext context,
                    TextElementDecoration decoration,
                    Widget? _,
                  ) {
                    return switch (decoration) {
                      TextElementDecoration.normal =>
                        ImageFromAsset.textNormalIcon,
                      TextElementDecoration.bordered =>
                        ImageFromAsset.textBorderedIcon,
                      TextElementDecoration.background =>
                        ImageFromAsset.textBackgroundIcon,
                      TextElementDecoration.transparentBackground =>
                        ImageFromAsset.textTransparentIcon,
                    };
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 1,
                height: 32,
                color: Colors.white10,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 34,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      final color = [
                        Colors.white,
                        Colors.transparent,
                        Colors.red,
                        Colors.blue,
                        Colors.yellow,
                        Colors.green,
                        Colors.deepPurple,
                        Colors.purple,
                        Colors.purpleAccent,
                        Colors.amber,
                        Colors.amberAccent,
                      ][index];
                      return GestureDetector(
                        onTap: () {
                          _styleNotifier.value = _styleNotifier.value.copyWith(
                            color: color,
                          );
                        },
                        child: ListenableBuilder(
                          listenable: _styleNotifier,
                          builder: (BuildContext context, Widget? childWidget) {
                            return AnimatedScale(
                              scale: _styleNotifier.value.color == color
                                  ? 1.13
                                  : .9,
                              duration: Durations.short2,
                              child: childWidget,
                            );
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

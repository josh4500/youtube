import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../notifications/editor_notification.dart';

class EditorTextInput extends StatefulWidget {
  const EditorTextInput({super.key});

  @override
  State<EditorTextInput> createState() => _EditorTextInputState();
}

class _EditorTextInputState extends State<EditorTextInput> {
  final FocusNode focusNode = FocusNode();
  final textController = TextEditingController(text: 'Test');
  final ValueNotifier<TextStyle> styleNotifier = ValueNotifier(
    const TextStyle(),
  );
  final ValueNotifier<TextAlign> textAlignNotifier = ValueNotifier(
    TextAlign.center,
  );

  @override
  void dispose() {
    focusNode.dispose();
    styleNotifier.dispose();
    textAlignNotifier.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  CreateTextArtifactNotification().dispatch(context);
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
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white,
                    thumbColor: Colors.white,
                    trackHeight: 1,
                    overlayColor: Colors.white10,
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: styleNotifier,
                    builder: (
                      BuildContext context,
                      TextStyle style,
                      Widget? _,
                    ) {
                      return Slider(
                        value: style.fontSize ?? 14,
                        min: 14,
                        max: 100,
                        onChanged: (double value) {
                          styleNotifier.value = style.copyWith(fontSize: value);
                        },
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: ListenableBuilder(
                    listenable: Listenable.merge([
                      styleNotifier,
                      textAlignNotifier,
                    ]),
                    builder: (
                      BuildContext context,
                      Widget? _,
                    ) {
                      final style = styleNotifier.value;
                      final textAlign = textAlignNotifier.value;
                      return TextField(
                        style: style,
                        focusNode: focusNode,
                        controller: textController,
                        textAlign: textAlign,
                        cursorColor: Colors.white,
                        maxLines: null,
                        decoration: const InputDecoration.collapsed(
                          hintText: '',
                        ),
                      );
                    },
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
                  final index = textAlignNotifier.value.index;
                  if (index == TextAlign.values.length - 1) {
                    textAlignNotifier.value = TextAlign.values.first;
                  } else {
                    final nextTextAlign = TextAlign.values[index + 1];
                    if (nextTextAlign == TextAlign.start ||
                        nextTextAlign == TextAlign.end) {
                      textAlignNotifier.value = TextAlign.values.first;
                    } else {
                      textAlignNotifier.value = TextAlign.values[index + 1];
                    }
                  }
                },
                child: ValueListenableBuilder(
                  valueListenable: textAlignNotifier,
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
              const Icon(Icons.sort_by_alpha),
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
                        Colors.red,
                        Colors.blue,
                        Colors.yellow,
                        Colors.green,
                        Colors.deepPurple,
                        Colors.purple,
                        Colors.purpleAccent,
                        Colors.amber,
                        Colors.amberAccent,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                      ][index];
                      return GestureDetector(
                        onTap: () {
                          styleNotifier.value =
                              styleNotifier.value.copyWith(color: color);
                        },
                        child: Container(
                          height: 28,
                          width: 28,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white),
                          ),
                        ),
                      );
                    },
                    itemCount: 20,
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

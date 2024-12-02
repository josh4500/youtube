import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_clone/presentation/models.dart';

import '../notifications/editor_notification.dart';
import 'elements/element.dart';
import 'elements/sticker_scaffold.dart';

class EditorStickerInput extends StatefulWidget {
  const EditorStickerInput({super.key});

  @override
  State<EditorStickerInput> createState() => _EditorStickerInputState();
}

class _EditorStickerInputState extends State<EditorStickerInput> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<Color> colorNotifier = ValueNotifier<Color>(Colors.white);
  static const int minLines = 1;
  static const int maxLines = 3;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    colorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stickerData = context.provide<(Type, StickerElement?)?>()!;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () {
                  _focusNode.unfocus();
                  final StickerElement element;
                  if (stickerData.$1 == QaStickerElement) {
                    element = QaStickerElement(
                      text: _controller.text.trim(),
                      color: colorNotifier.value,
                    );
                  } else if (stickerData.$1 == AddYStickerElement) {
                    element = AddYStickerElement(
                      prompt: _controller.text.trim(),
                      color: colorNotifier.value,
                    );
                  } else {
                    element = PollStickerElement(
                      question: _controller.text.trim(),
                      options: ['Yes', 'No'],
                      color: colorNotifier.value,
                    );
                  }
                  if (_controller.text.isNotEmpty) {
                    CreateElementNotification(
                      element: element,
                    ).dispatch(context);
                  } else {
                    CloseElementEditortNotification().dispatch(context);
                  }
                },
                child: const Text(
                  'DONE',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              StickerScaffold(
                type: stickerData.$1,
                child: Column(
                  children: [
                    ListenableBuilder(
                      listenable: _controller,
                      builder: (
                        BuildContext context,
                        Widget? _,
                      ) {
                        return Stack(
                          children: [
                            if (_controller.text.isEmpty)
                              Align(
                                alignment: stickerData.$1 == PollStickerElement
                                    ? Alignment.centerLeft
                                    : Alignment.center,
                                child: Text(
                                  {
                                    QaStickerElement: 'Ask a question',
                                    AddYStickerElement: 'Add a prompt',
                                    PollStickerElement: 'Ask a question',
                                  }[stickerData.$1]!,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            Visibility(
                              visible: _controller.text.isNotEmpty,
                              maintainState: true,
                              maintainAnimation: true,
                              maintainSize: true,
                              maintainInteractivity: true,
                              child: TextField(
                                cursorWidth: 2.25,
                                minLines: minLines,
                                maxLines: maxLines,
                                focusNode: _focusNode,
                                controller: _controller,
                                textAlign: stickerData.$1 == PollStickerElement
                                    ? TextAlign.start
                                    : TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                inputFormatters: const [
                                  MaxLinesTextInputFormatter(
                                    maxLines: maxLines,
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxWidth: 250 - 24,
                                  ),
                                ],
                                decoration: const InputDecoration.collapsed(
                                  hintText: 'Ask a question',
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black26,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    if (stickerData.$1 == PollStickerElement)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 12),
                          ...List.generate(
                            2,
                            (int index) => Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                decoration: InputDecoration.collapsed(
                                  hintText: ['Yes', 'No'][index],
                                  hintStyle: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black38,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              ...[
                const SizedBox(height: 12),
                Text(
                  {
                    QaStickerElement: 'Answers will appear as comments',
                    AddYStickerElement:
                        'Viewers can respond with their own Short',
                    PollStickerElement: 'Viewers can vote on a poll option',
                  }[stickerData.$1]!,
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ],
          ),
          const SizedBox(),
        ],
      ),
    );
  }
}

class MaxLinesTextInputFormatter extends TextInputFormatter {
  const MaxLinesTextInputFormatter({
    required this.maxLines,
    required this.textStyle,
    required this.maxWidth,
  });
  final int maxLines;
  final TextStyle textStyle;
  final double maxWidth;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final textSpan = TextSpan(text: newValue.text, style: textStyle);

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    final lineMetrics = textPainter.computeLineMetrics();
    final numLines = lineMetrics.length;

    final reachLimit =
        numLines >= maxLines && lineMetrics.last.width >= maxWidth - 18;

    if (reachLimit) {
      return oldValue;
    }

    // Accept the new value if within the limit
    return newValue;
  }
}

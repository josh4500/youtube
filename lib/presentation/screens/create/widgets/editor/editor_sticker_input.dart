import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../notifications/editor_notification.dart';
import 'element.dart';

const List<String> kDefaultOptions = ['Yes', 'No'];

class EditorStickerInput extends StatefulWidget {
  const EditorStickerInput({super.key});

  @override
  State<EditorStickerInput> createState() => _EditorStickerInputState();
}

class _EditorStickerInputState extends State<EditorStickerInput> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final ValueNotifier<Color> _colorNotifier =
      ValueNotifier<Color>(Colors.white);
  static const int minLines = 1;
  static const int maxLines = 3;
  List<TextEditingController> get optionControllers => [
        _option1Controller,
        _option2Controller,
      ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final editingStickerElement = context.provide<(Type, StickerElement?)?>();
    if (editingStickerElement == null) {
      return;
    }
    final (type, element) = editingStickerElement;
    if (element is QaStickerElement && type == QaStickerElement) {
      _controller.text = element.text;
    } else if (element is AddYStickerElement && type == AddYStickerElement) {
      _controller.text = element.prompt;
    } else if (element is PollStickerElement && type == PollStickerElement) {
      _controller.text = element.question;
      if (!listEquals(kDefaultOptions, element.options)) {
        _option1Controller.text = element.options.first;
        _option2Controller.text = element.options.last;
      }
    }
    if (element != null) {
      _colorNotifier.value = element.color;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _option1Controller.dispose();
    _option2Controller.dispose();
    _focusNode.dispose();
    _colorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editingStickerElement = context.provide<(Type, StickerElement?)?>();
    if (editingStickerElement == null) {
      return const SizedBox();
    }
    final (type, stickerElement) = editingStickerElement;
    final alignment = stickerElement?.alignment ?? FractionalOffset.center;
    return ColoredBox(
      color: Colors.black54,
      child: Padding(
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
                    if (type == QaStickerElement) {
                      element = QaStickerElement(
                        id: stickerElement is QaStickerElement
                            ? stickerElement.id
                            : null,
                        text: _controller.text.trim(),
                        color: _colorNotifier.value,
                        alignment: stickerElement is QaStickerElement
                            ? alignment
                            : FractionalOffset.center,
                      );
                    } else if (type == AddYStickerElement) {
                      element = AddYStickerElement(
                        id: stickerElement is AddYStickerElement
                            ? stickerElement.id
                            : null,
                        prompt: _controller.text.trim(),
                        color: _colorNotifier.value,
                        alignment: stickerElement is AddYStickerElement
                            ? alignment
                            : FractionalOffset.center,
                      );
                    } else {
                      final one = _option1Controller.text.trim();
                      final two = _option2Controller.text.trim();
                      element = PollStickerElement(
                        id: stickerElement is PollStickerElement
                            ? stickerElement.id
                            : null,
                        question: _controller.text.trim(),
                        options: [
                          if (one.isNotEmpty) one else 'Yes',
                          if (two.isNotEmpty) two else 'No',
                        ],
                        color: _colorNotifier.value,
                        alignment: stickerElement is PollStickerElement
                            ? alignment
                            : FractionalOffset.center,
                      );
                    }

                    CreateElementNotification(
                      element: element,
                    ).dispatch(context);
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
                ValueListenableBuilder(
                  valueListenable: _colorNotifier,
                  builder: (
                    BuildContext context,
                    Color color,
                    Widget? _,
                  ) {
                    return ModelBinding<Color>(
                      model: color,
                      child: StickerScaffold(
                        type: type,
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
                                      StickerContentPlaceholder(type: type),
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
                                        cursorColor: color == Colors.black
                                            ? Colors.white
                                            : Color.alphaBlend(
                                                color.withValues(alpha: .1),
                                                Colors.black,
                                              ),
                                        textAlign: type == PollStickerElement
                                            ? TextAlign.start
                                            : TextAlign.center,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: color == Colors.black
                                              ? Colors.white
                                              : Color.alphaBlend(
                                                  color.withValues(alpha: .1),
                                                  Colors.black,
                                                ),
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
                                        decoration: InputDecoration.collapsed(
                                          hintText: 'Ask a question',
                                          hintStyle: TextStyle(
                                            fontSize: 20,
                                            color: Color.alphaBlend(
                                              color.withValues(alpha: .3),
                                              Colors.black,
                                            ),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            if (type == PollStickerElement)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        controller: optionControllers[index],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        cursorColor: color == Colors.black
                                            ? Colors.white
                                            : Color.alphaBlend(
                                                color.withValues(alpha: .1),
                                                Colors.black,
                                              ),
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration.collapsed(
                                          hintText: ['Yes', 'No'][index],
                                          hintStyle: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black38,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    '0 vote',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                ...[
                  const SizedBox(height: 8),
                  Text(
                    {
                      QaStickerElement: 'Answers will appear as comments',
                      AddYStickerElement:
                          'Viewers can respond with their own Short',
                      PollStickerElement: 'Viewers can vote on a poll option',
                    }[type]!,
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ],
            ),
            HiddenListenableWidget(
              listenable: _focusNode,
              hideCallback: () => !_focusNode.hasFocus,
              child: SizedBox(
                height: 34,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    final color = [
                      Colors.white,
                      Colors.black,
                      Colors.redAccent,
                      Colors.blueAccent,
                      Colors.yellowAccent,
                      Colors.greenAccent,
                      Colors.deepPurpleAccent,
                      Colors.purpleAccent,
                      Colors.purpleAccent,
                      Colors.amberAccent,
                      Colors.brown,
                    ][index];
                    return GestureDetector(
                      onTap: () => _colorNotifier.value = color,
                      child: ListenableBuilder(
                        listenable: _colorNotifier,
                        builder: (BuildContext context, Widget? childWidget) {
                          return AnimatedScale(
                            scale: _colorNotifier.value == color ? 1.13 : .9,
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

    if (numLines > maxLines) return oldValue;
    if (numLines == maxLines && lineMetrics.last.width >= maxWidth - 18) {
      return oldValue;
    }

    // Accept the new value if within the limit
    return newValue;
  }
}

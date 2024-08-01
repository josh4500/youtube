import 'dart:math';

import 'package:flutter/material.dart';

import '../../../theme/icon/y_t_icons_icons.dart';
import '../../gestures/tappable_area.dart';

class ViewableAnswerContext extends StatelessWidget {
  const ViewableAnswerContext({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final bool answered = random.nextBool();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              AnswerOption(
                text: 'Yes',
                correct: false,
                answered: answered,
                selected: false,
              ),
              AnswerOption(
                text: 'No',
                correct: true,
                answered: answered,
                selected: false,
              ),
              AnswerOption(
                text: 'Maybe',
                correct: false,
                answered: answered,
                selected: true,
              ),
            ],
          ),
          if (answered) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explanation',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Prior to being instated into CP0, she was the secretary of Iceburg as well as the only female agent of CP9.[5] After CP9\'s defeat at the hands of the Straw Hat Pirates, she and the rest of CP9 were dismissed by Spandam. For unexplained reasons, she was later reinstated and promoted to CP0. She is also Laskey\'s daughter.',
                  ),
                ],
              ),
            ),
          ],
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '7K answered',
              style: TextStyle(color: Color(0xFFAAAAAA)),
            ),
          ),
        ],
      ),
    );
  }
}

class AnswerOption extends StatelessWidget {
  const AnswerOption({
    super.key,
    required this.text,
    required this.correct,
    required this.answered,
    required this.selected,
  });

  final String text;
  final bool correct;
  final bool answered;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2.5),
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: answered && selected
                  ? correct
                      ? Colors.green
                      : Colors.redAccent
                  : const Color(0xFF272727),
            ),
          ),
          child: TappableArea(
            onTap: () {},
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.all(.5),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.all(.5),
                  padding: const EdgeInsets.all(12),
                  child: answered
                      ? selected
                          ? Icon(
                              correct
                                  ? YTIcons.verified_filled
                                  : Icons.cancel_outlined,
                              size: 18,
                              color: correct ? Colors.green : Colors.redAccent,
                            )
                          : correct
                              ? const Icon(
                                  YTIcons.verified_filled,
                                  size: 18,
                                  color: Colors.green,
                                )
                              : null
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

class SearchSuggestionTile extends StatelessWidget {
  const SearchSuggestionTile({
    super.key,
    required this.onInsertSuggestion,
  });
  final ValueChanged<String> onInsertSuggestion;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            // TODO(josh4500): Make request
            onInsertSuggestion('Something to suggest');
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                if (Random().nextBool())
                  Random().nextBool()
                      ? const Icon(YTIcons.search_outlined)
                      : const Icon(YTIcons.history_outlined)
                else
                  const Icon(YTIcons.trending_outlined),
                const SizedBox(width: 24.0),
                const Expanded(
                  child: Text(
                    'Something to suggest',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 36.0),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            children: [
              const SizedBox(height: 12.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => onInsertSuggestion('Something to suggest'),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

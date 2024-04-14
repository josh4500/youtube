import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'search_suggestion_tile.dart';

class SearchSuggestions extends StatelessWidget {
  const SearchSuggestions({super.key, required this.textController});

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return AuthStateBuilder(
      builder: (context, state) {
        if (state.isInIncognito && textController.text.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Image.asset(
                  AssetsPath.accountIncognito108,
                  width: 84,
                  height: 84,
                  color: const Color(0xFF606060),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 84.0),
                  child: Text(
                    'Search history is paused while you\'re incognito',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return SearchSuggestionTile(
              onInsertSuggestion: (String text) {
                textController.text = text;
              },
            );
          },
          itemCount: 9,
        );
      },
    );
  }
}

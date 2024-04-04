import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/search/widgets/search_suggestion_tile.dart';

class SearchSuggestions extends StatelessWidget {
  const SearchSuggestions({super.key, required this.textController});

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
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
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(onPressed: context.pop),
        title: TextField(
          decoration: InputDecoration(hintText: 'Search YouTube'),
        ),
        actions: [
          CustomActionButton(
            backgroundColor: Colors.white10,
            padding: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(16),
            useTappable: false,
            icon: const Icon(YTIcons.mic_outlined, size: 20),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class SearchVoiceRequestScreen extends StatelessWidget {
  const SearchVoiceRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomBackButton(
              onPressed: context.pop,
              icon: const Icon(YTIcons.close_outlined),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Image.asset(AssetsPath.searchVoiceRequest),
                  ),
                  const Text(
                    'Search with your voice',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 18),
                  RichText(
                    text: const TextSpan(
                      text: 'To search by voice, go to',
                      children: [
                        TextSpan(
                          text: ' Settings > Permissions ',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        TextSpan(
                          text: 'and allow access to Microphone',
                        ),
                      ],
                      style: TextStyle(fontSize: 15),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

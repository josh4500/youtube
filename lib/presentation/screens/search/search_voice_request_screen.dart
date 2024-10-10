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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomBackButton(
                onPressed: context.pop,
                icon: const Icon(YTIcons.close_outlined),
              ),
            ),
            Expanded(
              flex: 5,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(48.0),
                        child: Image.asset(
                          AssetsPath.searchVoiceRequest,
                          width: 250,
                        ),
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
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.resolveWith(
                            (states) => AppPalette.blue,
                          ),
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.all(16),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Open Settings',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

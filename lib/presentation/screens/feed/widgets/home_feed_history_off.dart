import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../../providers.dart';

class HomeFeedHistoryOff extends StatelessWidget {
  const HomeFeedHistoryOff({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Image.asset(
            AssetsPath.logo92,
            height: 86,
            fit: BoxFit.fitHeight,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    return CustomActionButton(
                      backgroundColor: Colors.white10,
                      padding: const EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(24),
                      useTappable: false,
                      icon: const Icon(
                        YTIcons.discover_outlined,
                        size: 20,
                      ),
                      onTap: ref.read(homeRepositoryProvider).openDrawer,
                    );
                  },
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomActionButton(
                    title: 'Search YouTube',
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.white30,
                    ),
                    backgroundColor: Colors.white10,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    useTappable: false,
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => context.goto(AppRoutes.search),
                  ),
                ),
                SizedBox(width: 12.w),
                CustomActionButton(
                  backgroundColor: Colors.white10,
                  padding: const EdgeInsets.all(10),
                  borderRadius: BorderRadius.circular(24),
                  useTappable: false,
                  icon: const Icon(YTIcons.mic_outlined, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.075),
              borderRadius: BorderRadius.circular(12),
              // boxShadow: const [
              //   BoxShadow(
              //     blurRadius: 8,
              //     spreadRadius: -4,
              //     color: Colors.black54,
              //   )
              // ],
            ),
            child: AuthStateBuilder(
              builder: (BuildContext context, state) {
                if (state.isInIncognito) {
                  return Column(
                    children: [
                      const SizedBox(height: 18),
                      const Text(
                        'Try searching to get started',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 18),
                      RichText(
                        text: const TextSpan(
                          text:
                              'Start watching videos to help us build a feed of videos you\'ll love.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                    ],
                  );
                }

                return Column(
                  children: [
                    const SizedBox(height: 18),
                    const Text(
                      'Your watch history is off',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),
                    RichText(
                      text: const TextSpan(
                        text:
                            'You can change setting at any time to get the latest videos tailored to you. ',
                        children: [
                          TextSpan(
                            text: 'Learn more',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppPalette.blue,
                            ),
                          ),
                        ],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white60,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    CustomActionButton(
                      title: 'Update Setting',
                      backgroundColor: Colors.white.withOpacity(0.08),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      alignment: Alignment.center,
                      useTappable: false,
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

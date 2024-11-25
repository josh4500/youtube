import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/generated/l10n.dart';
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
                    title: S.current.searchYoutube,
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: context.theme.hintColor,
                    ),
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
                  padding: const EdgeInsets.all(10),
                  borderRadius: BorderRadius.circular(24),
                  useTappable: false,
                  onTap: () => context.goto(
                    AppRoutes.search,
                    queryParameters: {'voice': true},
                  ),
                  icon: const Icon(YTIcons.mic_outlined, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.theme.brightness.isLight
                  ? context.theme.colorScheme.inverseSurface
                  : context.theme.colorScheme.surface.withOpacity(.075),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                if (context.theme.brightness.isLight)
                  BoxShadow(
                    blurRadius: 8,
                    spreadRadius: 8,
                    color: context.theme.highlightColor,
                  ),
              ],
            ),
            child: AuthStateBuilder(
              builder: (BuildContext context, state) {
                if (state.isInIncognito || state.isUnauthenticated) {
                  return Column(
                    children: [
                      const SizedBox(height: 18),
                      Text(
                        S.current.trySearchingToGetStarted,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 18),
                      RichText(
                        text: TextSpan(
                          text: S.current.startWatchingVideos,
                          style: TextStyle(
                            fontSize: 14,
                            color: context.theme.hintColor,
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
                    Text(
                      S.current.yourWatchHistoryIsOff,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),
                    RichText(
                      text: TextSpan(
                        text: S.current.youCanChangeSettings,
                        children: [
                          TextSpan(
                            text: S.current.learnMore,
                            style: TextStyle(
                              fontSize: 14,
                              color: context.theme.primaryColor,
                            ),
                          ),
                        ],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white60,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    CustomActionButton(
                      title: S.current.updateSetting,
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

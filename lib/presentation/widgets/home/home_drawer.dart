import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/provider/repository/home_repository_provider.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../../constants.dart';
import '../app_logo.dart';
import '../gestures/tappable_area.dart';
import '../over_scroll_glow_behavior.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF212121),
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SafeArea(bottom: false, child: AppLogo()),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: const OverScrollGlowBehavior(enabled: false),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          HomeDrawerItem(
                            title: 'Trending',
                            icon: const Icon(YTIcons.trending_outlined),
                            onTap: () => context.goto(AppRoutes.trending),
                          ),
                          HomeDrawerItem(
                            title: 'Music',
                            icon: const Icon(YTIcons.music_outlined),
                            onTap: () => context.goto(AppRoutes.music),
                          ),
                          HomeDrawerItem(
                            title: 'Live',
                            icon: const Icon(YTIcons.live_outlined),
                            onTap: () => context.goto(AppRoutes.live),
                          ),
                          HomeDrawerItem(
                            title: 'Gaming',
                            icon: const Icon(YTIcons.games_outlined),
                            onTap: () => context.goto(AppRoutes.gaming),
                          ),
                          HomeDrawerItem(
                            title: 'News',
                            icon: const Icon(YTIcons.news_outlined),
                            onTap: () => context.goto(AppRoutes.news),
                          ),
                          HomeDrawerItem(
                            title: 'Sports',
                            icon: const Icon(YTIcons.sports_outlined),
                            onTap: () => context.goto(AppRoutes.sports),
                          ),
                          HomeDrawerItem(
                            title: 'Podcast',
                            icon: const Icon(YTIcons.podcasts_outlined),
                            onTap: () => context.goto(AppRoutes.learning),
                          ),
                          HomeDrawerItem(
                            title: 'Learning',
                            icon: const Icon(YTIcons.learning_outlined),
                            onTap: () => context.goto(AppRoutes.learning),
                          ),
                          HomeDrawerItem(
                            title: 'Fashion And Beauty',
                            icon: const Icon(YTIcons.fashion_outlined),
                            onTap: () =>
                                context.goto(AppRoutes.fashionAndBeauty),
                          ),
                          const Divider(height: 12, thickness: 1),
                          HomeDrawerItem(
                            title: 'Youtube Premium',
                            icon: Image.asset(
                              AssetsPath.ytIcon24,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                          HomeDrawerItem(
                            title: 'Youtube Studio',
                            icon: Image.asset(
                              AssetsPath.ytStudioIcon24,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                          HomeDrawerItem(
                            title: 'Youtube Music',
                            icon: Image.asset(
                              AssetsPath.ytMusicIcon24,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                          HomeDrawerItem(
                            title: 'Youtube kids',
                            icon: Image.asset(
                              AssetsPath.ytKidsIcon24,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                          const Divider(height: 12, thickness: 1),
                          const HomeDrawerItem(
                            title: 'How YouTube works',
                            icon: Icon(YTIcons.help_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              'Privacy Policy · Terms of Service',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.white60),
            ),
          ),
          // const Padding(
          //   padding: EdgeInsets.all(4.0),
          //   child: Text(
          //     'YouTube, a Google company',
          //     style: TextStyle(fontSize: 12, color: Colors.white60),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class HomeDrawerItem extends ConsumerWidget {
  const HomeDrawerItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  final String title;
  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TappableArea(
      onTap: () {
        if (onTap != null) {
          ref.read(homeRepositoryProvider).closeDrawer();
          onTap?.call();
        }
      },
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

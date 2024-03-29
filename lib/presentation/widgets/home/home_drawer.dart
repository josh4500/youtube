import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/provider/repository/home_repository_provider.dart';
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/router/app_routes.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../constants.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
    required this.homeContext,
  });

  final BuildContext homeContext;

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
                    child: ListView(
                      children: <Widget>[
                        HomeDrawerItem(
                          title: 'Trending',
                          icon: const Icon(YTIcons.trending_outlined),
                          onTap: () => homeContext.goto(AppRoutes.trending),
                        ),
                        HomeDrawerItem(
                          title: 'Music',
                          icon: const Icon(YTIcons.music_outlined),
                          onTap: () => homeContext.goto(AppRoutes.music),
                        ),
                        HomeDrawerItem(
                          title: 'Live',
                          icon: const Icon(YTIcons.live_outlined),
                          onTap: () => homeContext.goto(AppRoutes.live),
                        ),
                        HomeDrawerItem(
                          title: 'Gaming',
                          icon: const Icon(YTIcons.games_outlined),
                          onTap: () => homeContext.goto(AppRoutes.gaming),
                        ),
                        HomeDrawerItem(
                          title: 'News',
                          icon: const Icon(YTIcons.news_outlined),
                          onTap: () => homeContext.goto(AppRoutes.news),
                        ),
                        HomeDrawerItem(
                          title: 'Sports',
                          icon: const Icon(YTIcons.sports_outlined),
                          onTap: () => homeContext.goto(AppRoutes.sports),
                        ),
                        HomeDrawerItem(
                          title: 'Learning',
                          icon: const Icon(Icons.lightbulb_outline_rounded),
                          onTap: () => homeContext.goto(AppRoutes.learning),
                        ),
                        HomeDrawerItem(
                          title: 'Fashion And Beauty',
                          icon: const Icon(Icons.font_download_outlined),
                          onTap: () =>
                              homeContext.goto(AppRoutes.fashionAndBeauty),
                        ),
                        const Divider(height: 12, thickness: 2),
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
                        const Divider(height: 12, thickness: 2),
                        const HomeDrawerItem(
                          title: 'How YouTube works',
                          icon: Icon(YTIcons.help_outlined),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Privacy Policy · Terms of Service',
              style: TextStyle(fontSize: 12, color: Colors.white60),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'YouTube, a Google company',
              style: TextStyle(fontSize: 12, color: Colors.white60),
            ),
          ),
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
      onPressed: () {
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/provider/repository/home_repository_provider.dart';
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/router/app_routes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

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
            child: ListView(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: AppLogo(),
                ),
                const SizedBox(height: 12),
                HomeDrawerItem(
                  title: 'Trending',
                  icon: const Icon(Icons.sports_volleyball),
                  onTap: () => homeContext.goto(AppRoutes.trending),
                ),
                HomeDrawerItem(
                  title: 'Music',
                  icon: const Icon(Icons.music_note_outlined),
                  onTap: () => homeContext.goto(AppRoutes.music),
                ),
                HomeDrawerItem(
                  title: 'Live',
                  icon: const Icon(Icons.live_tv_outlined),
                  onTap: () => homeContext.goto(AppRoutes.live),
                ),
                HomeDrawerItem(
                  title: 'Gaming',
                  icon: const Icon(Icons.games_outlined),
                  onTap: () => homeContext.goto(AppRoutes.gaming),
                ),
                HomeDrawerItem(
                  title: 'News',
                  icon: const Icon(Icons.newspaper_outlined),
                  onTap: () => homeContext.goto(AppRoutes.news),
                ),
                HomeDrawerItem(
                  title: 'Sports',
                  icon: const Icon(Icons.wind_power),
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
                  onTap: () => homeContext.goto(AppRoutes.fashionAndBeauty),
                ),
                const Divider(height: 12, thickness: 1),
                const HomeDrawerItem(
                  title: 'Youtube Premium',
                  icon: Icon(Icons.play_arrow, color: Colors.red),
                ),
                const HomeDrawerItem(
                  title: 'Youtube Music',
                  icon: Icon(Icons.play_arrow, color: Colors.red),
                ),
                const HomeDrawerItem(
                  title: 'Youtube kids',
                  icon: Icon(Icons.play_arrow, color: Colors.red),
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

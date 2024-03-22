import 'package:flutter/material.dart';
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
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: AppLogo(),
                ),
                SizedBox(height: 12),
                HomeDrawerItem(
                  title: 'Trending',
                  icon: Icon(Icons.sports_volleyball),
                ),
                HomeDrawerItem(
                  title: 'Music',
                  icon: Icon(Icons.music_note_outlined),
                ),
                HomeDrawerItem(
                  title: 'Live',
                  icon: Icon(Icons.live_tv_outlined),
                ),
                HomeDrawerItem(
                  title: 'Gaming',
                  icon: Icon(Icons.games_outlined),
                ),
                HomeDrawerItem(
                  title: 'News',
                  icon: Icon(Icons.newspaper_outlined),
                ),
                HomeDrawerItem(
                  title: 'Sports',
                  icon: Icon(Icons.wind_power),
                ),
                HomeDrawerItem(
                  title: 'Fashion',
                  icon: Icon(Icons.font_download_outlined),
                ),
                Divider(height: 8, thickness: 1),
                HomeDrawerItem(
                  title: 'Youtube Premium',
                  icon: Icon(Icons.play_arrow, color: Colors.red),
                ),
                HomeDrawerItem(
                  title: 'Youtube Music',
                  icon: Icon(Icons.play_arrow, color: Colors.red),
                ),
                HomeDrawerItem(
                  title: 'Youtube kids',
                  icon: Icon(Icons.play_arrow, color: Colors.red),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              'Privacy Policy · Terms of Service',
              style: TextStyle(fontSize: 11, color: Colors.white38),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeDrawerItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return TappableArea(
      onPressed: onTap,
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

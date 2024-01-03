import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/router/app_routes.dart';
import 'package:youtube_clone/presentation/screens/watch_on_tv/widgets/found_tvs.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

class WatchOnTvScreen extends StatelessWidget {
  const WatchOnTvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch on TV'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            color: Colors.red,
            child: const Text(
              'Connect to the same Wi-Fi network as your TV',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const FoundTVs(),
          const Divider(thickness: 1.5, height: 0),
          TappableArea(
            onPressed: () => context.goto(AppRoutes.linkTv),
            padding: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Link with TV code'),
                  const SizedBox(height: 16),
                  const Text(
                    'Another way of connecting devices. Learn how to get a code from your TV that you enter here',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        EdgeInsetsDirectional.zero,
                      ),
                    ),
                    child: const Text('Enter TV code'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const Divider(thickness: 1.5, height: 0),
          ListTile(
            onTap: () {},
            title: const Text('Don\'t see your TV?'),
          ),
          const Divider(thickness: 1.5, height: 0),
        ],
      ),
    );
  }
}

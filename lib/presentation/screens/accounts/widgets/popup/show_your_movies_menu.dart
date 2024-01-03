import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/router/app_routes.dart';

Future<T?> showYourMoviesMenu<T>(
  BuildContext context,
  RelativeRect position,
) async {
  return showMenu<T>(
    context: context,
    position: position,
    items: [
      PopupMenuItem(
        onTap: () {
          context.goto(AppRoutes.settings);
        },
        child: const Text('Settings'),
      ),
      PopupMenuItem(
        onTap: () {
          context.goto(AppRoutes.watchOnTv);
        },
        child: const Text('Watch on TV'),
      ),
      PopupMenuItem(
        onTap: () {},
        child: const Text('Terms & privacy policy'),
      ),
      const PopupMenuItem(
        child: Text('Help & feedback'),
      ),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/router.dart';

Future<void> showChannelMenu(
  BuildContext context,
  RelativeRect position,
) async {
  return showMenu(
    context: context,
    menuPadding: EdgeInsets.zero,
    position: position,
    items: <PopupMenuEntry>[
      const PopupMenuItem(
        child: Text('Share'),
      ),
      const PopupMenuItem(
        child: Text('Hide user from my channel'),
      ),
      const PopupMenuItem(
        child: Text('Report user'),
      ),
      PopupMenuItem(
        child: const Text('Settings'),
        onTap: () => context.goto(AppRoutes.settings),
      ),
      PopupMenuItem(
        child: const Text('Watch on TV'),
        onTap: () => context.goto(AppRoutes.watchOnTv),
      ),
      const PopupMenuItem(
        child: Text('Terms & privacy policy'),
      ),
      const PopupMenuItem(
        child: Text('Help & feedback'),
      ),
    ],
  );
}

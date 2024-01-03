import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/router/app_routes.dart';

Future<T?> showHistoryMenu<T>(
  BuildContext context,
  RelativeRect position,
) async {
  return showMenu<T>(
    context: context,
    position: position,
    items: [
      const PopupMenuItem(
        child: Text('Pause watch history'),
      ),
      const PopupMenuItem(
        child: Text('Clear all watch history'),
      ),
      const PopupMenuItem(
        child: Text('Manage all history'),
      ),
      PopupMenuItem(
        onTap: () {
          context.goto(AppRoutes.watchOnTv);
        },
        child: const Text('Watch on TV'),
      ),
      const PopupMenuItem(
        child: Text('Help & feedback'),
      ),
    ],
  );
}

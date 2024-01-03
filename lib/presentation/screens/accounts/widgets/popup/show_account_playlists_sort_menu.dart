import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

Future<T?> showAccountPlaylistsSortMenu<T>(
  BuildContext context,
) async {
  return showMenu<T>(
    context: context,
    position: const RelativeRect.fromLTRB(0, 0, 0, 0),
    items: [
      PopupMenuItem(
        child: TappableArea(
          onPressed: () {},
          child: Text('Date added (newest)'),
        ),
      ),
      PopupMenuItem(
        child: TappableArea(
          onPressed: () {},
          child: Text('Last video added'),
        ),
      ),
    ],
  );
}

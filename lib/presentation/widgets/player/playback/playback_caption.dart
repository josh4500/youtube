import 'package:flutter/material.dart';

class PlaybackCaption extends StatelessWidget {
  const PlaybackCaption({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        return Container(
          width: 240,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'There is going to be a war blah blah bla',
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import '../viewable_shorts_content.dart';

class ViewableGroupShorts extends StatelessWidget {
  const ViewableGroupShorts({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 286,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return const ViewableShortsContent();
        },
        itemCount: 10,
      ),
    );
  }
}

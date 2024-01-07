import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/viewable/group/viewable_group_layout.dart';

import '../viewable_shorts_content.dart';

class ViewableGroupShorts extends StatelessWidget {
  final ViewableGroupLayout layout;
  // TODO: Add how the different layouts should be built
  const ViewableGroupShorts({
    super.key,
    this.layout = ViewableGroupLayout.list,
  });

  @override
  Widget build(BuildContext context) {
    if (layout == ViewableGroupLayout.grid) {}

    return Column(
      children: [
        const Divider(thickness: 1.5, height: 0),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.adb_sharp,
                size: 36,
                color: Colors.red,
              ),
              SizedBox(width: 16),
              Text(
                'Shorts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 286,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return ViewableShortsContent(
                width: 180,
                margin: const EdgeInsets.all(4),
                borderRadius: BorderRadius.circular(8),
              );
            },
            itemCount: 10,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

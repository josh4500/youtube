import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/channel_avatar.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

class ViewablePostContent extends StatelessWidget {
  const ViewablePostContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(thickness: 1.5, height: 0),
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            top: 8.0,
            bottom: 8.0,
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(6.0),
                child: ChannelAvatar(),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ByteByteGo',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '42 minutes ago',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(32),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.more_vert),
                ),
              ),
            ],
          ),
        ),
        TappableArea(
          onPressed: () {},
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
          child: const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              'We are often asked to design for high availability, high scalability, and high throughput. What ',
            ),
          ),
        ),
        Container(
          height: 320,
          color: Colors.white38,
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.thumb_up_outlined),
              SizedBox(width: 8),
              Text('104'),
              SizedBox(width: 32),
              Icon(Icons.thumb_down_outlined),
              Spacer(),
              Icon(Icons.comment_outlined),
              SizedBox(width: 8),
              Text('2'),
            ],
          ),
        )
      ],
    );
  }
}

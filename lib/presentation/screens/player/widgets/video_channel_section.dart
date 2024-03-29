import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/account_avatar.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

class VideoChannelSection extends StatelessWidget {
  const VideoChannelSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        VideoChannelButton(),
        Positioned(
          top: 8,
          right: 12,
          child: VideoChannelActionButtons(),
        )
      ],
    );
  }
}

class VideoChannelButton extends StatelessWidget {
  const VideoChannelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const TappableArea(
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 12,
      ),
      borderRadius: BorderRadius.zero,
      child: Row(
        children: [
          AccountAvatar(size: 40, name: 'John Jackson'),
          SizedBox(width: 12),
          Text(
            'Harris Craycraft',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Text(
            '101K',
            style: TextStyle(
              color: Color(0xFFAAAAAA),
              fontSize: 13,
            ),
          ),
          Spacer(),
          SizedBox(
            width: 74,
            height: 30,
          ),
        ],
      ),
    );
  }
}

class VideoChannelActionButtons extends StatelessWidget {
  const VideoChannelActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        if (false) VideoChannelMembershipButton(),
        SizedBox(width: 12),
        VideoChannelSubscriptionButton(),
      ],
    );
  }
}

class VideoChannelMembershipButton extends StatelessWidget {
  const VideoChannelMembershipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 9,
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: const Text(
        'Join',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class VideoChannelSubscriptionButton extends StatelessWidget {
  const VideoChannelSubscriptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 9,
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: const Text(
        'Subscribe',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'video/video_channel_button.dart';
import 'video_notification.dart';

class VideoChannelSection extends StatelessWidget {
  const VideoChannelSection({super.key});

  @override
  Widget build(BuildContext context) {
    return TappableArea(
      onTap: () {},
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 12,
      ),
      child: Row(
        children: [
          const Expanded(child: VideoChannelButton()),
          SizedBox(width: 12.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const VideoChannelMembershipButton(),
              SizedBox(width: 12.w),
              const VideoChannelSubscriptionButton(),
            ],
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
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        VideoChannelMembershipButton(),
        SizedBox(width: 12),
        VideoChannelSubscriptionButton(),
      ],
    );
  }
}

class VideoChannelMembershipButton extends ConsumerWidget {
  const VideoChannelMembershipButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomActionChip(
      title: 'Join',
      onTap: () => OpenBottomSheetNotification(
        sheet: VideoBottomSheet.membership,
      ).dispatch(context),
      backgroundColor: context.theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 14,
      ),
      textStyle: TextStyle(
        fontSize: 12,
        color: context.theme.colorScheme.inverseSurface,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class VideoChannelSubscriptionButton extends StatefulWidget {
  const VideoChannelSubscriptionButton({super.key});

  @override
  State<VideoChannelSubscriptionButton> createState() =>
      _VideoChannelSubscriptionButtonState();
}

class _VideoChannelSubscriptionButtonState
    extends State<VideoChannelSubscriptionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomActionButton(
      title: 'Subscribe',
      onTap: () {},
      backgroundColor: context.theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 14,
      ),
      textStyle: TextStyle(
        fontSize: 12,
        color: context.theme.colorScheme.inverseSurface,
        fontWeight: FontWeight.w500,
      ),
    );
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ShaderMask(
          blendMode: BlendMode.colorBurn,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.theme.primaryColor,
                Colors.purple,
                AppPalette.red,
                Colors.orange,
              ],
              stops: [
                (_controller.value - 0.2).clamp(0.0, 1.0),
                _controller.value,
                (_controller.value + 0.2).clamp(0.0, 1.0),
                (_controller.value + 0.4).clamp(0.0, 1.0),
              ],
              // tileMode: TileMode.repeated,
            ).createShader(bounds);
          },
          child: CustomActionButton(
            title: 'Subscribe',
            onTap: () {},
            backgroundColor: context.theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 14,
            ),
            textStyle: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}

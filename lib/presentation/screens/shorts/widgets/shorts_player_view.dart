import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class ShortsPlayerView extends StatelessWidget {
  const ShortsPlayerView({
    super.key,
    required bool isSubscriptionScreen,
    required bool isLiveScreen,
  })  : _isSubscriptionScreen = isSubscriptionScreen,
        _isLiveScreen = isLiveScreen;

  // TODO(Josh): Will be provider vlues
  final bool _isSubscriptionScreen;
  final bool _isLiveScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF656565),
        image: DecorationImage(
          image: _isSubscriptionScreen
              ? const CustomNetworkImage(
                  'https://picsum.photos/360/700',
                )
              : _isLiveScreen
                  ? const CustomNetworkImage(
                      'https://picsum.photos/400/800',
                    )
                  : const CustomNetworkImage(
                      'https://picsum.photos/444/800',
                    ),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}

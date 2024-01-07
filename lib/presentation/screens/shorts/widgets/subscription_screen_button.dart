import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/router/app_routes.dart';
import 'package:youtube_clone/presentation/widgets/custom_action_chip.dart';

class SubscriptionScreenButton extends StatelessWidget {
  const SubscriptionScreenButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        children: [
          const SizedBox(height: kToolbarHeight * 1.2),
          Row(
            children: [
              CustomActionChip(
                onTap: () => context.goto(AppRoutes.shortsSubscription),
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 16,
                ),
                icon: const Icon(Icons.subscriptions_outlined),
                backgroundColor: Colors.white10,
                title: 'Subscriptions',
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

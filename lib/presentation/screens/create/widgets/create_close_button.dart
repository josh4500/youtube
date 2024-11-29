import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class CreateCloseButton extends StatelessWidget {
  const CreateCloseButton({super.key, this.icon, this.onPopInvoked});
  final bool Function()? onPopInvoked;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      onTap: () {
        bool shouldPop = true;
        if (onPopInvoked != null) shouldPop = onPopInvoked!();
        if (shouldPop) context.pop();
      },
      borderRadius: BorderRadius.circular(24),
      splashFactory: NoSplash.splashFactory,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon ?? YTIcons.close_outlined,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

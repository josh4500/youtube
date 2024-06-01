import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/theme/icon/y_t_icons_icons.dart';

class CreateCloseButton extends StatelessWidget {
  const CreateCloseButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.pop,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          YTIcons.close_outlined,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

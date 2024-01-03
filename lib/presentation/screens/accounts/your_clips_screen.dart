import 'package:flutter/material.dart';

import '../../widgets/appbar_action.dart';

class YourClipsScreen extends StatefulWidget {
  const YourClipsScreen({super.key});

  @override
  State<YourClipsScreen> createState() => _YourClipsScreenState();
}

class _YourClipsScreenState extends State<YourClipsScreen>
    with TickerProviderStateMixin {
  final ScrollController controller = ScrollController();
  late final AnimationController opacityController;
  late final Animation animation;

  @override
  void initState() {
    super.initState();
    opacityController = AnimationController(
      vsync: this,
      value: 0,
      duration: const Duration(milliseconds: 150),
    );
    animation = CurvedAnimation(parent: opacityController, curve: Curves.ease);
    controller.addListener(() {
      if (controller.offset <= 250) {
        opacityController.value = controller.offset / 250;
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Opacity(
              opacity: animation.value,
              child: child!,
            );
          },
          child: const Text(
            'Your clips',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        actions: [
          AppbarAction(
            icon: Icons.cast_outlined,
            onTap: () {},
          ),
          AppbarAction(
            icon: Icons.search,
            onTap: () {},
          ),
          AppbarAction(
            icon: Icons.more_vert_outlined,
            onTapDown: (details) {
              final position = details.globalPosition;
            },
          ),
        ],
      ),
    );
  }
}

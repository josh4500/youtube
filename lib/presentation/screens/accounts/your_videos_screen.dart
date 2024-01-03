import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';

import '../../widgets/appbar_action.dart';
import 'widgets/popup/show_your_videos_menu.dart';

class YourVideosScreen extends StatefulWidget {
  const YourVideosScreen({super.key});

  @override
  State<YourVideosScreen> createState() => _YourVideosScreenState();
}

class _YourVideosScreenState extends State<YourVideosScreen>
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
    print(38 / MediaQuery.devicePixelRatioOf(context));
    print(MediaQuery.devicePixelRatioOf(context));
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
            'Your videos',
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
            onTapDown: (details) async {
              final position = details.globalPosition;
              await showYourVideosMenu(
                context,
                RelativeRect.fromLTRB(position.dx, 0, 0, 0),
              );
            },
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: const OverScrollGlowBehavior(color: Colors.black12),
        child: CustomScrollView(
          controller: controller,
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16,
                ),
                child: Text(
                  'Your videos',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.5,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.tune_outlined,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const SomeButton(title: 'Videos', isSelected: true),
                    const SizedBox(width: 8),
                    const SomeButton(title: 'Shorts'),
                    const SizedBox(width: 8),
                    const SomeButton(title: 'Live'),
                  ],
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.all(16.0),
              sliver: SliverFillRemaining(),
            ),
          ],
        ),
      ),
    );
  }
}

class SomeButton extends StatefulWidget {
  final bool isSelected;
  final String title;

  const SomeButton({
    super.key,
    this.isSelected = false,
    required this.title,
  });

  @override
  State<SomeButton> createState() => _SomeButtonState();
}

class _SomeButtonState extends State<SomeButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.5, horizontal: 12),
      decoration: BoxDecoration(
        color: widget.isSelected ? Colors.white : Colors.white12,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        widget.title,
        style: TextStyle(
          color: widget.isSelected ? Colors.black : Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

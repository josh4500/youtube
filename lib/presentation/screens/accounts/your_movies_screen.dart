import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/accounts/widgets/popup/show_your_movies_menu.dart';

import '../../widgets/appbar_action.dart';
import '../../widgets/over_scroll_glow_behavior.dart';

class YourMoviesScreen extends StatefulWidget {
  const YourMoviesScreen({super.key});

  @override
  State<YourMoviesScreen> createState() => _YourMoviesScreenState();
}

class _YourMoviesScreenState extends State<YourMoviesScreen>
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
      if (controller.offset <= 150) {
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
            'Movies',
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
              await showYourMoviesMenu(
                context,
                RelativeRect.fromLTRB(position.dx, 0, 0, 0),
              );
            },
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: const OverScrollGlowBehavior(
          color: Colors.black12,
        ),
        child: CustomScrollView(
          controller: controller,
          slivers: const [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.movie_sharp,
                      size: 36,
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Movies',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 128)),
            SliverFillRemaining(
              child: Column(
                children: [
                  Spacer(flex: 2),
                  Text(
                    'You don\'t have any purchases',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Movies and shows you rent or buy will\nappear here',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Spacer(flex: 1),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'create_live_screen.dart';
import 'create_post_screen.dart';
import 'create_shorts_screen.dart';
import 'create_video_screen.dart';
import 'widgets/notifications/create_notification.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<int> selectedNotifier = ValueNotifier<int>(1);
  final PageController controller = PageController(
    viewportFraction: 0.18,
    initialPage: 1,
  );
  late final AnimationController hideNController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  final Gradient _overflowShader = const LinearGradient(
    stops: [0, .4, .6, 1],
    colors: <Color>[
      Color(0x00FFFFFF),
      Color(0xFFFFFFFF),
      Color(0xFFFFFFFF),
      Color(0x00FFFFFF),
    ],
  );

  @override
  void dispose() {
    controller.dispose();
    hideNController.dispose();
    selectedNotifier.dispose();
    super.dispose();
  }

  void onPageChangeCallback(int pageIndex) {
    selectedNotifier.value = pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Video', 'Short', 'Live', 'Post'];
    return Theme(
      data: AppTheme.dark,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: NotificationListener<CreateNotification>(
                  onNotification: (CreateNotification notification) {
                    if (notification.hideNavigator) {
                      hideNController.forward();
                    } else {
                      hideNController.reverse();
                    }
                    return true;
                  },
                  child: ListenableBuilder(
                    listenable: selectedNotifier,
                    builder: (BuildContext context, Widget? _) {
                      return IndexedStack(
                        index: selectedNotifier.value,
                        children: const <Widget>[
                          CreateVideoScreen(),
                          CreateShortsScreen(),
                          CreateLiveScreen(),
                          CreatePostScreen(),
                        ],
                      );
                    },
                  ),
                ),
              ),
              ColoredBox(
                color: Colors.black,
                child: ShaderMask(
                  shaderCallback: _overflowShader.createShader,
                  child: SizedBox(
                    height: 88,
                    width: double.infinity,
                    child: AnimatedVisibility(
                      animation: ReverseAnimation(hideNController),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Opacity(
                              opacity: 0,
                              child: ListenableBuilder(
                                listenable: selectedNotifier,
                                builder: (BuildContext context, Widget? _) {
                                  return Text(
                                    tabs[selectedNotifier.value],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          PageView.builder(
                            controller: controller,
                            onPageChanged: onPageChangeCallback,
                            itemCount: tabs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () => controller.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInToLinear,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 16,
                                    ),
                                    child: ListenableBuilder(
                                      listenable: selectedNotifier,
                                      builder: (
                                        BuildContext context,
                                        Widget? _,
                                      ) {
                                        return Text(
                                          tabs[index],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                index == selectedNotifier.value
                                                    ? Colors.white
                                                    : Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

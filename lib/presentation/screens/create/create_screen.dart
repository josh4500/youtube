import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'create_live_screen.dart';
import 'create_post_screen.dart';
import 'create_shorts_screen.dart';
import 'create_video_screen.dart';
import 'widgets/notifications/create_notification.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key, this.showOnlyShorts = false});
  final bool showOnlyShorts;

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen>
    with SingleTickerProviderStateMixin {
  final IndexNotifier<CreateTab> indexNotifier = IndexNotifier<CreateTab>(
    CreateTab.shorts,
  );
  final PageController controller = PageController(
    viewportFraction: 0.18,
    initialPage: 1,
  );
  late final AnimationController hideNController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  late final ValueNotifier<bool> collapseNotifier = ValueNotifier<bool>(false);
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
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    controller.dispose();
    collapseNotifier.dispose();
    hideNController.dispose();
    indexNotifier.dispose();
    super.dispose();
  }

  void onPageChangeCallback(int pageIndex) {
    indexNotifier.value = CreateTab.values[pageIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Expanded(
                child: NotificationListener<CreateNotification>(
                  onNotification: (CreateNotification notification) {
                    if (notification.hideNavigator) {
                      hideNController.forward();
                    } else {
                      hideNController.reverse();
                    }
                    // collapseNotifier.value = notification.collapseNavigator;
                    return true;
                  },
                  child: ModelBinding<IndexNotifier>(
                    model: indexNotifier,
                    child: ListenableBuilder(
                      listenable: indexNotifier,
                      builder: (BuildContext context, Widget? _) {
                        return IndexedStack(
                          index: indexNotifier.currentIndex,
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
              ),
              ColoredBox(
                color: Colors.black,
                child: ValueListenableBuilder(
                  valueListenable: collapseNotifier,
                  builder: (BuildContext context, bool collapse, Widget? _) {
                    if (collapse) return const SizedBox();
                    return ShaderMask(
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
                                    listenable: indexNotifier,
                                    builder: (BuildContext context, Widget? _) {
                                      final index = indexNotifier.currentIndex;
                                      return Text(
                                        CreateTab.values[index].name,
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
                                itemCount: CreateTab.values.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () => controller.animateToPage(
                                      index,
                                      duration:
                                          const Duration(milliseconds: 250),
                                      curve: Curves.easeInToLinear,
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 16,
                                        ),
                                        child: ListenableBuilder(
                                          listenable: indexNotifier,
                                          builder: (
                                            BuildContext context,
                                            Widget? _,
                                          ) {
                                            return FittedBox(
                                              child: Text(
                                                CreateTab.values[index].name,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: index ==
                                                          indexNotifier
                                                              .currentIndex
                                                      ? Colors.white
                                                      : Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                ),
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

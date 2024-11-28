import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'widgets/add_music_button.dart';
import 'widgets/editor/editor_effects.dart';
import 'widgets/notifications/editor_notification.dart';

class ShortsEditorScreen extends StatefulWidget {
  const ShortsEditorScreen({super.key});

  @override
  State<ShortsEditorScreen> createState() => _ShortsEditorScreenState();
}

class _ShortsEditorScreenState extends State<ShortsEditorScreen>
    with TickerProviderStateMixin {
  late final AnimationController timelineSizeAnimation = AnimationController(
    vsync: this,
    duration: Durations.medium2,
  );

  final ValueNotifier<bool> hideNavButtons = ValueNotifier<bool>(false);
  final ValueNotifier<bool> hideEditorEffects = ValueNotifier<bool>(false);

  @override
  void dispose() {
    hideNavButtons.dispose();
    hideEditorEffects.dispose();
    timelineSizeAnimation.dispose();
    super.dispose();
  }

  Future<void> _openTimeline() async {
    hideNavButtons.value = true;
    await timelineSizeAnimation.forward();
    hideEditorEffects.value = true;
  }

  Future<void> _closeTimeline() async {
    await timelineSizeAnimation.reverse();
    hideNavButtons.value = false;
    hideEditorEffects.value = false;
  }

  bool handleEditorNotification(EditorNotification notification) {
    if (notification is OpenTimelineNotification) {
      _openTimeline();
    } else if (notification is CloseTimelineNotification) {
      _closeTimeline();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: NotificationListener<EditorNotification>(
          onNotification: handleEditorNotification,
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (
                    BuildContext context,
                    BoxConstraints constraints,
                  ) {
                    return Stack(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: CustomBackButton(onPressed: context.pop),
                            ),
                            const Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: AddMusicButton(),
                              ),
                            ),
                            HiddenListenableWidget(
                              listenable: hideEditorEffects,
                              hideCallback: () => hideEditorEffects.value,
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: EditorEffects(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizeTransition(
                            axisAlignment: -1,
                            sizeFactor: timelineSizeAnimation,
                            child: SizedBox(
                              width: double.infinity,
                              height: constraints.maxHeight / 2,
                              child: const TimelineEditor(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              HiddenListenableWidget(
                listenable: hideNavButtons,
                hideCallback: () => hideNavButtons.value,
                child: const EditorNavButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditorNavButtons extends StatelessWidget {
  const EditorNavButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 24,
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomActionButton(
              icon: const Icon(YTIcons.timeline, size: 16),
              title: 'Timeline',
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              onTap: () {
                OpenTimelineNotification().dispatch(context);
              },
              alignment: Alignment.center,
              padding: const EdgeInsets.all(12),
              backgroundColor: Colors.white12,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: CustomActionChip(
              title: 'Next',
              alignment: Alignment.center,
              textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              padding: EdgeInsets.all(12),
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineEditor extends StatelessWidget {
  const TimelineEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF202020),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white10,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: AlwaysStoppedAnimation(0),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        CloseTimelineNotification().dispatch(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'DONE',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              child: Stack(
                children: [
                  Container(
                    width: .1,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    height: double.infinity,
                    color: Colors.white,
                  ),
                  ScrollConfiguration(
                    behavior: const OverScrollGlowBehavior(
                      color: Colors.black12,
                    ),
                    child: ListView.builder(
                      reverse: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 52.h,
                          margin: const EdgeInsets.only(
                            top: 6,
                            bottom: 4,
                          ),
                          width: double.infinity,
                          color: Colors.white,
                        );
                      },
                      itemCount: 6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12,
            ),
            child: Stack(
              children: [
                Transform.translate(
                  offset: const Offset(0, 4),
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Container(
                  width: 5,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

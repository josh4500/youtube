import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../notifications/editor_notification.dart';

class EditorTimeline extends StatelessWidget {
  const EditorTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF212121),
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
          const Divider(height: 0, thickness: 1.5),
          Expanded(
            child: Stack(
              children: [
                Transform.translate(
                  offset: const Offset(24, 0),
                  child: Container(
                    width: .1,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    height: double.infinity,
                    color: Colors.white,
                  ),
                ),
                ScrollConfiguration(
                  behavior: const OverScrollGlowBehavior(
                    color: Colors.black12,
                  ),
                  child: ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.white10,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text('Aa'),
                        );
                      }
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
                    itemCount: 1,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0, thickness: 1.5),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 24,
            ),
            child: Stack(
              children: [
                Transform.translate(
                  offset: const Offset(0, 4),
                  child: Container(
                    height: 64,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Container(
                  width: 6,
                  height: 72,
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

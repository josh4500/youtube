import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';
import 'package:youtube_clone/presentation/widgets/sheet_drag_indicator.dart';

import 'element.dart';

class EditorStickerSelector extends StatelessWidget {
  const EditorStickerSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final oldStickerElement = context.provide<StickerElement?>();
    return Material(
      color: Colors.black,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          const SheetDragIndicator(),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Choose sticker',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: context.pop,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(YTIcons.check_outlined),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(
              3,
              (int index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      bool replace = true;

                      if (oldStickerElement != null) {
                        await showDialog(
                          context: context,
                          barrierLabel: 'video_clip',
                          builder: (BuildContext context) {
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                margin: const EdgeInsets.all(48),
                                decoration: BoxDecoration(
                                  color: context.theme.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Material(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Replace sticker',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'The current sticker will be replaced with a new sticker',
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CustomActionChip(
                                            onTap: () {
                                              context.pop();
                                            },
                                            title: 'Cancel',
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(12),
                                            textStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          CustomActionChip(
                                            title: 'Replace',
                                            onTap: () {
                                              replace = true;
                                              context.pop();
                                            },
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(12),
                                            backgroundColor: context
                                                .theme.colorScheme.surface,
                                            textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: context.theme.colorScheme
                                                  .inverseSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      if (replace && context.mounted) {
                        context.pop(
                          [
                            QaStickerElement,
                            AddYStickerElement,
                            PollStickerElement,
                          ][index],
                        );
                      }
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 72.h,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          padding: const EdgeInsets.all(12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white.withOpacity(.05),
                          ),
                          child: Text(
                            ['Q&A', 'Add yours', 'Poll'][index],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: [
                                const Color(0xFFFFFFB3),
                                const Color(0xFFB47BFF),
                                const Color(0xFF00E5BE),
                              ][index],
                            ),
                            child: Icon(
                              [
                                Icons.question_mark,
                                YTIcons.camera_outlined,
                                YTIcons.poll_outlined,
                              ][index],
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/theme/icon/y_t_icons_icons.dart';
import 'package:youtube_clone/presentation/view_models/model_binding.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'element.dart';

class StickerScaffold extends StatelessWidget {
  const StickerScaffold({
    super.key,
    required this.child,
    required this.type,
  });
  final Widget child;
  final Type type;

  @override
  Widget build(BuildContext context) {
    final Color color = context.provide<Color>();
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 200,
        maxWidth: 250,
      ),
      child: IntrinsicWidth(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  color.withOpacity(.5),
                  Colors.white,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (type == QaStickerElement || type == AddYStickerElement)
                    const SizedBox(height: 4),
                  child,
                  if (type == QaStickerElement ||
                      type == AddYStickerElement) ...[
                    if (type == AddYStickerElement) const SizedBox(height: 24),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Builder(
                        builder: (context) {
                          if (type == QaStickerElement) {
                            return Text(
                              'Answer',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.alphaBlend(
                                  color.withOpacity(.1),
                                  Colors.black,
                                ),
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          } else {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  YTIcons.camera_outlined,
                                  size: 16,
                                  color: Color.alphaBlend(
                                    color.withOpacity(.1),
                                    Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Add yours',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.alphaBlend(
                                      color.withOpacity(.1),
                                      Colors.black,
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (type == QaStickerElement || type == AddYStickerElement)
              Positioned.fill(
                top: -14,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Builder(
                    builder: (context) {
                      if (type == QaStickerElement) {
                        return Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.alphaBlend(
                                color.withOpacity(.3),
                                Colors.white,
                              ),
                            ),
                            color: Color.alphaBlend(
                              color.withOpacity(.85),
                              Colors.black,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            {
                              QaStickerElement: YTIcons.feedbck_outlined,
                              AddYStickerElement: YTIcons.camera_outlined,
                            }[type],
                            color: Color.alphaBlend(
                              color.withOpacity(.3),
                              Colors.black,
                            ),
                            size: 20,
                          ),
                        );
                      } else {
                        return AccountAvatar(
                          size: 28,
                          border: Border.all(color: Colors.white),
                        );
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

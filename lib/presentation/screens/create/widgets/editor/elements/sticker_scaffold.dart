import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/theme/icon/y_t_icons_icons.dart';
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
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 200,
        maxWidth: 250,
      ),
      child: IntrinsicHeight(
        child: IntrinsicWidth(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 4),
                    child,
                    if (type == QaStickerElement ||
                        type == AddYStickerElement) ...[
                      if (type == AddYStickerElement)
                        const SizedBox(height: 24),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Builder(
                          builder: (context) {
                            if (type == QaStickerElement) {
                              return const Text(
                                'Answer',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            } else {
                              return const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    YTIcons.camera_outlined,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Add yours',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
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
                Align(
                  alignment: Alignment.topCenter,
                  child: Transform.translate(
                    offset: const Offset(0, -14),
                    child: Builder(
                      builder: (context) {
                        if (type == QaStickerElement) {
                          return Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                              ),
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              {
                                QaStickerElement: YTIcons.feedbck_outlined,
                                AddYStickerElement: YTIcons.camera_outlined,
                              }[type],
                              color: Colors.black,
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
      ),
    );
  }
}

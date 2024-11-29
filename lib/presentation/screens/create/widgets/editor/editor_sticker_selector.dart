import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets/sheet_drag_indicator.dart';

class EditorStickerSelector extends StatelessWidget {
  const EditorStickerSelector({super.key});

  @override
  Widget build(BuildContext context) {
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
              (index) {
                return Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 72,
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

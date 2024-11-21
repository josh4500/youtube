// Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of {{ project }} nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/constants/values.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class VideoClipSheet extends StatefulWidget {
  const VideoClipSheet({
    super.key,
    this.controller,
    required this.onPressClose,
    this.draggableController,
    required this.initialHeight,
  });

  final ScrollController? controller;
  final VoidCallback onPressClose;
  final double initialHeight;
  final DraggableScrollableController? draggableController;

  @override
  State<VideoClipSheet> createState() => _VideoClipSheetState();
}

class _VideoClipSheetState extends State<VideoClipSheet> {
  final textFocusNode = FocusNode();
  final textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.draggableController?.animateTo(
        widget.initialHeight,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInCubic,
      );
    });
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageDraggableSheet(
      title: 'Create clip',
      controller: widget.controller ?? ScrollController(),
      onClose: () {
        showDialog(
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Discard this clip?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'If you do you\'ll lose all your changes',
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomActionChip(
                            onTap: () {
                              textFocusNode.unfocus();
                              textEditingController.clear();

                              context.pop();
                              widget.onPressClose();
                            },
                            title: 'Discard clip',
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(12),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomActionChip(
                            title: 'Keep',
                            onTap: context.pop,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(12),
                            backgroundColor: context.theme.colorScheme.surface,
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: context.theme.colorScheme.inverseSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      draggableController: widget.draggableController,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          padding: EdgeInsets.zero,
          splashRadius: 32,
          splashColor: Colors.transparent,
          constraints: const BoxConstraints.tightFor(height: 28),
          icon: const Icon(YTIcons.info_outlined),
        ),
      ],
      contentBuilder: (context, controller, physics) {
        return ListView(
          controller: controller,
          physics: physics,
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                const AccountAvatar(size: 36),
                const SizedBox(width: 12),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Joshua Akinmosin',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            YTIcons.location_outlined,
                            size: 14,
                            color: context.theme.hintColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Public',
                            style: TextStyle(color: context.theme.hintColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    focusNode: textFocusNode,
                    controller: textEditingController,
                    minLines: 1,
                    maxLines: 200,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Add a title (required)',
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListenableBuilder(
                    listenable: textEditingController,
                    builder: (BuildContext context, Widget? _) {
                      final length = textEditingController.text.length;
                      return Text(
                        '$length/140',
                        style: TextStyle(
                          fontSize: 12,
                          color: length > 140
                              ? Colors.red.withOpacity(.5)
                              : context.theme.hintColor,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomActionButton(
                  title: 'Cancel',
                  onTap: () {},
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.theme.primaryColor,
                  ),
                  backgroundColor: Colors.transparent,
                ),
                ListenableBuilder(
                  listenable: textEditingController,
                  builder: (BuildContext context, Widget? _) {
                    final length = textEditingController.text.length;
                    return CustomActionChip(
                      title: 'Share clip',
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      backgroundColor: length == 0
                          ? context.theme.colorScheme.surface.withOpacity(.5)
                          : context.theme.primaryColor,
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.theme.colorScheme.inverseSurface,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
      baseHeight: 1 - kAvgVideoViewPortHeight,
      showDragIndicator: true,
    );
  }
}

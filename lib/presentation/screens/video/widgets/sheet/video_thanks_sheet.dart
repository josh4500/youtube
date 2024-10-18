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
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../../../constants.dart';

class VideoThanksSheet extends StatefulWidget {
  const VideoThanksSheet({
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
  State<VideoThanksSheet> createState() => _VideoThanksSheetState();
}

class _VideoThanksSheetState extends State<VideoThanksSheet> {
  final thanksNotifier = ValueNotifier(0);
  final showMoreThanks = ValueNotifier(false);
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
    showMoreThanks.dispose();
    thanksNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageDraggableSheet(
      title: 'Thanks Harris Craycraft',
      controller: widget.controller ?? ScrollController(),
      onClose: widget.onPressClose,
      draggableController: widget.draggableController,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      actions: const [
        Icon(YTIcons.info_outlined),
      ],
      contentBuilder: (
        BuildContext context,
        ScrollController controller,
        CustomScrollPhysics physics,
      ) {
        return CustomScrollView(
          physics: physics,
          controller: controller,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(12),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    const Text(
                      'Buy a Super Thanks, which directly supports Harris Craycraft.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Stack(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: thanksNotifier,
                          builder: (context, index, _) {
                            return Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: AppPalette.thanksVariants[index]
                                    .withOpacity(
                                  .1,
                                ),
                                border:
                                    Border.all(color: context.theme.hintColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const AccountAvatar(),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '@josh4500',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: context.theme.hintColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 2.0,
                                                    horizontal: 8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppPalette
                                                        .thanksVariants[index],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      16,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        YTIcons.thanks_filled,
                                                        size: 14,
                                                        color: context
                                                            .theme
                                                            .colorScheme
                                                            .inverseSurface,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        '\$${(index + 1) * 10}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: context
                                                              .theme
                                                              .colorScheme
                                                              .inverseSurface,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                const Text('Thanks'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(YTIcons.edit_outlined, size: 18),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 32,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if (index == 5) {
                      return ValueListenableBuilder(
                        valueListenable: showMoreThanks,
                        builder: (context, show, _) {
                          return CustomActionChip(
                            title: 'More',
                            onTap: () =>
                                showMoreThanks.value = !showMoreThanks.value,
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 16,
                            ),
                            margin: const EdgeInsets.only(right: 8),
                            alignment: Alignment.center,
                            border: show
                                ? null
                                : Border.all(color: context.theme.hintColor),
                            backgroundColor: show
                                ? context.theme.primaryColor
                                : Colors.transparent,
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: show
                                  ? context.theme.colorScheme.inverseSurface
                                  : context.theme.primaryColor,
                            ),
                          );
                        },
                      );
                    }
                    return CustomActionChip(
                      title: index == 5 ? 'More' : '\$ ${(index + 1) * 100}',
                      onTap: () => thanksNotifier.value = index,
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 16,
                      ),
                      margin: const EdgeInsets.only(right: 8),
                      alignment: Alignment.center,
                      backgroundColor: Colors.transparent,
                      border: Border.all(color: context.theme.hintColor),
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.theme.primaryColor,
                      ),
                    );
                  },
                  itemCount: 6,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    ValueListenableBuilder(
                      valueListenable: showMoreThanks,
                      builder: (context, show, _) {
                        return Visibility(
                          visible: show,
                          child: ValueListenableBuilder(
                            valueListenable: thanksNotifier,
                            builder: (context, index, _) {
                              return SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 1.8,
                                  trackShape: CustomTrackShape(),
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ),
                                  thumbColor: AppPalette.thanksVariants[index],
                                  activeTrackColor:
                                      AppPalette.thanksVariants[index],
                                  overlayColor: context.theme.highlightColor,
                                  inactiveTrackColor:
                                      context.theme.highlightColor,
                                  activeTickMarkColor:
                                      context.theme.colorScheme.surface,
                                  inactiveTickMarkColor:
                                      context.theme.colorScheme.surface,
                                ),
                                child: Slider(
                                  value: index + 1,
                                  min: 1,
                                  max: 10,
                                  divisions: 10,
                                  onChanged: (double value) {
                                    thanksNotifier.value = value.floor();
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Spacer(),
                    Text.rich(
                      TextSpan(
                        text: '',
                        children: [
                          const TextSpan(
                              text:
                                  'As an added bonus, the above public comment will be published on your behalf (subject to Community Guidelines). '),
                          TextSpan(
                            text: 'Learn more',
                            style: TextStyle(
                              color: context.theme.primaryColor,
                            ),
                          ),
                          const TextSpan(
                              text:
                                  '. By continuing, yo verify that you are at least 18 years old and agree to '),
                          TextSpan(
                            text: 'these terms',
                            style: TextStyle(
                              color: context.theme.primaryColor,
                            ),
                          ),
                          const TextSpan(text: '.'),
                        ],
                        style: TextStyle(
                          fontSize: 12,
                          color: context.theme.hintColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomActionChip(
                      title: 'Buy and Send',
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.center,
                      backgroundColor: context.theme.primaryColor,
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.theme.colorScheme.inverseSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      baseHeight: 1 - kAvgVideoViewPortHeight,
      showDragIndicator: true,
    );
  }
}

class CustomTrackShape extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    // Define the overall slider track height
    const double trackHeight = 4.0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final Paint activePaint = Paint()..color = sliderTheme.activeTrackColor!;
    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!;

    // Custom thickness for active and inactive parts
    const double activeTrackHeight = 2.0;
    const double inactiveTrackHeight = 2.0;

    final Rect activeRect = Rect.fromLTRB(
      offset.dx,
      thumbCenter.dy - activeTrackHeight / 2,
      thumbCenter.dx,
      thumbCenter.dy + activeTrackHeight / 2,
    );

    final Rect inactiveRect = Rect.fromLTRB(
      thumbCenter.dx,
      thumbCenter.dy - inactiveTrackHeight / 2,
      offset.dx + parentBox.size.width,
      thumbCenter.dy + inactiveTrackHeight / 2,
    );

    context.canvas.drawRect(activeRect, activePaint);
    context.canvas.drawRect(inactiveRect, inactivePaint);
  }
}

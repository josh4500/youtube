// MIT License
//
// Copyright (c) 2024 Ajibola Akinmosin (https://github.com/josh4500)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/core/constants/constants.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/widgets.dart';
import 'package:youtube_clone/presentation/widgets/persistent_header_delegate.dart';

import 'widgets/mini_player.dart';
import 'widgets/player.dart';
import 'widgets/video_actions.dart';
import 'widgets/video_comment_section.dart';
import 'widgets/video_comment_sheet.dart';
import 'widgets/video_description_section.dart';
import 'widgets/video_description_sheet.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final double height;
  const PlayerScreen({super.key, required this.height});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  final _infoScrollController = ScrollController();
  final _infoScrollPhysics = const CustomScrollableScrollPhysics(tag: 'info');

  late final ValueNotifier<double> additionalHeightNotifier;

  late final ValueNotifier<double> marginNotifier;
  late final ValueNotifier<double> heightNotifier;
  late final ValueNotifier<double> widthNotifier;

  double get screenWidth => MediaQuery.sizeOf(context).width;
  double get screenHeight => widget.height;

  double get heightRatio {
    return avgVideoViewPortHeight;
  }

  double get videoViewHeight {
    // TODO: Determine value from Video Size either avg or max height
    return avgVideoViewPortHeight;
  }

  double get maxAdditionalHeight {
    return (screenHeight * (1 - avgVideoViewPortHeight) / 1.5);
  }

  double get additionalHeight => additionalHeightNotifier.value;

  @override
  void initState() {
    super.initState();
    additionalHeightNotifier = ValueNotifier<double>(clampDouble(
      ((screenHeight * (1 - avgVideoViewPortHeight)) -
          (screenHeight * (1 - videoViewHeight))),
      0,
      maxAdditionalHeight,
    ));

    marginNotifier = ValueNotifier<double>(0);
    heightNotifier = ValueNotifier<double>(1);
    widthNotifier = ValueNotifier<double>(1);

    if (additionalHeight > 0) {
      _infoScrollPhysics.canScroll(false);
    }

    heightNotifier.addListener(() {
      _recomputeDraggableHeight(heightNotifier.value);
    });

    _descDraggableController.addListener(() {
      if (_descDraggableController.size == 0) _descIsOpened = false;
    });

    _commentDraggableController.addListener(() {
      if (_commentDraggableController.size == 0) _commentIsOpened = false;
    });
  }

  @override
  void dispose() {
    _commentDraggableController.dispose();
    _descDraggableController.dispose();
    _showCommentDraggable.dispose();
    _showDescDraggable.dispose();
    _replyIsOpenedNotifier.dispose();
    _transcriptNotifier.dispose();
    _infoScrollController.dispose();
    super.dispose();
  }

  bool _expanded = false;

  bool? _isPlayerDraggingDown;
  bool _preventPlayerDragUp = false;
  bool _preventPlayerDragDown = false;
  bool _allowInfoDrag = true;

  void _hideControls() {
    ref.read(playerRepositoryProvider).hideControls();
  }

  void _showControls() {
    ref.read(playerRepositoryProvider).showControls();
  }

  Future<void> _onTapPlayer() async {
    if (heightNotifier.value == 1) {
      _showControls();
    }

    heightNotifier.value = 1;
    widthNotifier.value = 1;

    if (additionalHeight < maxAdditionalHeight) {
      if (videoViewHeight != heightRatio) {
        if (_commentIsOpened) {
          _commentDraggableController.animateTo(
            ((screenHeight * heightRatio) + additionalHeight) / screenHeight,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeIn,
          );
        }

        if (_descIsOpened) {
          _descDraggableController.animateTo(
            ((screenHeight * heightRatio) + additionalHeight) / screenHeight,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeIn,
          );
        }

        additionalHeightNotifier.value = maxAdditionalHeight;
      }
    }
  }

  void _onDragPlayer(DragUpdateDetails details) {
    if (_expanded) {
      if (details.delta.dy < -1) {
        if (marginNotifier.value > 0) {
          _preventPlayerDragUp = true;
          marginNotifier.value = clampDouble(
            marginNotifier.value + details.delta.dy,
            0,
            (screenHeight - (screenHeight * heightRatio)),
          );
        } else if (!_preventPlayerDragUp) {
          _preventPlayerDragDown = true;
          additionalHeightNotifier.value = clampDouble(
            additionalHeightNotifier.value + details.delta.dy,
            maxAdditionalHeight,
            screenHeight * (1 - heightRatio),
          );
        }
      } else {
        if (!_preventPlayerDragDown) {
          marginNotifier.value = clampDouble(
            marginNotifier.value + details.delta.dy,
            0,
            (screenHeight - (screenHeight * heightRatio)),
          );
        } else {
          additionalHeightNotifier.value = clampDouble(
            additionalHeightNotifier.value + details.delta.dy,
            maxAdditionalHeight,
            screenHeight * (1 - heightRatio),
          );
        }
      }
    } else {
      _isPlayerDraggingDown ??= details.delta.dy > 0;
      if (_isPlayerDraggingDown ?? false) {
        heightNotifier.value = clampDouble(
          heightNotifier.value - (details.delta.dy / screenHeight),
          minVideoViewPortHeight,
          1,
        );

        widthNotifier.value = clampDouble(
          heightNotifier.value / heightRatio,
          0.33,
          1,
        );
      }

      if (heightNotifier.value < 1) {
        _hideControls();
      }
    }
  }

  void _onDragPlayerEnd(DragEndDetails details) {
    _preventPlayerDragUp = false;
    _preventPlayerDragDown = false;

    if (_expanded) {
      if (additionalHeight > maxAdditionalHeight) {
        _expanded = true;
        additionalHeightNotifier.value =
            screenHeight - (screenHeight * heightRatio);
      } else {
        _expanded = false;
        if (videoViewHeight <= heightRatio) {
          additionalHeightNotifier.value = 0;
        } else {
          additionalHeightNotifier.value = maxAdditionalHeight;
        }
      }

      if (marginNotifier.value >
          (screenHeight - (screenHeight * heightRatio)) / 4) {
        _expanded = false;

        if (videoViewHeight <= heightRatio) {
          additionalHeightNotifier.value = 0;
        } else {
          additionalHeightNotifier.value = maxAdditionalHeight;
        }
      }

      marginNotifier.value = 0;
      _infoScrollPhysics.canScroll(true);
    } else {
      if (_isPlayerDraggingDown ?? false) {
        final latestHeightVal = heightNotifier.value;
        final velocityY = details.velocity.pixelsPerSecond.dy;

        if (latestHeightVal >= 0.5) {
          heightNotifier.value = velocityY >= 200 ? minVideoViewPortHeight : 1;
          widthNotifier.value = velocityY >= 200 ? 0.33 : 1;
        } else {
          heightNotifier.value = velocityY <= -150 ? 1 : minVideoViewPortHeight;
          widthNotifier.value = velocityY <= -150 ? 1 : 0.33;
        }
      }

      if (heightNotifier.value == 1) {
        _isPlayerDraggingDown = null;
      }

      _infoScrollPhysics.canScroll(true);
    }
  }

  // TODO: Apply to PlayerState
  // void _closeExpandedAndFullScreen() {
  //   if (_expanded) {
  //     _expanded = false;
  //     _infoScrollPhysics.canScroll(true);
  //     additionalHeightNotifier.value = 0;
  //   }
  // }

  void _onDragInfo(PointerMoveEvent event) {
    if (_infoScrollController.offset == 0 ||
        (videoViewHeight > heightRatio && event.delta.dy < 0)) {
      if (_allowInfoDrag) {
        _infoScrollPhysics.canScroll(false);
        // TODO: Do with velocity
        additionalHeightNotifier.value = clampDouble(
          additionalHeightNotifier.value + event.delta.dy,
          0,
          screenHeight * (1 - heightRatio),
        );
      }
    }

    if (_allowInfoDrag) {
      _hideControls();
    }

    if (event.delta.dy < 0 && _infoScrollController.offset > 0) {
      _allowInfoDrag = false;
    }

    if (additionalHeightNotifier.value == 0) {
      _infoScrollPhysics.canScroll(true);
    }
  }

  void _onDragInfoUp(PointerUpEvent event) {
    if (additionalHeight > 0 && _allowInfoDrag) {
      if (additionalHeight > maxAdditionalHeight) {
        _expanded = true;
        additionalHeightNotifier.value =
            screenHeight - (screenHeight * heightRatio);
      } else {
        if (videoViewHeight <= heightRatio) {
          additionalHeightNotifier.value = 0;
        }
      }
    }

    if (additionalHeightNotifier.value == 0) {
      _expanded = false;
      _infoScrollPhysics.canScroll(true);
    }

    if (_infoScrollController.offset == 0) {
      _allowInfoDrag = true;
    }
  }

  // Video Comment Sheet
  bool _commentIsOpened = false;
  final _showCommentDraggable = ValueNotifier(false);
  final _commentDraggableController = DraggableScrollableController();
  final _replyIsOpenedNotifier = ValueNotifier<bool>(false);

  void _recomputeDraggableHeight(double value) {
    if (_commentIsOpened) {
      if (heightNotifier.value == minVideoViewPortHeight) {
        _commentDraggableController.jumpTo(0);
      } else {
        _commentDraggableController.jumpTo(
          clampDouble(value - minVideoViewPortHeight, 0, (1 - heightRatio)),
        );
      }
    }
    if (_descIsOpened) {
      if (heightNotifier.value == minVideoViewPortHeight) {
        _descDraggableController.jumpTo(0);
      } else {
        _descDraggableController.jumpTo(
          clampDouble(value - minVideoViewPortHeight, 0, (1 - heightRatio)),
        );
      }
    }
  }

  void _openCommentSheet() async {
    _commentIsOpened = true;
    final wait = !_showCommentDraggable.value;
    _showCommentDraggable.value = true;

    if (wait) await Future.delayed(const Duration(milliseconds: 150));
    if (videoViewHeight != heightRatio && additionalHeight > 0) {
      additionalHeightNotifier.value = 0;
    }

    _commentDraggableController.animateTo(
      (1 - heightRatio),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInCubic,
    );
  }

  void _closeCommentSheet() {
    if (_replyIsOpenedNotifier.value) {
      _replyIsOpenedNotifier.value = false;
      return;
    }

    _commentIsOpened = false;
    _commentDraggableController.animateTo(
      0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
    );
  }

  // Video Description Sheet
  bool _descIsOpened = false;
  final _showDescDraggable = ValueNotifier(false);
  final _descDraggableController = DraggableScrollableController();
  final _transcriptNotifier = ValueNotifier<bool>(false);

  void _openDescSheet() async {
    _descIsOpened = true;
    final wait = !_showCommentDraggable.value;
    _showDescDraggable.value = true;

    if (wait) await Future.delayed(const Duration(milliseconds: 150));
    if (videoViewHeight != heightRatio && additionalHeight > 0) {
      additionalHeightNotifier.value = 0;
    }
    _descDraggableController.animateTo(
      (1 - heightRatio),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInCubic,
    );
  }

  void _closeDescSheet() {
    if (_transcriptNotifier.value) {
      _transcriptNotifier.value = false;
      return;
    }

    _descIsOpened = false;
    _descDraggableController.animateTo(
      0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: heightNotifier,
      builder: (context, value, childWidget) {
        return SizedBox(
          height: screenHeight * heightNotifier.value,
          width: double.infinity,
          child: childWidget,
        );
      },
      child: Material(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                  valueListenable: heightNotifier,
                  builder: (context, heightValue, miniPlayer) {
                    return ValueListenableBuilder(
                      valueListenable: additionalHeightNotifier,
                      builder: (context, addHeightValue, childWidget) {
                        return SizedBox(
                          height: heightNotifier.value < 1
                              ? null
                              : screenHeight * heightRatio + addHeightValue,
                          child: GestureDetector(
                            onTap: _onTapPlayer,
                            onVerticalDragUpdate: _onDragPlayer,
                            onVerticalDragEnd: _onDragPlayerEnd,
                            behavior: HitTestBehavior.opaque,
                            child: ValueListenableBuilder(
                              valueListenable: widthNotifier,
                              builder: (context, widthValue, _) {
                                return Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: MiniPlayer(
                                        opacity: 1,
                                        space: screenWidth * widthValue,
                                        height: screenHeight *
                                            minVideoViewPortHeight,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: ValueListenableBuilder(
                                        valueListenable: marginNotifier,
                                        builder: (context, marginValue, _) {
                                          return Container(
                                            margin: EdgeInsets.only(
                                              top: marginValue,
                                              left: marginValue > 0 ? 10 : 0,
                                              right: marginValue > 0 ? 10 : 0,
                                            ),
                                            constraints: addHeightValue > 0
                                                ? null
                                                : BoxConstraints(
                                                    maxHeight: screenHeight *
                                                        heightRatio,
                                                    minHeight: screenHeight *
                                                        minVideoViewPortHeight,
                                                  ),
                                            height: screenHeight * heightValue,
                                            width: screenWidth * widthValue,
                                            child: const PlayerView(),
                                          );
                                        },
                                      ),
                                    ),
                                    if (heightValue == minVideoViewPortHeight)
                                      Positioned(
                                        left: 0,
                                        bottom: 0,
                                        width: screenWidth,
                                        child: const PlaybackProgress(),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                Flexible(
                  child: Listener(
                    onPointerMove: _onDragInfo,
                    onPointerUp: _onDragInfoUp,
                    child: ScrollConfiguration(
                      behavior: const NoOverScrollGlowBehavior(),
                      child: CustomScrollView(
                        physics: _infoScrollPhysics,
                        controller: _infoScrollController,
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                VideoDescriptionSection(
                                  onTap: _openDescSheet,
                                ),
                                const VideoActions(),
                                VideoCommentSection(
                                  onTap: _openCommentSheet,
                                ),
                              ],
                            ),
                          ),
                          SliverPersistentHeader(
                            pinned: true,
                            floating: true,
                            delegate: SlidingHeaderDelegate(
                              minHeight: 0,
                              maxHeight: 48,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Material(
                                  child: DynamicTab(
                                    initialIndex: 0,
                                    leadingWidth: 8,
                                    options: <String>[
                                      'All',
                                      'Something',
                                      'Related',
                                      'Recently uploaded',
                                      'Watched',
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: ViewableVideoContent(),
                          ),
                          const SliverToBoxAdapter(
                            child: ViewableVideoContent(),
                          ),
                          const SliverToBoxAdapter(
                            child: ViewableVideoContent(),
                          ),
                          const SliverToBoxAdapter(
                            child: ViewableVideoContent(),
                          ),
                          const SliverToBoxAdapter(
                            child: ViewableVideoContent(),
                          ),
                          const SliverToBoxAdapter(
                            child: ViewableVideoContent(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ValueListenableBuilder(
              valueListenable: _showCommentDraggable,
              builder: (context, show, childWidget) {
                if (!show) return const SizedBox();
                return DraggableScrollableSheet(
                  snap: true,
                  minChildSize: 0,
                  maxChildSize: 1,
                  initialChildSize: 0,
                  snapSizes: const [0.0, (1 - avgVideoViewPortHeight)],
                  shouldCloseOnMinExtent: false,
                  controller: _commentDraggableController,
                  snapAnimationDuration: const Duration(milliseconds: 300),
                  builder: (context, controller) {
                    return VideoCommentsSheet(
                      controller: controller,
                      maxHeight: avgVideoViewPortHeight,
                      closeComment: _closeCommentSheet,
                      replyNotifier: _replyIsOpenedNotifier,
                      draggableController: _commentDraggableController,
                    );
                  },
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: _showDescDraggable,
              builder: (context, show, childWidget) {
                if (!show) return const SizedBox();
                return DraggableScrollableSheet(
                  snap: true,
                  minChildSize: 0,
                  maxChildSize: 1,
                  initialChildSize: 0,
                  snapSizes: const [0.0, (1 - avgVideoViewPortHeight)],
                  shouldCloseOnMinExtent: false,
                  controller: _descDraggableController,
                  snapAnimationDuration: const Duration(milliseconds: 300),
                  builder: (context, controller) {
                    return VideoDescriptionSheet(
                      controller: controller,
                      closeDescription: _closeDescSheet,
                      transcriptNotifier: _transcriptNotifier,
                      draggableController: _descDraggableController,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

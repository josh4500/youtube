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
import 'package:youtube_clone/presentation/screens/player/widgets/video_comment_sheet.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/video_comment_section.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/player.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/video_actions.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/video_description_sheet.dart';
import 'package:youtube_clone/presentation/widgets/custom_scroll_physics.dart';
import 'package:youtube_clone/presentation/widgets/dynamic_tab.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/viewable/viewable_video_content.dart';

import 'widgets/mini_player.dart';
import 'widgets/video_description_section.dart';

class Pair<T> {
  final double left;
  final double right;

  const Pair(this.left, this.right);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair &&
          runtimeType == other.runtimeType &&
          left == other.left &&
          right == other.right;

  @override
  int get hashCode => left.hashCode ^ right.hashCode;
}

class PlayerScreen extends StatefulWidget {
  final double? height;
  final double? width;
  const PlayerScreen({super.key, this.height, this.width});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final _infoScrollController = ScrollController();
  final _infoScrollPhysics = const CustomScrollableScrollPhysics();
  bool _listenInfoPointer = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _draggableController.dispose();
    _draggableControllerDesc.dispose();
    _showCommentDraggable.dispose();
    _showDescDraggable.dispose();
    _replyIsOpenedNotifier.dispose();
    _transcriptNotifier.dispose();
    _infoScrollController.dispose();
    super.dispose();
  }

  final additionalHeightNotifier = ValueNotifier<double>(0);

  final marginNotifier = ValueNotifier<double>(0);
  final heightNotifier = ValueNotifier<double>(1);
  final widthNotifier = ValueNotifier<double>(1);

  double get screenWidth => widget.width ?? MediaQuery.sizeOf(context).width;
  double get screenHeight => widget.height ?? MediaQuery.sizeOf(context).height;

  bool _expanded = false;

  void _onTapPlayer() {
    heightNotifier.value = 1;
    widthNotifier.value = 1;
  }

  bool? _dragDown;

  void _onDragPlayer(DragUpdateDetails details) {
    if (_expanded) {
      if (details.delta.dy < -1) {
        marginNotifier.value = 0;
        additionalHeightNotifier.value += details.delta.dy;
      } else {
        marginNotifier.value = clampDouble(
          marginNotifier.value + details.delta.dy,
          0,
          (screenHeight - (screenHeight * 0.28)),
        );
      }
    } else {
      _dragDown ??= details.delta.dy > 0;
      if (_dragDown ?? false) {
        final posOffset = details.globalPosition;
        final computeValue = (screenHeight - posOffset.dy) / screenHeight;

        heightNotifier.value = clampDouble(
          computeValue,
          0.065,
          1,
        );

        widthNotifier.value = clampDouble(
          heightNotifier.value / 0.28,
          0.33,
          1,
        );
      }

      _recomputeDraggableHeight(heightNotifier.value);
    }
  }

  void _onDragPlayerEnd(DragEndDetails details) {
    if (_expanded) {
      final addHval = additionalHeightNotifier.value;
      if ((addHval + (screenHeight * 0.28)) > screenHeight * 0.55) {
        _expanded = true;
        additionalHeightNotifier.value = screenHeight - (screenHeight * 0.28);
      } else {
        _expanded = false;
        _infoScrollPhysics.canScroll(true);
        additionalHeightNotifier.value = 0;
      }
      if (marginNotifier.value > (screenHeight - (screenHeight * 0.28)) / 4) {
        _expanded = false;
        _infoScrollPhysics.canScroll(true);
        additionalHeightNotifier.value = 0;
      }

      marginNotifier.value = 0;
    } else {
      if (_dragDown ?? false) {
        final latestHeightVal = heightNotifier.value;
        final velocityY = details.velocity.pixelsPerSecond.dy;

        if (latestHeightVal >= 0.5) {
          heightNotifier.value = velocityY >= 200 ? 0.065 : 1;
          widthNotifier.value = velocityY >= 200 ? 0.33 : 1;
        } else {
          heightNotifier.value = velocityY <= -150 ? 1 : 0.065;
          widthNotifier.value = velocityY <= -150 ? 1 : 0.33;
        }
      }

      if (heightNotifier.value == 1) {
        _dragDown = null;
      }
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
    if (_infoScrollController.offset == 0) {
      if (_listenInfoPointer) {
        _infoScrollPhysics.canScroll(false);
        // TODO: Do with velocity
        additionalHeightNotifier.value = clampDouble(
          additionalHeightNotifier.value + event.delta.dy,
          0,
          screenHeight * 0.72,
        );
      }
    }

    if (event.delta.dy < 0 && _infoScrollController.offset > 0) {
      _listenInfoPointer = false;
    }
  }

  void _onDragInfoUp(PointerUpEvent event) {
    final addHval = additionalHeightNotifier.value;
    if (addHval > 0 && _listenInfoPointer) {
      if ((addHval + (screenHeight * 0.28)) > screenHeight * 0.55) {
        _expanded = true;
        additionalHeightNotifier.value = screenHeight - (screenHeight * 0.28);
      } else {
        _expanded = false;
        _infoScrollPhysics.canScroll(true);
        additionalHeightNotifier.value = 0;
      }
    }

    if (addHval == 0) {
      _expanded = false;
      _infoScrollPhysics.canScroll(true);
    }

    if (_infoScrollController.offset == 0) {
      _listenInfoPointer = true;
    }
  }

  // Video Comment Sheet
  bool _commentIsOpened = false;
  final _showCommentDraggable = ValueNotifier(false);
  final _draggableController = DraggableScrollableController();
  final _replyIsOpenedNotifier = ValueNotifier<bool>(false);

  void _recomputeDraggableHeight(double value) {
    if (_commentIsOpened) {
      _draggableController.jumpTo(clampDouble(value - 0.065, 0, 0.72));
    }
    if (_descIsOpened) {
      _draggableControllerDesc.jumpTo(clampDouble(value - 0.065, 0, 0.72));
    }
  }

  void _openCommentSheet() async {
    _commentIsOpened = true;
    final wait = !_showCommentDraggable.value;
    _showCommentDraggable.value = true;

    if (wait) await Future.delayed(const Duration(milliseconds: 150));

    _draggableController.animateTo(
      0.72,
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
    _draggableController.animateTo(
      0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
    );
  }

  // Video Description Sheet
  bool _descIsOpened = false;
  final _showDescDraggable = ValueNotifier(false);
  final _draggableControllerDesc = DraggableScrollableController();
  final _transcriptNotifier = ValueNotifier<bool>(false);

  void _openDescSheet() async {
    _descIsOpened = true;
    final wait = !_showCommentDraggable.value;
    _showDescDraggable.value = true;

    if (wait) await Future.delayed(const Duration(milliseconds: 150));

    _draggableControllerDesc.animateTo(
      0.72,
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
    _draggableControllerDesc.animateTo(
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
                              : screenHeight * 0.28 + addHeightValue,
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
                                      alignment: Alignment.center,
                                      child: MiniPlayer(
                                        opacity: 1,
                                        space: screenWidth * widthValue,
                                        height: screenHeight * 0.065,
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
                                                    maxHeight:
                                                        screenHeight * 0.28,
                                                    minHeight:
                                                        screenHeight * 0.065,
                                                  ),
                                            height: screenHeight * heightValue,
                                            width: screenWidth * widthValue,
                                            child: const Player(),
                                          );
                                        },
                                      ),
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
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Listener(
                        onPointerMove: _onDragInfo,
                        onPointerUp: _onDragInfoUp,
                        child: ValueListenableBuilder(
                          valueListenable: heightNotifier,
                          builder: (context, value, childWidget) {
                            return Container(
                              constraints: BoxConstraints(
                                maxHeight:
                                    value <= 0.28 ? 0 : 552.0485714285714,
                              ),
                              child: childWidget,
                            );
                          },
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
                                const SliverAppBar(
                                  automaticallyImplyLeading: false,
                                  pinned: true,
                                  elevation: 0,
                                  toolbarHeight: 24,
                                  expandedHeight: 0,
                                  flexibleSpace: SizedBox(
                                    height: 48,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 4.0,
                                      ),
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
                  snapSizes: const [0.0, 0.72],
                  shouldCloseOnMinExtent: false,
                  controller: _draggableController,
                  snapAnimationDuration: const Duration(milliseconds: 300),
                  builder: (context, controller) {
                    return VideoCommentsSheet(
                      controller: controller,
                      closeComment: _closeCommentSheet,
                      replyNotifier: _replyIsOpenedNotifier,
                      draggableController: _draggableController,
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
                  snapSizes: const [0.0, 0.72],
                  shouldCloseOnMinExtent: false,
                  controller: _draggableControllerDesc,
                  snapAnimationDuration: const Duration(milliseconds: 300),
                  builder: (context, controller) {
                    return VideoDescriptionSheet(
                      controller: controller,
                      closeDescription: _closeDescSheet,
                      transcriptNotifier: _transcriptNotifier,
                      draggableController: _draggableControllerDesc,
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

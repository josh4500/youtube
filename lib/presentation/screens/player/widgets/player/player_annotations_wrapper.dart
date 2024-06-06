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

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/theme/device_theme.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../annotations/annotations_notification.dart';
import '../annotations/video_card_teaser.dart';
import '../annotations/video_channel_watermark.dart';
import '../annotations/video_product.dart';
import '../annotations/video_suggestion.dart';

class PlayerAnnotationsWrapper extends StatefulWidget {
  const PlayerAnnotationsWrapper({
    super.key,
    this.hideGraphicsNotifier,
    required this.child,
  });
  final Widget child;
  final ValueNotifier<bool>? hideGraphicsNotifier;

  @override
  State<PlayerAnnotationsWrapper> createState() =>
      _PlayerAnnotationsWrapperState();
}

class _PlayerAnnotationsWrapperState extends State<PlayerAnnotationsWrapper> {
  final AnnotationsNotifier listenable = AnnotationsNotifier();

  @override
  void initState() {
    super.initState();
    if (widget.hideGraphicsNotifier?.value == true) {
      listenable.pauseVisuals(notify: false);
    }

    widget.hideGraphicsNotifier?.addListener(changeCallback);
  }

  @override
  void dispose() {
    widget.hideGraphicsNotifier?.removeListener(changeCallback);
    listenable.dispose();
    super.dispose();
  }

  void changeCallback() {
    if (widget.hideGraphicsNotifier?.value == true) {
      listenable.pauseVisuals();
    } else {
      listenable.continueVisuals();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: listenable,
      builder: (BuildContext context, Widget? childWidget) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            childWidget!,
            if (listenable.includesPromotions)
              AnnotationVisibility(
                visible: listenable.showVisuals,
                alwaysShow: true,
                hideDuration: const Duration(seconds: 10),
                alignment: Alignment.topLeft,
                child: const IncludePromotionButton(margin: EdgeInsets.all(8)),
              ),
            AnnotationVisibility(
              visible: listenable.showVisuals,
              alignment: Alignment.topRight,
              showAt: const Duration(seconds: 6),
              child: const VideoCardTeaser(),
            ),
            Positioned.fill(
              child: Consumer(
                builder: (context, ref, child) {
                  final playerViewState = ref.watch(playerViewStateProvider);
                  return AnnotationVisibility(
                    visible: listenable.showVisuals,
                    alignment: Alignment.bottomLeft,
                    visibleControlAlignment: Alignment.lerp(
                      Alignment.centerLeft,
                      Alignment.bottomLeft,
                      context.orientation.isPortrait
                          ? playerViewState.isExpanded
                              ? 0.9
                              : 0.75
                          : 0.45,
                    ),
                    child: const VideoProduct(),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: AnnotationVisibility(
                visible: listenable.showVisuals,
                alignment: Alignment.bottomRight,
                child: const VideoChannelWatermark(),
              ),
            ),
            // Positioned.fill(
            //   child: AnnotationVisibility(
            //     visible: listenable.showVisuals,
            //     alwaysShow: true,
            //     child: const VideoSuggestion(),
            //   ),
            // ),
          ],
        );
      },
      child: widget.child,
    );
  }
}

class AnnotationsNotifier extends ChangeNotifier {
  bool get includesPromotions => true;
  bool _paused = false;
  bool get paused => _paused;
  bool get showVisuals => _paused == false;

  void pauseVisuals({bool notify = true}) {
    final prev = _paused;
    _paused = true;
    if (_paused != prev && notify) notifyListeners();
  }

  void continueVisuals() {
    final prev = _paused;
    _paused = false;
    if (_paused != prev) notifyListeners();
  }
}

class AnnotationVisibility extends ConsumerStatefulWidget {
  const AnnotationVisibility({
    super.key,
    this.showAt,
    this.alwaysShow = false,
    this.hideDuration = const Duration(seconds: 5),
    this.alignment = Alignment.center,
    this.visibleControlAlignment,
    required this.visible,
    required this.child,
  });

  /// Duration at which child is shown
  final Duration? showAt;

  /// Duration at which child will be hidden after shown
  final Duration hideDuration;

  /// Whether to always show child
  ///
  /// NOTE: Will still hide child when it reaches [hideDuration]
  final bool alwaysShow;

  /// Whether infographic is to be shown
  final bool visible;

  /// Alignment of infographic
  final Alignment alignment;

  /// Alignment when Player Controls are visible
  final Alignment? visibleControlAlignment;

  final Widget child;

  @override
  ConsumerState<AnnotationVisibility> createState() =>
      _AnnotationVisibilityState();
}

class _AnnotationVisibilityState extends ConsumerState<AnnotationVisibility>
    with TickerProviderStateMixin {
  /// Controller to animate opacity to visibility
  late final AnimationController visibilityController;
  late final Animation<double> visibilityAnimation;

  /// Controller to animate alignment when Player Controls are shown
  ///
  /// Takes effect when [widget.visibleControlAlignment] is not null
  late final AnimationController alignmentController;

  /// Hides child when Player Controls are shown
  ///
  /// Takes effect when [widget.visibleControlAlignment] is null
  final controlVisibilityNotifier = ValueNotifier<bool>(false);

  /// Notifier to hide the child
  final showNotifier = ValueNotifier<bool>(false);

  /// Duration listener for current video
  StreamSubscription<Duration>? _videoDurationSubscription;

  /// Player Signal listener
  StreamSubscription<PlayerSignal>? _playerSignalSubscription;

  bool hiddenPermanently = false;
  bool hiddenTemporary = false;
  Timer? permanentTimer;

  @override
  void initState() {
    super.initState();
    showNotifier.value = widget.visible && widget.alwaysShow;
    visibilityController = AnimationController(
      vsync: this,
      value: showNotifier.value || widget.alwaysShow ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 350),
    );
    visibilityAnimation = CurvedAnimation(
      parent: visibilityController,
      curve: Curves.easeInCubic,
    );

    alignmentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ref.read(playerViewStateProvider).showControls) {
      controlVisibilityNotifier.value = false;
      if (widget.visibleControlAlignment != null) alignmentController.forward();
    } else {
      controlVisibilityNotifier.value = !hiddenPermanently && !hiddenTemporary;
      if (widget.visibleControlAlignment != null) alignmentController.reverse();
    }

    final playerRepo = ref.read(playerRepositoryProvider);
    _playerSignalSubscription ??= playerRepo.playerSignalStream.listen(
      (event) {
        if (event == PlayerSignal.showControls) {
          controlVisibilityNotifier.value = false;
          if (widget.visibleControlAlignment != null) {
            alignmentController.forward();
          }
        } else if (event == PlayerSignal.hideControls) {
          controlVisibilityNotifier.value =
              !hiddenPermanently && !hiddenTemporary;

          if (widget.visibleControlAlignment != null) {
            alignmentController.reverse();
          }
        }
      },
    );

    if (widget.alwaysShow && widget.showAt == null && !hiddenPermanently) {
      permanentTimer ??= Timer(widget.hideDuration, permanentHide);
    } else if (widget.showAt != null) {
      _videoDurationSubscription ??= playerRepo.positionStream.listen(
        (event) {
          final showing = showNotifier.value;
          if (event.inSeconds == widget.showAt?.inSeconds) {
            hiddenTemporary = false;

            final isMinimized = ref.read(playerViewStateProvider).isMinimized;
            // Avoid showing when minimized
            controlVisibilityNotifier.value = !isMinimized;

            showNotifier.value = true;
            visibilityController.forward();
          } else if (showing &&
              event.inSeconds ==
                  (widget.showAt?.inSeconds ?? 0) +
                      widget.hideDuration.inSeconds) {
            temporaryHide();
          } else if (event.inSeconds < (widget.showAt?.inSeconds ?? 0)) {
            hiddenTemporary = false;
            showNotifier.value = false;
          }
        },
      );
    }
  }

  @override
  void didUpdateWidget(covariant AnnotationVisibility oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.visible != widget.visible) {
      showNotifier.value =
          widget.visible && !hiddenPermanently && !hiddenTemporary;
    }
  }

  @override
  void dispose() {
    permanentTimer?.cancel();
    showNotifier.dispose();
    alignmentController.dispose();
    visibilityController.dispose();
    controlVisibilityNotifier.dispose();

    _playerSignalSubscription?.cancel();
    _videoDurationSubscription?.cancel();
    super.dispose();
  }

  void permanentHide() {
    hiddenPermanently = true;
    visibilityController.reverse().then((value) {
      showNotifier.value = false;
      controlVisibilityNotifier.value = false;
    });
    _playerSignalSubscription?.cancel();
    _videoDurationSubscription?.cancel();
  }

  void temporaryHide() {
    hiddenTemporary = true;
    visibilityController.reverse().then((value) {
      showNotifier.value = false;
      controlVisibilityNotifier.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = ValueListenableBuilder(
      valueListenable: showNotifier,
      builder: (BuildContext context, bool visible, Widget? childWidget) {
        return AnimatedBuilder(
          animation: visibilityAnimation,
          builder: (BuildContext context, Widget? childWidget) {
            return Visibility(
              maintainState: true,
              maintainAnimation: true,
              visible: visibilityAnimation.value != 0 && visible,
              child: Opacity(
                opacity: visibilityAnimation.value,
                child: childWidget,
              ),
            );
          },
          child: NotificationListener<AnnotationsNotification>(
            onNotification: (AnnotationsNotification notification) {
              if (notification is CloseAnnotationsNotification) {
                (widget.showAt != null) ? temporaryHide() : permanentHide();
              }
              return true;
            },
            child: widget.child,
          ),
        );
      },
    );

    if (widget.visibleControlAlignment != null &&
        widget.visibleControlAlignment != widget.alignment) {
      return AlignTransition(
        alignment: AlignmentTween(
          begin: widget.alignment,
          end: widget.visibleControlAlignment ?? widget.alignment,
        ).animate(alignmentController),
        child: child,
      );
    }

    return ValueListenableBuilder(
      valueListenable: controlVisibilityNotifier,
      builder: (BuildContext context, bool visible, Widget? childWidget) {
        return Visibility(
          visible: visible,
          child: Align(
            alignment: widget.alignment,
            child: child,
          ),
        );
      },
    );
  }
}

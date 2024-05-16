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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/infographics/infographics_notification.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../providers/player_view_state_provider.dart';
import '../infographics/video_card_teaser.dart';
import '../infographics/video_product.dart';

class PlayerInfographicsWrapper extends StatefulWidget {
  const PlayerInfographicsWrapper({
    super.key,
    this.show = false,
    required this.child,
  });
  final Widget child;
  final bool show;

  @override
  State<PlayerInfographicsWrapper> createState() =>
      _PlayerInfographicsWrapperState();
}

class _PlayerInfographicsWrapperState extends State<PlayerInfographicsWrapper> {
  final InfographicsListenable listenable = InfographicsListenable();

  @override
  void initState() {
    super.initState();
    if (widget.show == false) listenable.pauseVisuals(notify: false);
  }

  @override
  void didUpdateWidget(covariant PlayerInfographicsWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.show != widget.show) {
      widget.show ? listenable.continueVisuals() : listenable.pauseVisuals();
    }
  }

  @override
  void dispose() {
    listenable.dispose();
    super.dispose();
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
              InfographicVisibility(
                visible: listenable.showVisuals,
                alwaysShow: true,
                alignment: Alignment.topLeft,
                child: const IncludePromotionButton(margin: EdgeInsets.all(8)),
              ),
            InfographicVisibility(
              visible: listenable.showVisuals,
              alignment: Alignment.topRight,
              child: const VideoCardTeaser(),
            ),
            Positioned.fill(
              child: InfographicVisibility(
                visible: listenable.showVisuals,
                alignment: Alignment.bottomLeft,
                visibleControlAlignment: Alignment.lerp(
                  Alignment.centerLeft,
                  Alignment.bottomLeft,
                  0.65,
                ),
                child: const VideoProduct(),
              ),
            ),
          ],
        );
      },
      child: widget.child,
    );
  }
}

class InfographicsListenable extends ChangeNotifier {
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

class InfographicVisibility extends ConsumerStatefulWidget {
  const InfographicVisibility({
    super.key,
    this.showOn,
    this.alwaysShow = false,
    this.hideDuration = const Duration(seconds: 5),
    this.alignment = Alignment.center,
    this.visibleControlAlignment,
    required this.visible,
    required this.child,
  });

  final Duration? showOn;
  final Duration hideDuration;

  final bool alwaysShow;

  /// Whether infographic is to be shown
  final bool visible;

  /// Alignment of infographic
  final Alignment alignment;

  /// Alignment when Player Controls are visible
  final Alignment? visibleControlAlignment;

  final Widget child;

  @override
  ConsumerState<InfographicVisibility> createState() =>
      _InfographicVisibilityState();
}

class _InfographicVisibilityState extends ConsumerState<InfographicVisibility>
    with TickerProviderStateMixin {
  late final AnimationController visibilityController;
  late final Animation<double> visibilityAnimation;

  late final AnimationController alignmentController;
  late final Animation<Alignment> alignmentAnimation;

  final controlVisibilityNotifier = ValueNotifier<bool>(false);
  final showNotifier = ValueNotifier<bool>(false);

  StreamSubscription<Duration>? _videoDurationSubscription;
  StreamSubscription<PlayerSignal>? _playerSignalSubscription;

  bool hiddenPermanently = false;
  Timer? permanentTimer;

  @override
  void initState() {
    super.initState();
    showNotifier.value = widget.visible;
    visibilityController = AnimationController(
      vsync: this,
      value: 1,
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

    alignmentAnimation = AlignmentTween(
      begin: widget.alignment,
      end: widget.visibleControlAlignment ?? widget.alignment,
    ).animate(alignmentController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ref.read(playerViewStateProvider).showControls) {
      controlVisibilityNotifier.value = false;
      if (widget.visibleControlAlignment != null) alignmentController.forward();
    } else {
      controlVisibilityNotifier.value = true && hiddenPermanently == false;
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
          controlVisibilityNotifier.value = true && hiddenPermanently == false;
          if (widget.visibleControlAlignment != null) {
            alignmentController.reverse();
          }
        }
      },
    );

    if (widget.alwaysShow && widget.showOn == null && !hiddenPermanently) {
      permanentTimer ??= Timer(widget.hideDuration, permanentHide);
    } else {
      _videoDurationSubscription ??= playerRepo.positionStream.listen(
        (event) {},
      );
    }
  }

  @override
  void didUpdateWidget(covariant InfographicVisibility oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.visible != widget.visible) {
      showNotifier.value = widget.visible && !hiddenPermanently;
    }
  }

  @override
  void dispose() {
    permanentTimer?.cancel();
    alignmentController.dispose();
    visibilityController.dispose();
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
          child: NotificationListener<InfographicsNotification>(
            onNotification: (InfographicsNotification notification) {
              if (notification is CloseInfographicsNotification) {
                permanentHide();
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
        alignment: alignmentAnimation,
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
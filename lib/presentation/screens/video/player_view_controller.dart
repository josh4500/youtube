import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart' as m_kit;
import 'package:media_kit_video/media_kit_video.dart' as m_kit_video;
import 'package:youtube_clone/core.dart';
import 'package:youtube_clone/core/utils/normalization.dart';
import 'package:youtube_clone/infrastructure.dart';
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/providers.dart';

class PlayerBoxProp {
  const PlayerBoxProp({
    this.translate = 0,
    this.widthRatio = 0,
    this.heightRatio = 0,
    this.extraHeightRatio = 1,
    this.expandRatio = 0,
    required this.minWidth,
    required this.minHeight,
    required this.maxHeight,
    this.extraHeight = 0,
  });

  factory PlayerBoxProp.fromScreenSize(Size size) {
    return const PlayerBoxProp(
      minWidth: kMiniPlayerWidth,
      minHeight: kMiniPlayerHeight,
      maxHeight: kPlayerMinHeight,
    );
  }

  final double translate;
  final double widthRatio;
  final double heightRatio;
  final double extraHeightRatio;
  final double expandRatio;

  final double minWidth;

  final double minHeight;
  final double maxHeight;

  final double extraHeight;

  static double maxTranslate = 200;

  double get height {
    return heightRatio.normalizeRange(minHeight, maxHeight) + maxExtraHeight;
  }

  double get maxExtraHeight => extraHeightRatio * extraHeight;

  double getFullWidth(double screenWidth) {
    return widthRatio.normalizeRange(minWidth, screenWidth);
  }

  double getFullHeight(double screenHeight) {
    return height + (expandRatio * (screenHeight - extraHeight - maxHeight));
  }

  bool get isExpanded => expandRatio > 0;
  bool get isMinimized => heightRatio == 0;
  bool get isResizableExpandMode => extraHeight > 0;

  static PlayerBoxProp? lerp(PlayerBoxProp? a, PlayerBoxProp? b, double t) {
    if (a == null || b == null) {
      return null;
    }

    return PlayerBoxProp(
      translate: lerpDouble(
        a.translate,
        b.translate,
        t,
      )!,
      widthRatio: lerpDouble(
        a.widthRatio,
        b.widthRatio,
        t,
      )!,
      heightRatio: lerpDouble(
        a.heightRatio,
        b.heightRatio,
        t,
      )!,
      expandRatio: lerpDouble(
        a.expandRatio,
        b.expandRatio,
        t,
      )!,
      extraHeightRatio: lerpDouble(
        a.extraHeightRatio,
        b.extraHeightRatio,
        t,
      )!,
      minWidth: a.minWidth,
      minHeight: a.minHeight,
      maxHeight: a.maxHeight,
      extraHeight: a.extraHeight,
    );
  }

  PlayerBoxProp copyWith({
    double? translate,
    double? widthRatio,
    double? heightRatio,
    double? extraHeightRatio,
    double? expandRatio,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
    double? extraHeight,
    double? maxTranslate,
  }) {
    return PlayerBoxProp(
      translate: translate ?? this.translate,
      widthRatio: widthRatio ?? this.widthRatio,
      heightRatio: heightRatio ?? this.heightRatio,
      extraHeightRatio: extraHeightRatio ?? this.extraHeightRatio,
      expandRatio: expandRatio ?? this.expandRatio,
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      extraHeight: extraHeight ?? this.extraHeight,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerBoxProp &&
          runtimeType == other.runtimeType &&
          translate == other.translate &&
          widthRatio == other.widthRatio &&
          heightRatio == other.heightRatio &&
          extraHeightRatio == other.extraHeightRatio &&
          expandRatio == other.expandRatio &&
          minWidth == other.minWidth &&
          minHeight == other.minHeight &&
          maxHeight == other.maxHeight &&
          extraHeight == other.extraHeight;

  @override
  int get hashCode =>
      translate.hashCode ^
      widthRatio.hashCode ^
      heightRatio.hashCode ^
      extraHeightRatio.hashCode ^
      expandRatio.hashCode ^
      minWidth.hashCode ^
      minHeight.hashCode ^
      maxHeight.hashCode ^
      extraHeight.hashCode;
}

class PlayerBoxPropTween extends Tween<PlayerBoxProp> {
  PlayerBoxPropTween({super.begin, super.end});

  /// Returns the value this variable has at the given animation clock value.
  @override
  PlayerBoxProp lerp(double t) => PlayerBoxProp.lerp(begin, end, t)!;
}

enum SeekType {
  none,
  doubleTapLeft,
  doubleTapRight,
  speedUp2X,
  pullUp,
  slideLeftOrRight,
  slideFrame,
  release;

  bool get isSlideSeeking {
    return this == slideLeftOrRight || this == slideFrame || this == release;
  }

  bool get isDoubleTap => this == doubleTapLeft || this == doubleTapRight;
  bool get isSlideFrame => this == slideFrame;
  bool get isNone => this == none;
}

class PlayerSeekState {
  PlayerSeekState({
    this.duration = Duration.zero,
    this.type = SeekType.none,
    this.startDuration = Duration.zero,
    this.rate = 0,
  });

  final int rate;
  final Duration duration;
  final Duration startDuration;
  final SeekType type;

  PlayerSeekState copyWith({
    int? rate,
    Duration? duration,
    Duration? startDuration,
    SeekType? type,
  }) {
    return PlayerSeekState(
      rate: rate ?? this.rate,
      duration: duration ?? this.duration,
      startDuration: startDuration ?? this.startDuration,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerSeekState &&
          runtimeType == other.runtimeType &&
          rate == other.rate &&
          duration == other.duration &&
          startDuration == other.startDuration &&
          type == other.type;

  @override
  int get hashCode =>
      rate.hashCode ^
      duration.hashCode ^
      startDuration.hashCode ^
      type.hashCode;
}

class PlayerViewController extends ChangeNotifier {
  PlayerViewController({
    required PlayerBoxProp boxProp,
    required TickerProvider vsync,
  })  : _boxPropNotifier = AnimationNotifier(
          vsync: vsync,
          value: boxProp,
          duration: const Duration(milliseconds: 175),
        ),
        _controlsAnimation = AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 250),
          reverseDuration: const Duration(milliseconds: 250),
        ) {
    _boxPropNotifier.addListener(_boxPropListener);

    _progressStream = _videoPlayer.stream.progress;

    _videoPlayer.stream.completed.listen((hasEnded) {
      if (hasEnded) {
        _showControls();
        _updatePlayerState(_playerState.copyWith(ended: true, playing: false));
      }
    });

    _videoPlayer.stream.buffering.listen((buffering) {
      _updatePlayerState(_playerState.copyWith(buffering: buffering));
    });

    _videoPlayer.stream.playing.listen((playing) {
      _updatePlayerState(_playerState.copyWith(playing: playing));
    });

    _progressStream.listen((progress) {
      _positionMemory.write('video', progress);
      if (!_lock.contains(PlayerLockReason.progress)) {
        _progressController.sink.add(progress);
      }
    });

    // Uncomment to simulated player with extraHeight
    // Future.delayed(
    //   const Duration(seconds: 5),
    //   () {
    //     updateBoxProp(
    //       (current) => current.copyWith(extraHeightRatio: 0, extraHeight: 300),
    //     );
    //     _boxPropNotifier.animate(
    //       end: _boxPropNotifier.value.copyWith(
    //         extraHeightRatio: 1,
    //         heightRatio: 1,
    //         widthRatio: 1,
    //       ),
    //       createTween: _createPlayerBoxTween,
    //     );
    //   },
    // );
  }

  //*********************** Fullscreen *****************************/
  bool isFullscreen = false;
  Timer? _orientationTimer;
  bool _isForcedFullscreen = false;

  //*********************** Controls *****************************/
  Timer? _controlTimer;
  String? _controlMessage;
  String? get controlMessage => _controlMessage;
  Timer? _controlMessageTimer;
  bool _isControlsLocked = false;
  bool get isControlsLocked => _isControlsLocked;
  bool _showUnlock = false;
  bool get showUnlock => _showUnlock;
  bool _isControlsVisible = false;
  bool get isControlsVisible => _isControlsVisible;
  bool _playbackProgressVisible = false;
  bool get showPlaybackProgress => _playbackProgressVisible;
  bool _controlsTempHidden = true;
  bool get controlsTempHidden => _controlsTempHidden;
  bool _showBuffer = false;
  bool get showBuffer => _showBuffer;
  final AnimationController _controlsAnimation;
  Animation<double> get controlsAnimation => _controlsAnimation.view;

  //*********************** Player *****************************/
  final m_kit.Player _videoPlayer = m_kit.Player();
  late final m_kit_video.VideoController _videoController =
      m_kit_video.VideoController(
    _videoPlayer,
  );
  m_kit_video.VideoController get videoController => _videoController;
  PlayerState _playerState = PlayerState.initial();
  PlayerState get playerState => _playerState;
  final _progressController = StreamController<Progress>.broadcast();
  Stream<Progress> get videoProgressStream => _progressController.stream;
  final Set<PlayerLockReason> _lock = <PlayerLockReason>{};
  late final Stream<Progress> _progressStream;
  final InMemoryCache<Progress> _positionMemory = InMemoryCache<Progress>(
    'PositionMemory',
  );
  Duration get videoDuration => _videoPlayer.state.duration;
  Duration get videoPosition => _videoPlayer.state.position;
  Progress? get videoProgress => _positionMemory.read('video');
  Stream<Duration> get positionStream => _videoPlayer.stream.position;

  bool get isSeeking => _seekState.type != SeekType.none;
  PlayerSeekState _seekState = PlayerSeekState();
  PlayerSeekState get seekState => _seekState;
  Timer? _seekRateTimer;

  final AnimationNotifier<PlayerBoxProp> _boxPropNotifier;
  PlayerBoxProp get boxProp => _boxPropNotifier.value;

  PlayerSettingsViewModel _settings = PlayerSettingsViewModel(
    speed: PlayerSpeed.normal,
  );

  PlayerSpeed get speed => _settings.speed;

  bool _isAnnotationsVisible = true;
  bool get isAnnotationsVisible => _isAnnotationsVisible;

  @override
  void dispose() {
    _controlTimer?.cancel();
    _controlsAnimation.dispose();

    _lock.clear();
    _videoPlayer.stop();
    _orientationTimer?.cancel();
    _boxPropNotifier.removeListener(_boxPropListener);

    _videoPlayer.dispose();
    _boxPropNotifier.dispose();
    super.dispose();
  }

  void _boxPropListener() {
    if ((boxProp.heightRatio < 1 || boxProp.expandRatio > 0) &&
        _isControlsVisible) {
      _controlsTempHidden = true;

      _isControlsVisible = false;
      _controlsAnimation.reverse(from: 0);
      _playbackProgressVisible = false;
      _controlTimer?.cancel();
    } else if ((boxProp.heightRatio == 1 && boxProp.expandRatio == 1) &&
        _controlsTempHidden) {
      _showControls();
    }
    _isAnnotationsVisible = _showBuffer = boxProp.heightRatio == 1 &&
        boxProp.translate == 0 &&
        (boxProp.expandRatio == 0 || boxProp.expandRatio == 1);

    notifyListeners();
  }

  PlayerBoxPropTween _createPlayerBoxTween(
    PlayerBoxProp? begin,
    PlayerBoxProp? end,
  ) {
    return PlayerBoxPropTween(begin: begin, end: end);
  }

  Future<void> updateBoxProp(
    PlayerBoxProp Function(PlayerBoxProp current) update, {
    bool animate = false,
  }) async {
    if (animate) {
      return _boxPropNotifier.animate(
        end: update.call(_boxPropNotifier.value),
        createTween: _createPlayerBoxTween,
      );
    } else {
      _boxPropNotifier.value = update.call(_boxPropNotifier.value);
    }
  }

  void _updatePlayerState(PlayerState state) {
    if (_playerState != state) {
      _playerState = state;
      notifyListeners();
    }
  }

  void _updateSeekState(
    PlayerSeekState Function(PlayerSeekState current) update,
  ) {
    final newSeekState = update.call(_seekState);
    if (_seekState != newSeekState) {
      _seekState = newSeekState;
      notifyListeners();
    }
  }

  Future<void> openVideo() async {
    await _videoPlayer.open(
      m_kit.Media(
        'https://user-images.githubusercontent.com/28951144/229373695-22f88f13-d18f-4288-9bf1-c3e078d83722.mp4',
      ),
    );
  }

  Future<void> playVideo() async => _videoPlayer.play();
  Future<void> pauseVideo() async => _videoPlayer.pause();
  Future<void> seekTo(Duration position) async {
    await _videoPlayer.seek(position);
    if (position < videoDuration) {
      _updatePlayerState(playerState.copyWith(ended: false));
    }
  }

  Future<void> _seekPlayer(Duration duration, {bool reverse = false}) async {
    if (playerState.loading) return;

    final position = reverse
        ? _videoPlayer.state.position - duration
        : _videoPlayer.state.position + duration;
    // Ends if seek position is greater or equal to the video duration
    if (position >= videoDuration) {
      _playerState = playerState.copyWith(ended: true, playing: false);
    }
    // If already ended and position is below the video duration, it removes end
    // state and change to a pause state
    else if (_playerState.ended && position < videoDuration) {
      // Pass argument true make it a pause state
      _updatePlayerState(playerState.copyWith(ended: false, playing: false));
    }
    if (position.isNegative) {
      await _videoPlayer.seek(Duration.zero);
    } else {
      await _videoPlayer.seek(position);
    }
  }

  Future<void> setPlayerSpeed([
    PlayerSpeed speed = PlayerSpeed.byTwo,
  ]) async {
    _settings = _settings.copyWith(speed: speed);
    await _videoPlayer.setRate(speed.dRate);
  }

  Future<void> setPitch(double pitch) async {
    // await _videoPlayer.setPitch(pitch);
  }

  Future<void> restartVideo() async {
    _updatePlayerState(playerState.copyWith(ended: false, playing: true));
    await seekTo(Duration.zero);
    await playVideo();
  }

  void _updatePlayerPosition(Duration position, {bool lockProgress = true}) {
    if (lockProgress) {
      _lock.add(PlayerLockReason.progress);
    } else {
      _lock.remove(PlayerLockReason.progress);
    }
    final lastProgress = _positionMemory.read('video') ?? Progress.zero;
    _progressController.sink.add(
      lastProgress.copyWith(position: position),
    );
    _positionMemory.write('video', lastProgress.copyWith(position: position));
  }

  void minimizeAndPauseVideo() {
    enterMinimizedMode();
    pauseVideo();
  }

  /*****************************************************************************************/

  /// Shows the player controls if it was temporary hidden.
  ///
  /// Use [force], to show controls regardless
  void _showControls([bool force = false]) {
    if ((_controlsTempHidden || force) && !_isControlsLocked) {
      _controlsTempHidden = false;
      if (!boxProp.isMinimized) {
        _isControlsVisible = true;
        _controlsAnimation.forward();
        _playbackProgressVisible = !isFullscreen;

        _autoHideControls();
      }
    } else if (_isControlsLocked) {
      _showUnlock = true;
      _controlTimer = Timer(const Duration(seconds: 3), () async {
        _showUnlock = false;
        notifyListeners();
      });
      notifyListeners();
    } else if (!boxProp.isMinimized && !isFullscreen) {
      _playbackProgressVisible = true;
    }
    notifyListeners();
  }

  void _autoHideControls() {
    // Cancels existing timer
    _controlTimer?.cancel();

    // Auto hide only when video is playing
    _controlTimer = Timer(const Duration(seconds: 3), () async {
      if (_playerState.playing) {
        _isControlsVisible = false;
        _controlsAnimation.reverse();
        _playbackProgressVisible = isFullscreen || boxProp.isExpanded;
        notifyListeners();
      }
    });
  }

  /// Hides the player controls and save state whether control will be temporary
  /// hidden.
  ///
  /// Use [force], to hide controls without changing temporary flag
  void _hideControls([bool force = false]) {
    final bool hide = _isControlsVisible;
    if (hide || force) {
      _controlsTempHidden = true && !force;
      _controlTimer?.cancel();
      _isControlsVisible = false;
      _controlsAnimation.reverse(from: force ? 0 : .4);
      _playbackProgressVisible = !(isFullscreen || boxProp.isExpanded);

      notifyListeners();
    } else if (!isFullscreen) {
      _playbackProgressVisible = false;
      notifyListeners();
    }
  }

  /// Toggles the visibility of player controls based on the current state.
  void toggleControls() {
    if (isControlsVisible) {
      _hideControls();
    } else {
      _showControls();
    }
  }

  void lockControls() {
    if (boxProp.isResizableExpandMode) {
      enterExpandedMode();
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      enterFullscreenMode();
    }
    _isControlsLocked = true;
  }

  void unlockControls() {
    _isControlsLocked = false;
    if (boxProp.isResizableExpandMode) {
      exitExpandedMode();
    } else {
      exitFullscreenMode();
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }
  }

  Future<void> enterExpandedMode([bool animate = true]) async {
    if (_isControlsLocked) return;

    _hideControls();

    await updateBoxProp(
      (current) => current.copyWith(
        translate: 0,
        widthRatio: 1,
        heightRatio: 1,
        expandRatio: 1,
        extraHeightRatio: 1,
      ),
      animate: animate,
    );

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: <SystemUiOverlay>[],
    );

    _showControls();
  }

  /// Handles exiting expanded mode
  ///
  /// Use [animate] to determine if Additional Height value animates
  Future<void> exitExpandedMode([
    bool animate = true,
  ]) async {
    if (_isControlsLocked) return;

    _hideControls();
    await updateBoxProp(
      (current) => current.copyWith(expandRatio: 0, translate: 0),
      animate: animate,
    );

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    _showControls();
  }

  void enterMinimizedMode() {
    if (_isControlsLocked) return;

    _hideControls();
    // Avoid animating
    _controlsAnimation.value = 0;
    _playbackProgressVisible = false;
    updateBoxProp(
      (current) => current.copyWith(
        widthRatio: 0,
        heightRatio: 0,
        expandRatio: 0,
        translate: 0,
        extraHeightRatio: 0,
      ),
      animate: true,
    );
  }

  Future<void> exitMinimizedMode() async {
    if (_isControlsLocked) return;

    // Set height and width to maximum
    await updateBoxProp(
      (current) => current.copyWith(
        widthRatio: 1,
        heightRatio: 1,
        extraHeightRatio: 1,
      ),
      animate: true,
    );
    _showControls(_playerState.ended);
  }

  /// Opens the video in fullscreen mode by sending a video signal to the
  /// repository.
  Future<void> enterFullscreenMode([bool force = true]) async {
    if (_isControlsLocked) return;

    _orientationTimer?.cancel(); // Cancel existing timer
    _isForcedFullscreen = force;
    _isAnnotationsVisible = false;
    _hideControls();
    updateBoxProp(
      (current) => current.copyWith(translate: 1),
      animate: true,
    );
    if (force) {
      await setLandscapeMode();
    } else {
      await Future.delayed(const Duration(milliseconds: 250));
    }

    _isAnnotationsVisible = true;
    _showControls();
  }

  Future<void> exitFullscreenMode() async {
    if (_isControlsLocked) return;

    updateBoxProp(
      (current) => current.copyWith(translate: 1),
      animate: true,
    );

    _isAnnotationsVisible = false;
    if (_isForcedFullscreen == false) {
      _hideControls();
      // If we change the Orientations to portraitUp this will make it permanent
      // and video will not react when flipped to landscape
      await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp],
      );

      _orientationTimer?.cancel();
      _orientationTimer = Timer(const Duration(seconds: 30), () {
        SystemChrome.setPreferredOrientations(
          DeviceOrientation.values,
        );
      });

      _isAnnotationsVisible = true;
      _showControls(true);
      return;
    }

    _isForcedFullscreen = false;
    _hideControls();

    await resetOrientation();
    _isAnnotationsVisible = true;
    _showControls(true);
  }

  Future<void> setLandscapeMode() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: <SystemUiOverlay>[],
    );
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> resetOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.restoreSystemUIOverlays();
  }

  void forwardOrRewindSeek({int rate = 10, bool rewind = false}) {
    _hideControls();
    _seekRateTimer?.cancel();

    // Set forward direction of seek
    _updateSeekState(
      (current) => current.copyWith(
        type: rewind ? SeekType.doubleTapLeft : SeekType.doubleTapRight,
        rate: current.rate + rate,
      ),
    );

    // Seek video by seek rate
    _seekPlayer(Duration(seconds: rate), reverse: rewind);
    _resetSeekState();
  }

  void forward2xSpeed([bool end = false]) {
    _controlsTempHidden = true;

    _hideControls();
    _seekRateTimer?.cancel();

    _updateSeekState(
      (current) => current.copyWith(
        type: SeekType.speedUp2X,
        rate: 2,
      ),
    );

    setPlayerSpeed(end ? PlayerSpeed.normal : PlayerSpeed.byTwo);
    if (end) _resetSeekState(Duration.zero);
  }

  void slideSeek({bool end = false, bool lockProgress = false}) {
    _controlsTempHidden = true;

    _hideControls();
    _seekRateTimer?.cancel();

    if (end == false) {
      _updateSeekState(
        (current) => current.copyWith(
          type: SeekType.slideLeftOrRight,
          duration: videoPosition,
          startDuration: videoPosition,
          rate: 0,
        ),
      );
    }

    _updatePlayerPosition(videoPosition, lockProgress: lockProgress);
    if (end) {
      seekTo(seekState.duration);
      _resetSeekState(Duration.zero);
    }
  }

  void slideSeekUpdate(
    Duration duration, {
    bool showRelease = false,
    bool lockProgress = false,
  }) {
    seekTo(duration);
    _updatePlayerPosition(duration, lockProgress: lockProgress);
    _updateSeekState(
      (current) => current.copyWith(
        type: showRelease ? SeekType.slideLeftOrRight : SeekType.release,
        duration: duration,
      ),
    );

    if (showRelease) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _updateSeekState(
          (current) {
            return current.copyWith(
              type: current.type == SeekType.release
                  ? SeekType.slideLeftOrRight
                  : null,
            );
          },
        );
      });
    }
  }

  void _resetSeekState([
    Duration timeout = const Duration(milliseconds: 400),
    Function()? callback,
  ]) {
    _seekRateTimer = Timer(timeout, () {
      callback?.call();
      _updateSeekState(
        (current) => current.copyWith(
          type: SeekType.none,
          rate: 0,
        ),
      );
      Future.delayed(timeout, _showControls);
    });
  }
}

// class PlaybackProp extends ChangeNotifier {
//   PlaybackProp({
//     void Function(bool completed)? onEnd,
//     void Function(bool completed)? onBuffer,
//     void Function(bool completed)? onPlaying,
//   }) {
//     _progressStream = _videoPlayer.stream.progress;
//
//     _videoPlayer.stream.completed.listen(onEnd);
//     _videoPlayer.stream.playing.listen(onPlaying);
//     _videoPlayer.stream.buffering.listen(onBuffer);
//
//     _progressStream.listen((progress) {
//       _positionCache.write('video', progress);
//       if (!_lock.contains(PlayerLockReason.progress)) {
//         _progressController.sink.add(progress);
//       }
//     });
//   }
//
//   final m_kit.Player _videoPlayer = m_kit.Player();
//   late final m_kit_video.VideoController _videoController =
//       m_kit_video.VideoController(
//     _videoPlayer,
//   );
//   m_kit_video.VideoController get videoController => _videoController;
//
//   final Set<PlayerLockReason> _lock = <PlayerLockReason>{};
//   final StreamController<Progress> _progressController =
//       StreamController<Progress>.broadcast();
//   late final Stream<Progress> _progressStream;
//   final InMemoryCache<Progress> _positionCache = InMemoryCache<Progress>(
//     'PositionMemory',
//   );
//   String _videoId = '_videoId';
//   Duration get duration => _videoPlayer.state.duration;
//   Duration get position => _videoPlayer.state.position;
//   Progress? get progress => _positionCache.read(_videoId);
//
//   Stream<Duration> get positionStream => _videoPlayer.stream.position;
// }

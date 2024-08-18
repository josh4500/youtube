import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/presentation/models.dart';

part 'current_timeline_state.g.dart';

@riverpod
class CurrentTimeline extends _$CurrentTimeline {
  Timer? _recordingTimer;

  @override
  Recording build() {
    return Recording();
  }

  void addSound(ExtraSound sound) {
    // Logic for adding sound
  }

  void updateSpeed(double speed) => state = state.copyWith(speed: speed);

  void startRecording(void Function(Recording timeline) callback) {
    // Stop any previous recordings
    _stopRecording();

    _clear();
    const addedDuration = Duration(milliseconds: 100);
    _recordingTimer = Timer.periodic(addedDuration, (timer) {
      final newDuration = state.duration + addedDuration;
      state = state.copyWith(
        duration: newDuration,
        state: RecordingState.recording,
      );
      callback(state);
    });
  }

  void stopRecording() {
    _stopRecording();
  }

  void _stopRecording() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
    state = state.copyWith(state: RecordingState.stopped);
  }

  void clear() {
    _clear();
  }

  void _clear() {
    // Start a new recording
    // Copies old speed to new timeline
    state = Recording(speed: state.speed);
  }
}

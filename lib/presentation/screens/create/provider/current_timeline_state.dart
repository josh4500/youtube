import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/presentation/models.dart';

part 'current_timeline_state.g.dart';

@riverpod
class CurrentTimeline extends _$CurrentTimeline {
  Timer? _recordingTimer;

  @override
  Timeline build() {
    return Timeline();
  }

  void addSound(ExtraSound sound) {
    // Logic for adding sound
  }

  void clear() {
    _stopRecording();
    state = Timeline();
  }

  void startRecording(void Function(Timeline timeline) callback) {
    // Stop any previous recordings
    _stopRecording();

    // Start a new recording
    state = Timeline();
    const addedDuration = Duration(milliseconds: 100);
    _recordingTimer = Timer.periodic(addedDuration, (timer) {
      final newDuration = state.duration + addedDuration;
      // TODO(josh4500): Terminate recoding when it gets to set Duration
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
}

import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/presentation/models.dart';

part 'current_recording_state.g.dart';

@riverpod
class CurrentRecording extends _$CurrentRecording {
  Timer? _recordingTimer;

  @override
  VideoRecording build() {
    return const VideoRecording();
  }

  void addSound(ExtraSound sound) {
    // Logic for adding sound
  }

  void updateSpeed(double speed) => state = state.copyWith(speed: speed);

  void startRecording(void Function(VideoRecording recording) callback) {
    _clear();
    assert(
      state.state != RecordCaptureState.recording,
      'Stop current recording.',
    );
    const addedDuration = Duration(milliseconds: 100);
    _recordingTimer = Timer.periodic(addedDuration, (timer) {
      final newDuration = state.duration + addedDuration;
      state = state.copyWith(
        duration: newDuration,
        state: RecordCaptureState.recording,
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
    state = state.copyWith(state: RecordCaptureState.stopped);
  }

  void clear() {
    _clear();
  }

  void _clear() {
    // Start a new recording
    // Copies old speed to new recording
    state = VideoRecording(speed: state.speed);
  }
}

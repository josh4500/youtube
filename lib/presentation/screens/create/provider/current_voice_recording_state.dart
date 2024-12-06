import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/presentation/models.dart';

part 'current_voice_recording_state.g.dart';

@riverpod
class CurrentVoiceRecording extends _$CurrentVoiceRecording {
  Timer? _recordingTimer;

  @override
  VoiceRecording build() {
    return VoiceRecording(range: DurationRange.zero);
  }

  void startRecording(
    Duration start,
    void Function(VoiceRecording recording) callback,
  ) {
    _clear(start);
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

  void _clear([Duration? start]) {
    // Start a new recording
    // Copies old speed to new recording
    state = VoiceRecording(
      range: start != null
          ? DurationRange(start: start, end: start)
          : DurationRange.zero,
    );
  }
}

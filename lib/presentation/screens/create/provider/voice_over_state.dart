import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/screens/create/provider/short_recording_state.dart';

part 'voice_over_state.g.dart';

@riverpod
class VoiceOverState extends _$VoiceOverState {
  @override
  RecordingState<VoiceRecording> build() {
    final shortsRecordingState = ref.read(shortRecordingProvider);
    return RecordingState(
      recordDuration: shortsRecordingState.duration,
    );
  }

  void undo() {
    state = state.undo();
  }

  void redo() {
    state = state.redo();
  }

  void addRecording(VoiceRecording recording) {
    state = state.addRecording(recording);
  }

  void clear() {
    state = state.clear();
  }

  void restore(RecordingState<VoiceRecording>? recordingState) {
    if (recordingState != null) {
      state = recordingState;
    }
  }
}

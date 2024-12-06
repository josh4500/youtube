import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/presentation/models.dart';

part 'voice_over_state.g.dart';

@riverpod
class VoiceOverState extends _$VoiceOverState {
  @override
  RecordingState build() {
    return RecordingState<VoiceRecording>(
      recordDuration: const Duration(seconds: 15),
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
}

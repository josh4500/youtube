import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/presentation/models.dart';

part 'short_recording_state.g.dart';

@riverpod
class ShortRecording extends _$ShortRecording {
  @override
  CreateTimelineState build() {
    return CreateTimelineState(
      recordDuration: const Duration(seconds: 15),
    );
  }

  void undo() {
    state = state.undo();
  }

  void redo() {
    state = state.redo();
  }

  void addTimeline(Timeline timeline) {
    state = state.addTimeline(timeline);
  }

  void updateDuration(Duration duration) {
    state = state.updateDuration(duration);
  }
}

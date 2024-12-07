import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/infrastructure.dart';
import 'package:youtube_clone/presentation/models.dart';

part 'short_recording_state.g.dart';

@riverpod
class ShortRecording extends _$ShortRecording {
  final _cachedState = ReadWriteValue<RecordingState?>(
    'shorts_recording_cache',
    null,
    InMemoryCache<RecordingState>('shorts_cache'),
  );

  @override
  RecordingState build() {
    return const RecordingState<VideoRecording>(
      recordDuration: Duration(seconds: 15),
    );
  }

  bool loadDraft() {
    final cacheStateValue = _cachedState.value;
    state = cacheStateValue ?? state;
    return cacheStateValue != null;
  }

  void undo() {
    state = state.undo();
  }

  void redo() {
    // TODO(josh4500): Update recordDuration if added more than current recordDuration
    state = state.redo();
  }

  void addRecording(VideoRecording recording) {
    state = state.addRecording(recording);
  }

  void updateRecordDuration(Duration duration) {
    state = state.updateRecordDuration(duration);
  }

  void save() {
    _cachedState.value = state;
  }

  void clear() {
    state = state.clear();
    _cachedState.value = null;
  }

  void updateCountdownStoppage(Duration? duration) {
    state = state.updateCountdownStoppage(duration);
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/infrastructure.dart';
import 'package:youtube_clone/presentation/models.dart';

part 'short_recording_state.g.dart';

@riverpod
class ShortRecording extends _$ShortRecording {
  final _cachedState = ReadWriteValue<CreateShortRecordingState?>(
    'shorts_recording_cache',
    null,
    InMemoryCache<CreateShortRecordingState>('shorts_cache'),
  );

  @override
  CreateShortRecordingState build() {
    return CreateShortRecordingState(
      recordDuration: const Duration(seconds: 15),
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
    state = state.redo();
  }

  void addTimeline(Timeline timeline) {
    state = state.addTimeline(timeline);
  }

  void updateDuration(Duration duration) {
    state = state.updateDuration(duration);
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

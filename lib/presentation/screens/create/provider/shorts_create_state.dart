import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/presentation/models.dart';

import '../widgets/editor/element.dart';
import '../widgets/filters.dart';

part 'shorts_create_state.g.dart';

@riverpod
class ShortsCreate extends _$ShortsCreate {
  @override
  ShortsCreateState build() {
    return ShortsCreateState();
  }

  void updateRecordState(RecordingState<VideoRecording> recordState) {
    state = state.copyWith(
      recordingState: ShortsRecordState(
        videoRecordingState: recordState,
      ),
    );
  }

  void updateEditState({
    VideoFilter filter = VideoFilter.none,
    List<ElementData> elements = const <ElementData>[],
    RecordingState<VoiceRecording>? voiceRecording,
  }) {
    assert(
      state.isEditing,
      'isEditState != true. Must be editing to update Edit state',
    );

    state = state.copyWith(
      editingState: ShortsEditState(
        filter: filter,
        elements: elements,
        voiceRecording: voiceRecording,
      ),
    );
  }

  void setEditing(bool isEditing) {
    state = state.copyWith(isEditing: isEditing);
  }
}

class ShortsCreateState {
  ShortsCreateState({
    this.isEditing = false,
    this.recordingState,
    this.editingState,
    this.drafts = const <ShortsCreateState>[],
  });

  final bool isEditing;
  final ShortsRecordState? recordingState;
  final ShortsEditState? editingState;
  final List<ShortsCreateState> drafts;

  ShortsCreateState copyWith({
    bool? isEditing,
    ShortsRecordState? recordingState,
    ShortsEditState? editingState,
    List<ShortsCreateState>? drafts,
  }) {
    bool removeEditState = false;
    if (editingState != null && editingState.isEmpty == true) {
      removeEditState = true;
    }
    return ShortsCreateState(
      isEditing: isEditing ?? this.isEditing,
      recordingState: recordingState ?? this.recordingState,
      editingState: removeEditState ? null : editingState ?? this.editingState,
      drafts: drafts ?? this.drafts,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShortsCreateState &&
          runtimeType == other.runtimeType &&
          isEditing == other.isEditing &&
          recordingState == other.recordingState &&
          editingState == other.editingState;

  @override
  int get hashCode =>
      isEditing.hashCode ^ recordingState.hashCode ^ editingState.hashCode;

  @override
  String toString() {
    return 'ShortsCreateState{isEditing: $isEditing, recordingState: $recordingState, editingState: $editingState, drafts: $drafts}';
  }
}

class ShortsRecordState {
  ShortsRecordState({required this.videoRecordingState});

  final RecordingState<VideoRecording> videoRecordingState;
}

class ShortsEditState {
  ShortsEditState({
    this.filter = VideoFilter.none,
    this.elements = const <ElementData>[],
    this.voiceRecording,
  });

  final VideoFilter filter;
  final List<ElementData> elements;
  final RecordingState<VoiceRecording>? voiceRecording;

  bool get isEmpty =>
      filter == VideoFilter.none &&
      voiceRecording?.recordings.isEmpty == true &&
      elements.isEmpty == true;
}

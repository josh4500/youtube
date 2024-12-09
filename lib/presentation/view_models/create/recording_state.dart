import 'package:flutter/foundation.dart';
import 'package:youtube_clone/core.dart';

enum RecordCaptureState {
  idle,
  recording,
  paused,
  stopped,
}

abstract class Recording {
  const Recording({
    this.duration = Duration.zero,
    this.state = RecordCaptureState.idle,
  });

  final Duration duration;
  final RecordCaptureState state;
}

class IdleRecording extends Recording {
  IdleRecording({super.duration});
}

class VoiceRecording extends Recording {
  VoiceRecording({super.duration, super.state, required this.range});
  final DurationRange range;

  VoiceRecording copyWith({
    Duration? duration,
    RecordCaptureState? state,
  }) {
    return VoiceRecording(
      state: state ?? this.state,
      duration: duration ?? this.duration,
      range: DurationRange(
        start: range.start,
        end: range.start + (duration ?? this.duration),
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoiceRecording &&
          runtimeType == other.runtimeType &&
          range == other.range;

  @override
  int get hashCode => range.hashCode;
}

class VideoRecording extends Recording {
  const VideoRecording({
    super.state,
    super.duration,
    this.speed = 1,
    this.extraSound,
  });

  final ExtraSound? extraSound;
  final double speed;

  VideoRecording copyWith({
    ExtraSound? extraSound,
    Duration? duration,
    RecordCaptureState? state,
    double? speed,
  }) {
    return VideoRecording(
      speed: speed ?? this.speed,
      extraSound: extraSound ?? this.extraSound,
      duration: duration ?? this.duration,
      state: state ?? this.state,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoRecording &&
          runtimeType == other.runtimeType &&
          extraSound == other.extraSound &&
          duration == other.duration &&
          state == other.state;

  @override
  int get hashCode => extraSound.hashCode ^ duration.hashCode ^ state.hashCode;
}

class ExtraSound {}

class RecordingState<T extends Recording> {
  const RecordingState({
    required this.recordDuration,
    this.countdownStoppage,
    List<T>? recordings,
    List<T>? removedRecordings,
  })  : recordings = recordings ?? const [],
        removedRecordings = removedRecordings ?? const [];

  final Duration recordDuration;
  final Duration? countdownStoppage;
  final List<T> recordings;
  final List<T> removedRecordings;

  bool get canUndo => recordings.isNotEmpty;
  bool get canRedo => removedRecordings.isNotEmpty;

  // Total duration of recordings
  Duration get duration {
    return recordings.fold(
      Duration.zero,
      (current, prev) => current + prev.duration,
    );
  }

  /// Whether recorded recordings elapse the assigned [recordDuration]
  bool get isCompleted => duration >= recordDuration;

  bool get isPublishable => duration >= const Duration(seconds: 5);

  bool get hasOneRecording => recordings.length == 1;

  /// Copy with method to return a new instance of the state with updated properties
  RecordingState copyWith({
    Duration? recordDuration,
    Duration? countdownStoppage,
    List<T>? recordings,
    List<T>? removedRecordings,
  }) {
    return RecordingState(
      recordDuration: recordDuration ?? this.recordDuration,
      countdownStoppage: countdownStoppage ?? this.countdownStoppage,
      recordings: recordings ??
          List.unmodifiable(
            this.recordings,
          ),
      removedRecordings: removedRecordings ??
          List.unmodifiable(
            this.removedRecordings,
          ),
    );
  }

  RecordingState addRecording(T recording) {
    final updatedRecordings = [...recordings, recording];
    return copyWith(
      recordings: updatedRecordings,
      removedRecordings: [], // Clear removed recordings on add
    );
  }

  RecordingState redo() {
    if (removedRecordings.isNotEmpty) {
      final lastRemoved = removedRecordings.last;
      final updatedRecordings = [...recordings, lastRemoved];
      final updatedRemovedRecordings = List<T>.from(removedRecordings)
        ..removeLast();
      return copyWith(
        recordings: updatedRecordings,
        removedRecordings: updatedRemovedRecordings,
      );
    }
    return this;
  }

  RecordingState undo() {
    if (recordings.isNotEmpty) {
      final lastRecording = recordings.last;
      final updatedRecordings = List<T>.from(recordings)..removeLast();
      final updatedRemovedRecordings = [...removedRecordings, lastRecording];
      return copyWith(
        recordings: updatedRecordings,
        removedRecordings: updatedRemovedRecordings,
      );
    }
    return this;
  }

  RecordingState updateRecordDuration(Duration duration) {
    return copyWith(recordDuration: duration);
  }

  RecordingState updateCountdownStoppage(Duration? duration) {
    return RecordingState(
      recordDuration: recordDuration,
      countdownStoppage: duration,
      recordings: recordings,
      removedRecordings: removedRecordings,
    );
  }

  List<double> getEndPositions() {
    return _calculateRecordingEnds(
      [
        ...recordings,
        if (countdownStoppage != null)
          IdleRecording(duration: countdownStoppage!),
      ],
      recordDuration,
    );
  }

  List<double> _calculateRecordingEnds(
    List<Recording> recordings,
    Duration totalDuration,
  ) {
    final List<double> progressList = [];
    double accumulatedProgress = 0.0;

    for (final Recording recording in recordings) {
      double progress =
          recording.duration.inMilliseconds / totalDuration.inMilliseconds;

      progress = progress.clamp(0.0, 1.0);
      double recordingEndProgress = accumulatedProgress + progress;
      recordingEndProgress = recordingEndProgress.clamp(0.0, 1.0);
      progressList.add(recordingEndProgress);
      accumulatedProgress = recordingEndProgress;
    }

    return progressList;
  }

  double getProgress(Recording recording) {
    final Duration tDuration = duration;

    final Duration addedDuration =
        recording.state == RecordCaptureState.recording
            ? recording.duration
            : Duration.zero;

    final Duration tDurationWithCurrent = tDuration + addedDuration;

    // Calculate progress ratio between 0.0 and 1.0
    final double progressValue =
        tDurationWithCurrent.inMilliseconds / recordDuration.inMilliseconds;

    return progressValue.clamp(0.0, 1.0);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordingState &&
          runtimeType == other.runtimeType &&
          recordDuration == other.recordDuration &&
          listEquals(recordings, other.recordings) &&
          listEquals(removedRecordings, other.removedRecordings);

  @override
  int get hashCode =>
      recordDuration.hashCode ^
      recordings.hashCode ^
      removedRecordings.hashCode;

  RecordingState clear() {
    return copyWith(
      recordDuration: recordDuration,
      removedRecordings: [],
      recordings: [],
    );
  }
}

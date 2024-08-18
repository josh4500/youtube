import 'package:flutter/foundation.dart';

enum RecordingState {
  idle,
  recording,
  paused,
  stopped,
}

class Recording {
  Recording({
    this.speed = 1,
    this.duration = Duration.zero,
    this.extraSound,
    this.state = RecordingState.idle,
  });

  final ExtraSound? extraSound;
  final Duration duration;
  final RecordingState state;
  final double speed;

  Recording copyWith({
    ExtraSound? extraSound,
    Duration? duration,
    RecordingState? state,
    double? speed,
  }) {
    return Recording(
      speed: speed ?? this.speed,
      extraSound: extraSound ?? this.extraSound,
      duration: duration ?? this.duration,
      state: state ?? this.state,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Recording &&
          runtimeType == other.runtimeType &&
          extraSound == other.extraSound &&
          duration == other.duration &&
          state == other.state;

  @override
  int get hashCode => extraSound.hashCode ^ duration.hashCode ^ state.hashCode;
}

class ExtraSound {}

class ShortRecordingState {
  ShortRecordingState({
    required this.recordDuration,
    this.countdownStoppage,
    List<Recording>? recordings,
    List<Recording>? removedRecordings,
  })  : recordings = recordings ?? const [],
        removedRecordings = removedRecordings ?? const [];

  final Duration recordDuration;
  final Duration? countdownStoppage;
  final List<Recording> recordings;
  final List<Recording> removedRecordings;

  bool get hasRecordings => recordings.isNotEmpty;
  bool get hasUndidRecording => removedRecordings.isNotEmpty;

  // Total duration of timelines
  Duration get duration {
    return recordings.fold(
      Duration.zero,
      (current, prev) => current + prev.duration,
    );
  }

  /// Whether recorded timelines elapse the assigned [recordDuration]
  bool get isCompleted => duration >= recordDuration;

  bool get isPublishable => duration >= const Duration(seconds: 5);

  bool get hasOneRecording => recordings.length == 1;

  /// Copy with method to return a new instance of the state with updated properties
  ShortRecordingState copyWith({
    Duration? recordDuration,
    Duration? countdownStoppage,
    List<Recording>? recordings,
    List<Recording>? removedRecordings,
  }) {
    return ShortRecordingState(
      recordDuration: recordDuration ?? this.recordDuration,
      countdownStoppage: countdownStoppage ?? this.countdownStoppage,
      recordings: recordings ?? List.unmodifiable(this.recordings),
      removedRecordings:
          removedRecordings ?? List.unmodifiable(this.removedRecordings),
    );
  }

  ShortRecordingState addTimeline(Recording timeline) {
    final updatedRecordings = [...recordings, timeline];
    return copyWith(
      recordings: updatedRecordings,
      removedRecordings: [], // Clear removed timelines on add
    );
  }

  ShortRecordingState redo() {
    if (removedRecordings.isNotEmpty) {
      final lastRemoved = removedRecordings.last;
      final updatedRecordings = [...recordings, lastRemoved];
      final updatedRemovedRecordings = List<Recording>.from(removedRecordings)
        ..removeLast();
      return copyWith(
        recordings: updatedRecordings,
        removedRecordings: updatedRemovedRecordings,
      );
    }
    return this;
  }

  ShortRecordingState undo() {
    if (recordings.isNotEmpty) {
      final lastRecording = recordings.last;
      final updatedRecordings = List<Recording>.from(recordings)..removeLast();
      final updatedRemovedRecordings = [...removedRecordings, lastRecording];
      return copyWith(
        recordings: updatedRecordings,
        removedRecordings: updatedRemovedRecordings,
      );
    }
    return this;
  }

  ShortRecordingState updateRecordDuration(Duration duration) {
    return copyWith(recordDuration: duration);
  }

  ShortRecordingState updateCountdownStoppage(Duration? duration) {
    return ShortRecordingState(
      recordDuration: recordDuration,
      countdownStoppage: duration,
      recordings: recordings,
      removedRecordings: removedRecordings,
    );
  }

  List<double> getEndPositions() {
    return _calculateTimelineEnds(
      [
        ...recordings,
        if (countdownStoppage != null) Recording(duration: countdownStoppage!),
      ],
      recordDuration,
    );
  }

  List<double> _calculateTimelineEnds(
    List<Recording> timelines,
    Duration totalDuration,
  ) {
    final List<double> progressList = [];
    double accumulatedProgress = 0.0;

    for (final Recording timeline in timelines) {
      double progress =
          timeline.duration.inMilliseconds / totalDuration.inMilliseconds;

      progress = progress.clamp(0.0, 1.0);
      double timelineEndProgress = accumulatedProgress + progress;
      timelineEndProgress = timelineEndProgress.clamp(0.0, 1.0);
      progressList.add(timelineEndProgress);
      accumulatedProgress = timelineEndProgress;
    }

    return progressList;
  }

  double getProgress(Recording currentTimeline) {
    final Duration totalRecordDuration = duration;

    final Duration addedDuration =
        currentTimeline.state == RecordingState.recording
            ? currentTimeline.duration
            : Duration.zero;

    final Duration totalDurationWithCurrent =
        totalRecordDuration + addedDuration;

    // Calculate progress ratio between 0.0 and 1.0
    final double progressValue =
        totalDurationWithCurrent.inMilliseconds / recordDuration.inMilliseconds;

    return progressValue.clamp(0.0, 1.0);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShortRecordingState &&
          runtimeType == other.runtimeType &&
          recordDuration == other.recordDuration &&
          listEquals(recordings, other.recordings) &&
          listEquals(removedRecordings, other.removedRecordings);

  @override
  int get hashCode =>
      recordDuration.hashCode ^
      recordings.hashCode ^
      removedRecordings.hashCode;

  ShortRecordingState clear() {
    return copyWith(
      recordDuration: recordDuration,
      removedRecordings: [],
      recordings: [],
    );
  }
}

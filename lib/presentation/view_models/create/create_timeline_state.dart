import 'package:flutter/foundation.dart';

enum RecordingState {
  idle,
  recording,
  paused,
  stopped,
}

class Timeline {
  Timeline( {
    this.speed = 0,
    this.duration = Duration.zero,
    this.extraSound,
    this.state = RecordingState.idle,
  });

  final ExtraSound? extraSound;
  final Duration duration;
  final RecordingState state;
  final double speed;

  Timeline copyWith({
    ExtraSound? extraSound,
    Duration? duration,
    RecordingState? state,
    double? speed,
  }) {
    return Timeline(
      speed: speed ?? this.speed,
      extraSound: extraSound ?? this.extraSound,
      duration: duration ?? this.duration,
      state: state ?? this.state,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Timeline &&
          runtimeType == other.runtimeType &&
          extraSound == other.extraSound &&
          duration == other.duration &&
          state == other.state;

  @override
  int get hashCode => extraSound.hashCode ^ duration.hashCode ^ state.hashCode;
}

class ExtraSound {}

class CreateTimelineState {
  CreateTimelineState({
    required this.recordDuration,
    List<Timeline>? timelines,
    List<Timeline>? removedTimelines,
  })  : timelines = timelines ?? const [],
        removedTimelines = removedTimelines ?? const [];

  final Duration recordDuration;
  final List<Timeline> timelines;
  final List<Timeline> removedTimelines;

  bool get hasTimelines => timelines.isNotEmpty;
  bool get hasUndidTimeline => removedTimelines.isNotEmpty;

  // Total duration of timelines
  Duration get duration {
    return timelines.fold(
      Duration.zero,
      (current, prev) => current + prev.duration,
    );
  }

  /// Whether recorded timelines elapse the assigned [recordDuration]
  bool get isCompleted => duration >= recordDuration;

  bool get isPublishable => duration >= const Duration(seconds: 5);

  bool get hasOneTimeline => timelines.length == 1;

  /// Copy with method to return a new instance of the state with updated properties
  CreateTimelineState copyWith({
    Duration? recordDuration,
    List<Timeline>? timelines,
    List<Timeline>? removedTimelines,
  }) {
    return CreateTimelineState(
      recordDuration: recordDuration ?? this.recordDuration,
      timelines: timelines ?? List.unmodifiable(this.timelines),
      removedTimelines:
          removedTimelines ?? List.unmodifiable(this.removedTimelines),
    );
  }

  CreateTimelineState addTimeline(Timeline timeline) {
    final updatedTimelines = [...timelines, timeline];
    return copyWith(
      timelines: updatedTimelines,
      removedTimelines: [], // Clear removed timelines on add
    );
  }

  CreateTimelineState redo() {
    if (removedTimelines.isNotEmpty) {
      final lastRemoved = removedTimelines.last;
      final updatedTimelines = [...timelines, lastRemoved];
      final updatedRemovedTimelines = List<Timeline>.from(removedTimelines)
        ..removeLast();
      return copyWith(
        timelines: updatedTimelines,
        removedTimelines: updatedRemovedTimelines,
      );
    }
    return this;
  }

  CreateTimelineState undo() {
    if (timelines.isNotEmpty) {
      final lastTimeline = timelines.last;
      final updatedTimelines = List<Timeline>.from(timelines)..removeLast();
      final updatedRemovedTimelines = [...removedTimelines, lastTimeline];
      return copyWith(
        timelines: updatedTimelines,
        removedTimelines: updatedRemovedTimelines,
      );
    }
    return this;
  }

  CreateTimelineState updateDuration(Duration duration) {
    return copyWith(recordDuration: duration);
  }

  List<double> getEndPositions() {
    return _calculateTimelineEnds(timelines, recordDuration);
  }

  List<double> _calculateTimelineEnds(
    List<Timeline> timelines,
    Duration totalDuration,
  ) {
    final List<double> progressList = [];
    double accumulatedProgress = 0.0;

    for (final Timeline timeline in timelines) {
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

  double getProgress(Timeline currentTimeline) {
    final Duration totalTimelineDuration = duration;

    final Duration addDuration =
        currentTimeline.state == RecordingState.recording
            ? currentTimeline.duration
            : Duration.zero;

    final Duration totalDurationWithCurrent =
        totalTimelineDuration + addDuration;

    // Calculate progress ratio between 0.0 and 1.0
    final double progressValue =
        totalDurationWithCurrent.inMilliseconds / recordDuration.inMilliseconds;

    return progressValue.clamp(0.0, 1.0);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateTimelineState &&
          runtimeType == other.runtimeType &&
          recordDuration == other.recordDuration &&
          listEquals(timelines, other.timelines) &&
          listEquals(removedTimelines, other.removedTimelines);

  @override
  int get hashCode =>
      recordDuration.hashCode ^ timelines.hashCode ^ removedTimelines.hashCode;
}

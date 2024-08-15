class Timeline {
  Timeline({
    required this.duration,
    this.extraSound,
  });

  final ExtraSound? extraSound;
  final Duration duration;
}

class ExtraSound {}

class CreateTimelineState {
  const CreateTimelineState({
    required this.recordDuration,
    this.timelines = const <Timeline>[],
  }) : _removedTimelines = const <Timeline>[];

  final Duration recordDuration;
  final List<Timeline> timelines;
  final List<Timeline> _removedTimelines;

  bool get hasTimelines => timelines.isNotEmpty;
  bool get hasUndidTimeline => _removedTimelines.isNotEmpty;
  // Total duration of timelines
  Duration get duration {
    return timelines.fold(
      Duration.zero,
      (current, prev) => current + prev.duration,
    );
  }

  /// Whether recorded timelines elapse the assigned [recordDuration]
  bool get isCompleted => duration == recordDuration;

  void addTimeline(Timeline timeline) {
    timelines.add(timeline);
    // Timelines undone will be overwritten by new timeline
    // TODO(josh4500): Delete files in _removedTimelines
    _removedTimelines.clear();
  }

  void redo() {
    if (_removedTimelines.isNotEmpty) {
      final lastRemoved = _removedTimelines.last;
      timelines.add(lastRemoved);
      _removedTimelines.removeLast();
    }
  }

  void undo() {
    if (timelines.isNotEmpty) {
      _removedTimelines.add(timelines.last);
      timelines.removeLast();
    }
  }
}

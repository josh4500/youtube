extension DurationUtils on Duration {
  String get hoursMinutesWords {
    String hoursPart = inHours > 1
        ? '$inHours hours'
        : inHours < 1
            ? ''
            : 'hour';
    final minutesPart = inMinutes.remainder(60) > 0
        ? ' ${inMinutes.remainder(60)} minutes'
        : '';

    hoursPart =
        inHours == 1 && inMinutes.remainder(60) > 0 ? '1 hour' : hoursPart;

    return '$hoursPart$minutesPart';
  }

  String get hoursMinutes {
    String hoursPart = (inMinutes / 60).floor().toString().padLeft(2, '0');
    String minutesPart = inMinutes.remainder(60).toString().padLeft(2, '0');
    return '$hoursPart:$minutesPart';
  }
}

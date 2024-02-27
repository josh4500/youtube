import 'package:media_kit/media_kit.dart';
import 'package:rxdart/rxdart.dart';
// TODO: Fix import
import 'package:youtube_clone/presentation/widgets/player/playback/playback_progress.dart';

extension ProgressStreamExtension on PlayerStream {
  Stream<Progress> get progress {
    return Rx.combineLatest2(buffer, position, (a, b) {
      return Progress(
        buffer: a,
        position: b,
      );
    });
  }
}

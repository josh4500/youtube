import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../provider/current_recording_state.dart';
import '../provider/short_recording_state.dart';

class CreateProgress extends ConsumerWidget {
  const CreateProgress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shortRecording = ref.watch(shortRecordingProvider);

    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? _) {
        final currentRecording = ref.watch(currentRecordingProvider);
        final double value = shortRecording.getProgress(currentRecording);
        return CustomPaint(
          foregroundPainter: _RecordingSeparator(
            progressList: shortRecording.getEndPositions(),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              color: AppPalette.red,
              backgroundColor: Colors.white24,
            ),
          ),
        );
      },
    );
  }
}

class _RecordingSeparator extends CustomPainter {
  _RecordingSeparator({required this.progressList});

  final List<double> progressList;
  static const double strokeWidth = 2.5;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint markerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square;

    for (final double progress in progressList) {
      final double markerX = (size.width * progress) - (strokeWidth / 2);
      final Offset point1 = Offset(markerX, 0);
      final Offset point2 = Offset(markerX, size.height);
      canvas.drawLine(point1, point2, markerPaint);
    }
  }

  @override
  bool shouldRepaint(_RecordingSeparator oldDelegate) =>
      oldDelegate.progressList != progressList;
}

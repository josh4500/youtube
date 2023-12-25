import 'package:youtube_clone/presentation/theme/relative_size.dart';

import 'size_triad.dart';
import 'orientation_pair.dart';

class AppSizing {
  static final testProperty = SizeTriad<OrientationPair<double>>.double(
    const OrientationPair<double>(landscape: 120, portrait: 120),
    const OrientationPair<double>(landscape: 120, portrait: 120),
  );

  static final settingsTileSize = SizeTriad.single(
    const OrientationPair<RelativeSizing>(
      landscape: RelativeSizing(wRatio: 0.41),
      portrait: RelativeSizing(wRatio: 1),
    ),
  );
}

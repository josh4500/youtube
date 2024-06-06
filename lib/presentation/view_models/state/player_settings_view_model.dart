class PlayerSettingsViewModel {
  PlayerSettingsViewModel({
    required this.speed,
    this.captions = const <PlayerCaption>[],
  });

  final List<PlayerCaption> captions;
  final PlayerSpeed speed;

  PlayerSettingsViewModel copyWith({
    PlayerSpeed? speed,
    List<PlayerCaption>? captions,
  }) {
    return PlayerSettingsViewModel(
      speed: speed ?? this.speed,
      captions: captions ?? this.captions,
    );
  }
}

class PlayerCaption {}

enum PlayerSpeed {
  point25x,
  point5x,
  point75x,
  normal,
  onePoint25x,
  onePoint5x,
  onePoint75x,
  byTwo;

  double get dRate {
    return switch (this) {
      point25x => .25,
      point5x => .5,
      point75x => .75,
      normal => 1,
      onePoint25x => 1.25,
      onePoint5x => 1.5,
      onePoint75x => 1.75,
      byTwo => 2,
    };
  }

  String get sRate {
    return switch (this) {
      point25x => '0.25x',
      point5x => '0.5x',
      point75x => '0.75x',
      normal => 'Normal',
      onePoint25x => '1.25x',
      onePoint5x => '1.5x',
      onePoint75x => '1.75x',
      byTwo => '2x',
    };
  }
}

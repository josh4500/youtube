import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_view_state_provider.g.dart';

enum ViewState {
  expanded,
  minimized,
  visibleAmbient,
  visibleControls,
  visibleChapters,
  visibleDescription;
}

extension PlayerViewStateExtension on Set<ViewState> {
  bool get isExpanded => contains(ViewState.expanded);
  bool get isMinimized => contains(ViewState.minimized);
  bool get showAmbient => contains(ViewState.visibleAmbient);
  bool get showControls => contains(ViewState.visibleControls);
  bool get showChapters => contains(ViewState.visibleChapters);
  bool get showDescription => contains(ViewState.visibleDescription);
}

@riverpod
class PlayerViewState extends _$PlayerViewState {
  @override
  Set<ViewState> build() {
    return {};
  }

  void addState(ViewState viewState) {
    state = <ViewState>{...state, viewState};
  }

  void removeState(ViewState viewState) {
    final oldState = state;
    oldState.remove(viewState);
    state = <ViewState>{...oldState};
  }
}

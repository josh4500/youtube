import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeRepository extends ChangeNotifier {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  double _navBarPos = 1;
  double get navBarPos => _navBarPos;
  bool _lockNavBarPos = false;

  void lockNavBarPosition() {
    _lockNavBarPos = true;
    _navBarPos = 0;
    notifyListeners();
  }

  void unlockNavBarPosition() {
    _lockNavBarPos = false;
    _navBarPos = 1;
    notifyListeners();
  }

  void updateNavBarPosition(double value) {
    if (_lockNavBarPos == false) {
      final oldValue = _navBarPos;
      _navBarPos = value.clamp(0, 1);
      if (value != oldValue) notifyListeners();
    }
  }

  void openDrawer() => scaffoldKey.currentState?.openDrawer();
  void closeDrawer() => scaffoldKey.currentState?.closeDrawer();
}

final homeRepositoryProvider = ChangeNotifierProvider<HomeRepository>(
  (ref) {
    return HomeRepository();
  },
);

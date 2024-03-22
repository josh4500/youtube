import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeRepository extends ChangeNotifier {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  double _navBarPos = 1;
  double get navBarPos => _navBarPos;

  void updateNavBarPosition(double value) {
    final oldValue = _navBarPos;
    _navBarPos = value.clamp(0, 1);
    if (value != oldValue) notifyListeners();
  }

  void openDrawer() => scaffoldKey.currentState?.openDrawer();
  void closeDrawer() => scaffoldKey.currentState?.closeDrawer();
}

final homeRepositoryProvider = ChangeNotifierProvider<HomeRepository>(
  (ref) {
    return HomeRepository();
  },
);

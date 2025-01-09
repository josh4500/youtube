import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/infrastructure.dart';

import '../../screens/homepage.dart';

class HomeRepository extends ChangeNotifier {
  HomeRepository() {
    _streamSubscription = InternetConnectivity.instance.onStateChange.listen(
      (event) {
        // if (event.isNotConnected && event.type == ConnectivityType.none) {
        //   overlayKey.currentState?.showExploreDownloads();
        // } else if (event.isConnected) {
        //   overlayKey.currentState?.hideExploreDownloads();
        // }
      },
    );
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<ConnectivityState>? _streamSubscription;

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
  }
}

final homeRepositoryProvider = ChangeNotifierProvider<HomeRepository>(
  (ref) {
    return HomeRepository();
  },
);

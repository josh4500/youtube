import 'package:firebase_analytics/firebase_analytics.dart';

abstract class AnalyticsClient {
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  });

  Future<void> setUserId(String userId);

  Future<void> setUserProperties(Map<String, dynamic> properties);
}

class FirebaseAnalyticsClient implements AnalyticsClient {
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _firebaseAnalytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> setUserId(String userId) async {
    await _firebaseAnalytics.setUserId(id: userId);
  }

  @override
  Future<void> setUserProperties(Map<String, dynamic> properties) async {
    properties.forEach((key, value) async {
      await _firebaseAnalytics.setUserProperty(
        name: key,
        value: value.toString(),
      );
    });
  }
}

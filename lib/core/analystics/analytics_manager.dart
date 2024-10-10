import 'analytics_client.dart';

class AnalyticsManager implements AnalyticsClient {
  AnalyticsManager(this._clients);
  final List<AnalyticsClient> _clients;

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    for (final client in _clients) {
      await client.logEvent(name: name, parameters: parameters);
    }
  }

  @override
  Future<void> setUserId(String userId) async {
    for (final client in _clients) {
      await client.setUserId(userId);
    }
  }

  @override
  Future<void> setUserProperties(Map<String, dynamic> properties) async {
    for (final client in _clients) {
      await client.setUserProperties(properties);
    }
  }
}

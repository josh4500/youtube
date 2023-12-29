class RouteInfo {
  final String name;
  final String path;

  RouteInfo({required this.name, required this.path});
}

class AppRoutes {
  static final home = RouteInfo(
    name: 'home',
    path: '/',
  );

  ///
  ///
  /// Settings
  ///
  ///
  static final settings = RouteInfo(
    name: 'settings',
    path: '/settings',
  );
}

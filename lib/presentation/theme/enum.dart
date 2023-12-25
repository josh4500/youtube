enum DeviceType {
  android,
  ios,
  tablet,
  ipad;

  static DeviceType get byPlatform {
    // TODO: Fix a better way to get Platform. Either use Platform or environment
    return android;
  }
}

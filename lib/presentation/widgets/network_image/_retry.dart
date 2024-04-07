class Retry {
  Retry({
    required this.stream,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  });

  final Stream<bool> stream;
  final int maxRetries;
  final Duration retryDelay;

  Future<T> retry<T>(Future<T> Function() logic) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      // Check internet connectivity
      if (await stream.firstWhere((retry) => retry)) {
        try {
          return await logic();
        } on Exception catch (e) {
          // Retry on any exception if internet is connected
          attempt++;
          await Future.delayed(retryDelay);
        }
      } else {
        // No internet connection, wait and retry
        attempt++;
        await Future.delayed(retryDelay);
      }
    }
    throw Exception('Failed to execute logic after $maxRetries retries');
  }
}

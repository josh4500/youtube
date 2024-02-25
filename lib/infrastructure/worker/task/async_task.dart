import 'dart:async';

typedef AsyncTaskOperation<R, S> = FutureOr<S> Function(R input);

class AsyncTask<R, S> {
  final int id;
  final R input;
  final AsyncTaskOperation<R, S> operation;

  AsyncTask({required this.id, required this.input, required this.operation});
}

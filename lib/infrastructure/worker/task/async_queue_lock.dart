import 'dart:async';
import 'dart:collection';

import '../utils.dart';
import 'async_task.dart';

class AsyncTaskQueue<R, S> {
  AsyncTaskQueue({
    this.onDone,
    this.interceptors = const <Interceptor>[],
  });

  int _idCounter = 0;
  bool _isLock = false;

  bool isTypeVoid() => S == voidType();

  final FutureOr<void> Function(S value)? onDone;
  final List<Interceptor> interceptors;
  final Queue<AsyncTask<R, S>> _queue = Queue<AsyncTask<R, S>>();

  void addEvent(R event, AsyncTaskOperation<R, S> operation) {
    final AsyncTask<R, S> task = AsyncTask<R, S>(
      id: _idCounter++,
      input: event,
      operation: operation,
    );

    for (final interceptor in interceptors) {
      interceptor.onAdd(task);
    }

    if (_isLock) {
      _queue.add(task);
      return;
    }
    _isLock = true;
    _doTask(task);
  }

  void _doTask(AsyncTask<R, S> task) {
    final Completer<S> completer = Completer<S>();
    completer.future.then((S value) async {
      for (final interceptor in interceptors) {
        interceptor.onComplete(task);
      }

      if (!isTypeVoid() && onDone != null) {
        await onDone!(value);
      }
      if (_queue.isNotEmpty) {
        _doTask(_queue.removeFirst());
      } else {
        _isLock = false;
      }
    });
    completer.complete(task.operation(task.input));
  }
}

abstract class Interceptor {
  void onAdd(AsyncTask task);
  void onComplete(AsyncTask task);
}

class CacheInterceptor extends Interceptor {
  @override
  void onAdd(AsyncTask task) {}
  @override
  void onComplete(AsyncTask task) {}
}

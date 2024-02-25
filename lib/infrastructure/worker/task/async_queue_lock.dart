import 'dart:async';
import 'dart:collection';

import '../utils.dart';
import 'async_task.dart';

class AsyncTaskQueue<R, S> {
  int _idCounter = 0;
  bool _isLock = false;

  bool isTypeVoid() => S == voidType();

  final FutureOr<void> Function(S value)? onDone;
  final Queue<AsyncTask<R, S>> _queue = Queue<AsyncTask<R, S>>();

  AsyncTaskQueue({this.onDone});

  void addEvent(R event, AsyncTaskOperation<R, S> operation) {
    final task = AsyncTask(
      id: _idCounter++,
      input: event,
      operation: operation,
    );

    if (_isLock) {
      _queue.add(task);
      return;
    }
    _isLock = true;
    _doTask(task);
  }

  void _doTask(AsyncTask<R, S> task) {
    final completer = Completer<S>();
    completer.future.then((value) async {
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

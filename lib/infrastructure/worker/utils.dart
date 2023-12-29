class _W<T> {
  const _W();
  Type call() => T;
}

const voidType = _W<void>();

extension ListExtension<T> on List<T> {
  T removeFirst() {
    return removeAt(0);
  }
}

import 'package:flutter/foundation.dart';

class PrefOption<T> {
  final PrefOptionType type;
  final VoidCallback? onToggle;
  final T? value;

  PrefOption({required this.type, this.value, this.onToggle});
}

enum PrefOptionType {
  toggle,
  toggleWithOptions,
  options,
  none;
}

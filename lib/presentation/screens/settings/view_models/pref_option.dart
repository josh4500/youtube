import 'package:flutter/foundation.dart';

class PrefOption<T> {
  final PrefOptionType type;
  final VoidCallback? onToggle;
  final T? value;
  final T? groupValue;

  PrefOption({
    required this.type,
    this.value,
    this.onToggle,
    this.groupValue,
  });
}

enum PrefOptionType {
  toggle,
  toggleWithOptions,
  options,
  radio,
  none;
}

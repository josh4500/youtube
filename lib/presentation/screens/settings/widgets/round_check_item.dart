import 'package:flutter/material.dart';

class RoundCheckItem<T> extends StatelessWidget {
  final String title;
  final T? groupValue;
  final T value;
  final ValueChanged<T?>? onChange;

  const RoundCheckItem({
    super.key,
    required this.title,
    this.groupValue,
    required this.value,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      title: Text(title),
      enableFeedback: true,
      splashRadius: 0,
      overlayColor: MaterialStateProperty.resolveWith(
        (states) => Colors.transparent,
      ),
      value: value,
      groupValue: groupValue,
      onChanged: onChange,
    );
  }
}

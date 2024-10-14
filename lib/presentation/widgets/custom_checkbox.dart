import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({super.key, required this.selected});
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      padding: const EdgeInsets.all(1),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF3EA6FF) : null,
        borderRadius: BorderRadius.circular(1),
        border: selected ? null : Border.all(color: Colors.white24, width: 1.5),
      ),
      child: selected
          ? const Icon(Icons.check, color: Colors.black, size: 16)
          : null,
    );
  }
}

class CustomRadio extends StatelessWidget {
  const CustomRadio({super.key, required this.selected});
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      padding: const EdgeInsets.all(2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: context.theme.highlightColor, width: 1.5),
      ),
      child: selected
          ? Container(
              decoration: BoxDecoration(
                color: selected
                    ? context.theme.radioTheme.fillColor?.resolve(
                        {WidgetState.selected},
                      )
                    : null,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}

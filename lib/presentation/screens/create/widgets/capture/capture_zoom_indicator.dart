import 'package:flutter/material.dart';

class CaptureZoomIndicator extends StatelessWidget {
  const CaptureZoomIndicator({super.key, required this.controller});
  final ValueNotifier<double> controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .45,
      width: 24,
      child: RotatedBox(
        quarterTurns: 3,
        child: SliderTheme(
          data: const SliderThemeData(
            trackHeight: 1,
            thumbColor: Colors.white,
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white54,
          ),
          child: ValueListenableBuilder(
            valueListenable: controller,
            builder: (
              BuildContext context,
              double value,
              Widget? _,
            ) {
              return Slider(
                value: value,
                onChanged: (v) {},
              );
            },
          ),
        ),
      ),
    );
  }
}

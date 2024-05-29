import 'package:flutter/material.dart';

class CaptureZoomIndicator extends StatelessWidget {
  const CaptureZoomIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .45,
      child: RotatedBox(
        quarterTurns: 3,
        child: SliderTheme(
          data: const SliderThemeData(
            trackHeight: 1,
            thumbColor: Colors.white,
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white54,
          ),
          child: Slider(
            value: .5,
            onChanged: (v) {},
          ),
        ),
      ),
    );
  }
}

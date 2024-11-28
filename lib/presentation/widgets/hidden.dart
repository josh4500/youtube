import 'package:flutter/material.dart';

class HiddenListenableWidget extends StatelessWidget {
  const HiddenListenableWidget({
    super.key,
    required this.listenable,
    this.hideCallback,
    required this.child,
  });

  final Listenable listenable;
  final Widget child;
  final bool Function()? hideCallback;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: listenable,
      builder: (BuildContext context, Widget? _) {
        final hidden = hideCallback?.call() ?? false;
        return Offstage(
          offstage: hidden,
          child: child,
        );
      },
    );
  }
}

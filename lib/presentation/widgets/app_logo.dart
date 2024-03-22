import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(Josh): Show Youtube or Premium logo
    return const Row(
      children: <Widget>[
        Text(
          'YouTube',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

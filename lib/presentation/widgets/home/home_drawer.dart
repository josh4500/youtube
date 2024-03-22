import 'package:flutter/material.dart';

import '../app_logo.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.all(12.0),
          child: AppLogo(),
        ),
      ],
    );
  }
}

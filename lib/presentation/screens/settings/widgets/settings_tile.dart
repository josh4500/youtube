import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  const SettingsTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {},
    );
  }
}

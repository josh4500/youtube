import 'package:flutter/material.dart';

class CheckingPermission extends StatelessWidget {
  const CheckingPermission({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 3,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CheckPermission extends StatelessWidget {
  const CheckPermission({super.key});

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

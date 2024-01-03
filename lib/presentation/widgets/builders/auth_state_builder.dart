import 'package:flutter/material.dart';
import 'package:youtube_clone/core/enums/auth_state.dart';

class AuthStateBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, AuthState state) builder;

  const AuthStateBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, AuthState.authenticated);
  }
}

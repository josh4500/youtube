import 'package:flutter/material.dart';

enum AuthState {
  authenticated,
  notAuthenticated;

  bool get isNotAuthenticated => this == notAuthenticated;
}

class AccountBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, AuthState state) builder;

  const AccountBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, AuthState.authenticated);
  }
}

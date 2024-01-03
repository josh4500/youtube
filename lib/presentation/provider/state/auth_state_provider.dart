import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/core/enums/auth_state.dart';

final authStateProvider = StateProvider<AuthState>(
  (ref) => AuthState.notAuthenticated,
);

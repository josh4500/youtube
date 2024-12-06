import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/core.dart';
import 'package:youtube_clone/presentation/models.dart';

import '../state/account_state_provider.dart';
import '../state/auth_state_provider.dart';

part 'account_repository_provider.g.dart';

@Riverpod(keepAlive: true)
AccountRepository accountRepository(Ref ref) {
  return AccountRepository(ref: ref);
}

class AccountRepository {
  AccountRepository({required this.ref});

  final Ref ref;

  Future<void> setup() async {}

  Future<void> _mountAccount() async {
    ref.read(accountStateProvider.notifier).state = UserViewModel.test;
  }

  Future<void> _unmountAccount() async {
    ref.read(accountStateProvider.notifier).state = GuestViewModel();
  }

  Future<void> turnOnIncognito() async {
    await _unmountAccount();
    ref.read(authStateProvider.notifier).state = AuthState.incognito;
  }

  Future<void> turnOffIncognito() async {
    await _mountAccount();
    ref.read(authStateProvider.notifier).state = AuthState.authenticated;
  }
}

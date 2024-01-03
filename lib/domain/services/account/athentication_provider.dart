import 'package:youtube_clone/core/enums/auth_state.dart';
import 'package:youtube_clone/domain/models/account.dart';

import '../../value_object/sign_in_data.dart';

abstract class AuthenticationProvider {
  AuthState get state;
  Account get account;
  Future<void> signIn(SignInData data);
  Future<void> signOut();
  Future<void> reAuthenticate();
}

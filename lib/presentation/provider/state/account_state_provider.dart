import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/account.dart';

final accountStateProvider = StateProvider<Account>((ref) {
  return const Account(
    id: 'id',
    name: 'Josh',
    username: 'josh500',
    email: 'jibo.ajosh45@gmail.com',
  );
});

abstract class AccountViewModel {
  AccountViewModel({required this.email});

  final String? email;

  bool get isChannel => this is ChannelViewModel;
  bool get isUser => this is UserViewModel;
  bool get isPremium => true;
}

class DeviceAccountViewModel extends AccountViewModel {
  DeviceAccountViewModel({required super.email});
}

class GuestViewModel extends AccountViewModel {
  GuestViewModel() : super(email: null);
}

class UserViewModel extends AccountViewModel {
  UserViewModel({
    required super.email,
    required this.id,
    required this.name,
    required this.username,
  });

  final String id;
  final String name;
  final String username;

  static final UserViewModel test = UserViewModel(
    id: 'XHye83mdiw9',
    name: 'Joshua Akinmosin',
    email: 'jibo.ajosh45@gmail.com',
    username: 'josh4500',
  );
}

class ChannelViewModel extends AccountViewModel {
  ChannelViewModel({
    required super.email,
    required this.id,
    required this.name,
    required this.tag,
  });

  final String id;
  final String name;
  final String tag;
}

class Account {
  final String id;
  final String? avatar;
  final bool? hasChannel;
  final String name;
  final String username;
  final String email;

  const Account({
    required this.id,
    this.avatar,
    this.hasChannel,
    required this.name,
    required this.username,
    required this.email,
  });
}

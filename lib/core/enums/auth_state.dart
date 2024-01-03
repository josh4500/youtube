enum AuthState {
  authenticated,
  notAuthenticated,
  incognito;

  bool get isNotAuthenticated => this == notAuthenticated;
  bool get isInIncognito => this == incognito;
}

import 'auth_provider.dart';
import 'auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  //factory AuthService.sqLite() => AuthService(SQLiteAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String username,
    required String password,
  }) {
    return provider.createUser(username: username, password: password);
  }

  @override
  Future<void> logOut() {
    return provider.logOut();
  }

  @override
  Future<AuthUser> login({
    required String username,
    required String password,
  }) {
    return provider.login(username: username, password: password);
  }

  @override
  set currentUser(AuthUser? currentUser) {
    provider.currentUser = currentUser;
  }

  @override
  AuthUser? get currentUser => provider.currentUser;
}

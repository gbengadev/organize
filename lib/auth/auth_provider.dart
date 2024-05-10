import 'auth_user.dart';

abstract class AuthProvider {
  AuthUser? currentUser;
  Future<AuthUser> login({
    required String username,
    required String password,
  });
  Future<AuthUser> createUser({
    required String username,
    required String password,
  });
  Future<void> logOut();
}

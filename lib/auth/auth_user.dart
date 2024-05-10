import 'package:flutter/foundation.dart';
import 'package:flutterdemoapp/crud/database_user.dart';

@immutable
class AuthUser {
  final String username;
  final int id;
  const AuthUser({
    required this.username,
    required this.id,
  });
  //Database user
  factory AuthUser.fromSQlite(DatabaseUser user) => AuthUser(
        id: user.id,
        username: user.username,
      );
}

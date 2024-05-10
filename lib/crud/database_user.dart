import 'package:flutter/material.dart';
import 'package:flutterdemoapp/constants/database_objects.dart';

@immutable
class DatabaseUser {
  final int id;
  final String username;

  const DatabaseUser({
    required this.id,
    required this.username,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        username = map[usernameColumn] as String;

  @override
  String toString() => 'Person,ID =$id,email=$username';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

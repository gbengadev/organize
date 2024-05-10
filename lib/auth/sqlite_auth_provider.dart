import 'package:logger/logger.dart';
import '../constants/database_objects.dart';
import '../crud/database_setup.dart';
import '../crud/database_user.dart';
import 'auth_user.dart';
import 'auth_exceptions.dart';
import 'auth_provider.dart';

class SQLiteAuthProvider implements AuthProvider {
  var logger = Logger();

  late DatabaseSetup databaseSetup = DatabaseSetup();

  @override
  Future<AuthUser> createUser(
      {required String username, required String password}) async {
    final db = databaseSetup.getDatabase();
    logger.d('db is $db');
    final result = await db.query(userTable,
        where: '$usernameColumn=?', whereArgs: [username.toLowerCase()]);
    logger.d('result is $result');
    if (result.isNotEmpty) {
      throw UserAlreadyExistsException();
    }
    final userId = await db.insert(userTable,
        {usernameColumn: username.toLowerCase(), passwordColumn: password});
    logger.d('userId is $userId');
    return AuthUser(id: userId, username: username);
  }

  @override
  AuthUser? currentUser;

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> login(
      {required String username, required String password}) async {
    final db = databaseSetup.getDatabase();
    final result = await db.query(userTable,
        where: '$usernameColumn=? and $passwordColumn=?',
        whereArgs: [username.toLowerCase(), password]);
    if (result.isNotEmpty) {
      final user = AuthUser.fromSQlite(DatabaseUser.fromRow(result.first));
      currentUser = user;
      return user;
    }
    throw WrongCredentialAuthException();
  }
}

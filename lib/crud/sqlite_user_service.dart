import 'dart:async';
import 'package:flutterdemoapp/constants/text.dart';
import 'package:flutterdemoapp/crud/database_setup.dart';
import 'package:logger/logger.dart';
import '../constants/database_objects.dart';
import 'database_exceptions.dart';
import 'database_user.dart';

var logger = Logger();

class UserService {
//   DatabaseUser? _user;
//   List<DatabaseBook> _userBooks = [];
//   // late final StreamController<List<DatabaseUserBooks>>
//   //     _userBooksStreamController;
  late DatabaseSetup databaseSetup = DatabaseSetup();

// //User
//   Future<DatabaseUser> createUser(
//       {required String username, required String password}) async {
//     final db = databaseSetup.getDatabase();
//     final result = await db.query(userTable,
//         where: '$usernameColumn=?', whereArgs: [username.toLowerCase()]);
//     if (result.isNotEmpty) {
//       throw UserAlreadyExistsException();
//     }
//     final userId = await db.insert(userTable,
//         {usernameColumn: username.toLowerCase(), passwordColumn: password});
//     return DatabaseUser(id: userId, username: username);
//   }

  Future<DatabaseUser> getUser({required int userId}) async {
    final db = databaseSetup.getDatabase();
    final result =
        await db.query(userTable, where: '$idColumn=?', whereArgs: [userId]);
    if (result.isEmpty) {
      throw UserDoesNotExistException();
    }
    return DatabaseUser.fromRow(result.first);
  }

//   Future<DatabaseUser> login(
//       {required String username, required String password}) async {
//     final db = databaseSetup.getDatabase();
//     final result = await db.query(userTable,
//         where: '$usernameColumn=? and $passwordColumn=?',
//         whereArgs: [username.toLowerCase(), password]);
//     if (result.isNotEmpty) {
//       return DatabaseUser.fromRow(result.first);
//     }
//     throw WrongCredentialAuthException();
//   }

  String getUsernameValidationText(String username) {
    if (username.isEmpty) {
      return "Please enter your username";
    }
    if (RegExp(usernameValidationCharacters).hasMatch(username)) {
      return "Username cannot contain special characters";
    }
    if (username.length < 3) {
      return "Username should contain at least 4 characters";
    }
    return "valid";
  }

  String getPasswordValidationText(String password) {
    if (password.isEmpty) {
      return "Please enter your password";
    }
    if (password.length < 6) {
      return "Password should contain at least 6 characters";
    }
    return "valid";
  }

//TODO: Use stream to filter user book lists(favourite,read,reading)
  // Stream<List<DatabaseBooks>> get allBooks => _allBooksStreamController.stream;
  // .filter((note) {
  //   final currentUser = _user;
  //   if (currentUser != null) {
  //     return note.userId == currentUser.id;
  //   } else {
  //     throw UserNotFoundAuthException();
  //   }
  // });
}

import 'package:flutterdemoapp/constants/sql_statements.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../constants/database_objects.dart';
import 'book_service.dart';
import 'database_exceptions.dart';

var logger = Logger();

class DatabaseSetup {
  final BookService _bookService = BookService();
  Database? _database;
  Database? get database => _database;

  static final DatabaseSetup _shared = DatabaseSetup._sharedInstance();
  DatabaseSetup._sharedInstance();
  factory DatabaseSetup() => _shared;

  Future<void> close() async {
    final db = _database;
    if (db == null) {
      throw DatabaseIsClosedException();
    } else {
      await db.close();
    }
  }

//Open Database
  Future<void> open() async {
    if (_database != null) {
      throw DatabaseOpenException();
    }
    try {
      //  if (Platform.isAndroid) PathProviderAndroid.registerWith();
      // if (Platform.isIOS) PathProviderIOS.registerWith();
      logger.d("In Open db method");
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, databaseName);
      final db = await openDatabase(dbPath);
      logger.d("Database is $db and path is $dbPath");
      _database = db;
      logger.d("database is $_database");
      await db.execute(createUserTable);
      await db.execute(createBookTable);
      await db.execute(createUserBooksTable);

      List<String> statements = insertBooksString
          .split(';')
          .where((s) => s.trim().isNotEmpty)
          .toList();

      await db.transaction((txn) async {
        for (var statement in statements) {
          await txn.execute(statement);
        }
      });

      //Cache books
    } on MissingPlatformDirectoryException {
      throw UnableToGetDirectory();
    } catch (e) {
      logger.d("Db error $e");
    }
    await _bookService.cacheAllBooks();
  }

  Database getDatabase() {
    logger.d('db in get database= $_database');
    final db = _database;
    return db ?? (throw DatabaseIsClosedException());
  }
}

import 'dart:async';
import '../constants/database_objects.dart';
import 'database_books.dart';
import 'database_exceptions.dart';
import 'database_setup.dart';

class BookService {
  late DatabaseSetup databaseSetup = DatabaseSetup();

  List<DatabaseBook> _books = [];
  late final StreamController<List<DatabaseBook>> _allBooksStreamController;
  Stream<List<DatabaseBook>> get allBooks => _allBooksStreamController.stream;
  // List<DatabaseBook> get allBooks => _books;

  static final BookService _shared = BookService._sharedInstance();
  BookService._sharedInstance() {
    _allBooksStreamController = StreamController<List<DatabaseBook>>.broadcast(
      onListen: () {
        _allBooksStreamController.sink.add(_books);
      },
    );
  }
  factory BookService() => _shared;

//Books
  Future<Iterable<DatabaseBook>> getAllBooks() async {
    final db = databaseSetup.getDatabase();
    final books = await db.query(
      bookTable,
    );
    return books.map((e) => DatabaseBook.fromRow(e));
  }

  Future<DatabaseBook> getBook({required int id}) async {
    final db = databaseSetup.getDatabase();
    final bookRow = await db.query(
      bookTable,
      where: 'id=?',
      whereArgs: [id],
    );
    if (bookRow.isEmpty) {
      throw BookNotFoundException();
    } else {
      final book = DatabaseBook.fromRow(bookRow.first);
      final index = _books.indexWhere((bookEntry) => bookEntry.id == id);
      _books[index] = book;
      _allBooksStreamController.add(_books);
      return book;
    }
  }

  Future<void> cacheAllBooks() async {
    final allBooks = await getAllBooks();
    _books = allBooks.toList();
    logger.d("All books are $_books");
    _allBooksStreamController.add(_books);
  }
}

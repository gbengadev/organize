import 'dart:async';
import 'package:flutterdemoapp/constants/database_objects.dart';
import 'package:flutterdemoapp/crud/database_user_books.dart';
import 'package:flutterdemoapp/crud/sqlite_user_service.dart';
import 'package:logger/logger.dart';
import 'book_service.dart';
import 'database_books.dart';
import 'database_exceptions.dart';
import 'database_setup.dart';

var logger = Logger();

class UserBookService {
  late DatabaseSetup databaseSetup = DatabaseSetup();
  late UserService userService = UserService();
  late BookService bookService = BookService();
  DatabaseUserBook? userBook;
  List<DatabaseBook> fave = [];
  List<DatabaseBook> _currentlyReadingList = [];
  List<DatabaseBook> _alreadyReadList = [];

  static final UserBookService _shared = UserBookService._sharedInstance();
  UserBookService._sharedInstance() {
    _favouriteListStreamController =
        StreamController<List<DatabaseBook>>.broadcast(
      onListen: () {
        _favouriteListStreamController.sink.add(fave);
      },
    );
    _currentlyReadingListStreamController =
        StreamController<List<DatabaseBook>>.broadcast(
      onListen: () {
        _currentlyReadingListStreamController.sink.add(_currentlyReadingList);
      },
    );
    _alreadyReadListStreamController =
        StreamController<List<DatabaseBook>>.broadcast(
      onListen: () {
        _alreadyReadListStreamController.sink.add(_alreadyReadList);
      },
    );
  }
  factory UserBookService() => _shared;

  late final StreamController<List<DatabaseBook>>
      _favouriteListStreamController;
  Stream<List<DatabaseBook>> get favouriteList =>
      _favouriteListStreamController.stream;

  late final StreamController<List<DatabaseBook>>
      _currentlyReadingListStreamController;
  Stream<List<DatabaseBook>> get readingList =>
      _currentlyReadingListStreamController.stream;

  late final StreamController<List<DatabaseBook>>
      _alreadyReadListStreamController;
  Stream<List<DatabaseBook>> get alreadyReadList =>
      _alreadyReadListStreamController.stream;

  // .filter((note) {
  //   final currentUser = _user;
  //   if (currentUser != null) {
  //     return note.userId == currentUser.id;
  //   } else {
  //     throw UserNotFoundAuthException();
  //   }
  // });

  Future<DatabaseUserBook?> getUserBook(int bookId, int userId) async {
    final db = databaseSetup.getDatabase();
    final myuserBook = await db.query(
      userBooksTable,
      where: '$bookIdFK=? and $userIdFK=? ',
      whereArgs: [bookId, userId],
    );
    if (myuserBook.isEmpty) {
      return null;
    }
    final ub = DatabaseUserBook.fromRow(myuserBook.first);
    userBook = ub;
    return ub;
  }

  Future<List<DatabaseBook>?> getUserFavouriteList(int userId) async {
    logger.d('in get favelist method beginning');
    final userFavourite = await getListByType(userId, isFavouriteFK);
    logger.d('$userId get user favourites is $userFavourite');
    final favouriteList = userFavourite.toList();
    logger.d('$userId get favourites is $favouriteList ');
    fave = favouriteList;
    _favouriteListStreamController.add(fave);
    logger.d('in get favelist method end');
    return favouriteList;
  }

  Future<Stream<List<DatabaseBook>>> getUserReadingList(int userId) async {
    logger.d('in get readiinglist method beginning');
    final userReadingList = await getListByType(userId, currentlyReadingFK);
    final currentlyReadingList = userReadingList.toList();
    _currentlyReadingList = currentlyReadingList;
    _currentlyReadingListStreamController.add(_currentlyReadingList);
    return readingList;
  }

  Future<List<DatabaseBook>?> getUserAlreadyReadList(int userId) async {
    logger.d('in get readiinglist method beginning');
    final userAlreadyReadList = await getListByType(userId, hasBeenReadFK);
    final alreadyReadList = userAlreadyReadList.toList();
    _alreadyReadList = alreadyReadList;
    _alreadyReadListStreamController.add(_alreadyReadList);
    return alreadyReadList;
  }

  Future<Iterable<DatabaseBook>> getListByType(
    int userId,
    String listType,
  ) async {
    final db = databaseSetup.getDatabase();
    final userBooks = await db.rawQuery(
        '''Select $bookTable.* from $bookTable JOIN $userBooksTable ON $bookTable.id= $userBooksTable.book_id where $userBooksTable.user_id=$userId and $userBooksTable.$listType=1;''');
    //logger.d('fav one time userbooks $userBooks');
    return userBooks.map((e) => DatabaseBook.fromRow(e));
  }

//Add book to favourite/ reading/ already read list
  Future<void> addBookToList(int userId, int bookId, String listType) async {
    final db = databaseSetup.getDatabase();
    final user = await userService.getUser(userId: userId);
    final book = await bookService.getBook(id: bookId);
    final userBook = await getUserBook(bookId, user.id);
    int isFavourite = listType == isFavouriteFK ? 1 : 0;
    int currentlyReading = listType == currentlyReadingFK ? 1 : 0;
    int hasBeenRead = listType == hasBeenReadFK ? 1 : 0;
    int createdId = book.id;

    if (userBook != null) {
      final count = await db.rawUpdate(
          'UPDATE $userBooksTable SET $listType=? where $userBookIdColumn=?',
          [1, userBook.id]);
      logger.d('updated add count is $count');
    } else {
      final value = {
        userIdFK: user.id,
        bookIdFK: bookId,
        bookNameFK: book.bookName,
        isFavouriteFK: isFavourite,
        currentlyReadingFK: currentlyReading,
        hasBeenReadFK: hasBeenRead
      };
      createdId = await db.insert(userBooksTable, value);
      logger.d('Created id is $createdId');
    }

    final createdBook = DatabaseBook(
        id: bookId,
        bookName: book.bookName,
        author: book.author,
        overview: book.overview,
        aboutAuthor: book.aboutAuthor,
        imageUrl: book.imageUrl,
        isbn: book.isbn,
        publisher: book.publisher,
        publicationDate: book.publicationDate,
        series: book.series,
        pages: book.pages,
        salesRank: book.salesRank,
        productDimensions: book.productDimensions,
        isFavourite: book.isFavourite,
        hasBeenRead: book.hasBeenRead,
        currentlyReading: book.currentlyReading);

    if (isFavourite == 1) {
      logger.d('in favourite add to stream controller');
      fave.add(createdBook);
      _favouriteListStreamController.add(fave);
    } else if (currentlyReading == 1) {
      _currentlyReadingList.add(createdBook);
      _currentlyReadingListStreamController.add(_currentlyReadingList);
    } else {
      _alreadyReadList.add(createdBook);
      _alreadyReadListStreamController.add(_alreadyReadList);
    }
    // notifyListeners();
    //return createdUserBook;
  }

  Future<bool> removeBookFromList(
      int userId, int bookId, String listType) async {
    final db = databaseSetup.getDatabase();
    final user = await userService.getUser(userId: userId);
    final userBook = await getUserBook(bookId, user.id);
    if (userBook != null) {
      final updatedRows = await db.rawUpdate(
          'UPDATE $userBooksTable SET $listType=? WHERE $userBookIdColumn=?',
          [0, userBook.id]);
      logger
          .d('Book removed from list and updated remove count is $updatedRows');
      //Remove the row if all lists for the userbook are set to 0
      if (userBook.currentlyReading == 0 &&
          userBook.hasBeenRead == 0 &&
          userBook.isFavourite == 0) {
        try {
          final deletedUserBook = await db.delete(userBooksTable,
              where: '$userBookIdColumn=?', whereArgs: [userBook.id]);
          if (deletedUserBook == 1) {
            _removeUserbookFromStream(userBook, bookId, listType);
            return true;
          }
        } catch (_) {
          throw CouldNotDeleteUserBookException();
        }
      }
      //If update was successful remove userbook from stream
      if (updatedRows > 0) {
        _removeUserbookFromStream(userBook, bookId, listType);
        return true;
      } else {
        throw CouldNotUpdateUserBookException();
      }
    }
    // notifyListeners();
    return false;
  }

  void _removeUserbookFromStream(
      DatabaseUserBook userBook, int bookId, String listType) {
    if (userBook.currentlyReading == 0 && listType == currentlyReadingFK) {
      _currentlyReadingList.removeWhere((book) => book.id == bookId);
      _currentlyReadingListStreamController.add(_currentlyReadingList);
      logger.d("$bookId is removed from creading stream");
    } else if (userBook.hasBeenRead == 0 && listType == hasBeenReadFK) {
      _alreadyReadList.removeWhere((book) => book.id == bookId);
      _alreadyReadListStreamController.add(_alreadyReadList);
      logger.d("$bookId is removed from hsbeenread stream");
    } else {
      fave.removeWhere((book) => book.id == bookId);
      _favouriteListStreamController.add(fave);
      logger.d("$bookId is removed from fave stream");
    }
  }
}

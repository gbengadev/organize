import 'package:flutterdemoapp/constants/database_objects.dart';

class DatabaseUserBook {
  final int id;
  final int userId;
  final int bookId;
  final String bookName;
  int isFavourite;
  int currentlyReading;
  int hasBeenRead;

  DatabaseUserBook(
      {required this.id,
      required this.userId,
      required this.bookId,
      required this.bookName,
      required this.isFavourite,
      required this.currentlyReading,
      required this.hasBeenRead});

  DatabaseUserBook.fromRow(Map<String, Object?> map)
      : id = map[userBookIdColumn] as int,
        userId = map[userIdFK] as int,
        bookId = map[bookIdFK] as int,
        bookName = map[bookNameFK] as String,
        isFavourite = map[isFavouriteFK] as int,
        currentlyReading = map[currentlyReadingFK] as int,
        hasBeenRead = map[hasBeenReadFK] as int;
}

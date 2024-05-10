import 'package:flutterdemoapp/constants/database_objects.dart';

class DatabaseBook {
  final int id;
  final String bookName;
  final String author;
  final String overview;
  final String aboutAuthor;
  final String imageUrl;
  final String isbn;
  final String publisher;
  final String publicationDate;
  final String series;
  final int pages;
  final int salesRank;
  final String productDimensions;
  int isFavourite;
  int hasBeenRead;
  int currentlyReading;

  DatabaseBook(
      {required this.id,
      required this.bookName,
      required this.author,
      required this.overview,
      required this.aboutAuthor,
      required this.imageUrl,
      required this.isbn,
      required this.publisher,
      required this.publicationDate,
      required this.series,
      required this.pages,
      required this.salesRank,
      required this.productDimensions,
      required this.isFavourite,
      required this.hasBeenRead,
      required this.currentlyReading});

  DatabaseBook.fromRow(Map<String, Object?> map)
      : id = map[bookIdColumn] as int,
        bookName = map[bookNameColumn] as String,
        author = map[authorColumn] as String,
        overview = map[overviewColumn] as String,
        aboutAuthor = map[aboutAuthorColumn] as String,
        imageUrl = map[imageUrlColumn] as String,
        isbn = map[isbnColumn] as String,
        publisher = map[publisherColumn] as String,
        publicationDate = map[publicationDateColumn] as String,
        series = map[seriesColumn] as String,
        pages = map[pagesColumn] as int,
        salesRank = map[salesRankColumn] as int,
        productDimensions = map[productDimensionsColumn] as String,
        isFavourite = map[isFavouriteColumn] as int,
        hasBeenRead = map[hasBeenReadColumn] as int,
        currentlyReading = map[currentlyReadingColumn] as int;

  @override
  String toString() {
    return '{id: $id,name: $bookName }';
  }
}

import 'package:flutter/material.dart';
import 'package:flutterdemoapp/constants/database_objects.dart';
import 'package:flutterdemoapp/constants/styles.dart';
import 'package:flutterdemoapp/constants/text.dart';
import 'package:flutterdemoapp/crud/database_user_books.dart';
import 'package:flutterdemoapp/crud/userbook_service.dart';
import 'package:logger/logger.dart';
import '../crud/database_books.dart';
import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';

DatabaseBook? _book;
var logger = Logger();

class BookPage extends StatefulWidget {
  final Function() onListToggled;
  final DatabaseBook book;
  final int userId;
  final DatabaseUserBook? userBook;
  const BookPage(
      {super.key,
      required this.onListToggled,
      required this.book,
      required this.userId,
      required this.userBook});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late final UserBookService userBookService;

  @override
  void initState() {
    super.initState();
    userBookService = UserBookService();
    _book = widget.book;
  }

//This is preferred to initState method to safely access the context from homepage
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
  }

  late String favouriteListText = widget.userBook?.isFavourite == 1
      ? 'Remove from Favorites'
      : 'Add to Favourites';
  late String readingListText = widget.userBook?.currentlyReading == 1
      ? 'Remove from Reading List'
      : 'Add to Reading List';
  late String alreadyReadListText = widget.userBook?.hasBeenRead == 1
      ? 'Remove from Already Read List'
      : 'Add to Already Read List';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.bookName),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    //loadingBuilder: (context, child, loadingProgress) =>
                    //  const CircularProgressIndicator(),
                    errorBuilder: (context, url, error) =>
                        const Icon(Icons.error),
                    widget.book.imageUrl,
                    width: 143,
                    height: 180,
                    alignment: Alignment.topLeft,
                    fit: BoxFit.fill,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.bookName,
                      ),
                      Text(
                        'By ${widget.book.author}',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              FilledButton(
                onPressed: addToFavourites,
                style: FilledButton.styleFrom(
                  fixedSize: const Size.fromWidth(200),
                ),
                child: Text(favouriteListText),
              ),
              const SizedBox(
                height: 15,
              ),
              FilledButton(
                onPressed: addToReadingList,
                style: FilledButton.styleFrom(
                  fixedSize: const Size.fromWidth(200),
                ),
                child: Text(readingListText),
              ),
              const SizedBox(
                height: 15,
              ),
              FilledButton(
                onPressed: addToAlreadyReadList,
                style: FilledButton.styleFrom(
                  fixedSize: const Size.fromWidth(200),
                ),
                child: Text(alreadyReadListText),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text('Overview'),
              const SizedBox(
                height: 15,
              ),
              const Text(overviewText),
              const SizedBox(
                height: 15,
              ),
              const DefaultTabController(
                length: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TabBar(
                      tabs: [
                        Tab(
                          child: Text(
                            'Product Details',
                            style: TAB_STYLE,
                          ),
                        ),
                        Tab(
                          child: Text('About the Author', style: TAB_STYLE),
                        ),
                      ],
                    ),
                    AutoScaleTabBarView(
                      children: [DetailsTab(), AboutTheAuthor()],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addToFavourites() {
    logger.d('Userbook is ${widget.userBook}');
    logger.d('UserId is ${widget.userId}');
    logger.d('UserId is ${widget.book.id}');
    var snackBar = const SnackBar(
        content: Text('Book added to favourite list successfully'));
    if (widget.userBook != null && widget.userBook!.isFavourite == 1) {
      logger.d('Userbook fave is ${widget.userBook!.isFavourite}');
      userBookService.removeBookFromList(
          widget.userId, widget.book.id, isFavouriteFK);
      setState(() {
        widget.userBook!.isFavourite = 0;
        // _book!.isFavourite = 0;
        favouriteListText = 'Add To Favourites';
      });
      snackBar = const SnackBar(
          content: Text('Book removed from favourite list successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      userBookService.addBookToList(
          widget.userId, widget.book.id, isFavouriteFK);
      setState(() {
        logger.d('In second set');
        // _book!.isFavourite = 1;
        widget.userBook!.isFavourite = 1;
        favouriteListText = 'Remove from Favourites';
      });
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    widget.onListToggled;
  }

  void addToReadingList() {
    var snackBar = const SnackBar(
        content: Text('Book added to currently reading list successfully'));
    if (widget.userBook != null && widget.userBook!.currentlyReading == 1) {
      userBookService.removeBookFromList(
          widget.userBook!.userId, widget.book.id, currentlyReadingFK);
      setState(() {
        widget.userBook!.currentlyReading = 0;
        readingListText = 'Add To Reading List';
      });
      snackBar = const SnackBar(
          content:
              Text('Book removed from currently reading list successfully'));
      //Display snack bar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      userBookService.addBookToList(
          widget.userId, widget.book.id, currentlyReadingFK);
      setState(() {
        widget.userBook!.currentlyReading = 1;
        readingListText = 'Remove from Reading List';
      });
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    widget.onListToggled;
  }

  void addToAlreadyReadList() {
    var snackBar = const SnackBar(
        content: Text('Book added to already read list successfully'));
    if (widget.userBook != null && widget.userBook!.hasBeenRead == 1) {
      userBookService.removeBookFromList(
          widget.userBook!.userId, widget.book.id, hasBeenReadFK);
      setState(() {
        widget.userBook!.hasBeenRead = 0;
        alreadyReadListText = 'Add To Already Read List';
      });
      snackBar = const SnackBar(
          content: Text('Book removed from already read list successfully'));
      //Display snack bar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      userBookService.addBookToList(
          widget.userId, widget.book.id, hasBeenReadFK);
      setState(() {
        widget.userBook!.hasBeenRead = 1;
        alreadyReadListText = 'Remove from Already Read List';
      });
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    widget.onListToggled;
  }
}

//Book details tab view
class DetailsTab extends StatelessWidget {
  const DetailsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Product Details'),
        ),
        Row(
          children: [
            const SizedBox(width: 180, child: Text('ISBN-13')),
            Text(
              _book!.isbn,
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 180, child: Text('Publisher')),
            Text(_book!.publisher)
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 180, child: Text('Publication date')),
            Text(_book!.publicationDate)
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 180, child: Text('Series')),
            Text(_book!.series)
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 180, child: Text('Pages')),
            Text(_book!.pages.toString()),
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 180, child: Text('Sales rank')),
            Text(_book!.salesRank.toString())
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 180, child: Text('Product dimensions')),
            Text(_book!.productDimensions)
          ],
        ),
      ],
    );
  }
}

//About the author tab details

class AboutTheAuthor extends StatelessWidget {
  const AboutTheAuthor({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.network(
            _book!.imageUrl,
            width: 143,
            height: 180,
            alignment: Alignment.topLeft,
            fit: BoxFit.fill,
          ),
        ),
        Text(_book!.aboutAuthor),
      ],
    );
  }
}

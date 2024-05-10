import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterdemoapp/constants/colors.dart';
import 'package:flutterdemoapp/constants/database_objects.dart';
import 'package:flutterdemoapp/crud/database_books.dart';
import 'package:flutterdemoapp/views/book.dart';
import 'package:logger/logger.dart';
import '../auth/auth_user.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_state.dart';
import '../crud/book_service.dart';
import '../crud/userbook_service.dart';

var logger = Logger();

class HomePage extends StatefulWidget {
  final AuthUser? user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final BookService _bookService;
  late final UserBookService _userBookService;
  late Stream<List<DatabaseBook>> _allBooks;
  Icon filledFavouriteIcon = const Icon(Icons.favorite_rounded);
  Icon borderedFavouriteIcon = const Icon(Icons.favorite_border_outlined);
  String title = "All Books";
  bool isFavourite = false;
  int selectedIndex = 0;
  int? userId;

  bool dropdown = false;
  double cardHeight = 220.0;
  late List<DatabaseBook>? favlist;

  @override
  initState() {
    super.initState();
    _bookService = BookService();
    _userBookService = UserBookService();
    userId = widget.user!.id;
    getFavouriteList().then((value) => favlist = value);
    _allBooks = _bookService.allBooks;
  }

  Future<List<DatabaseBook>?> getFavouriteList() async {
    var fave = await _userBookService.getUserFavouriteList(userId!);
    return fave;
  }

  Future<Stream<List<DatabaseBook>>> getReadingList() async {
    return _userBookService.getUserReadingList(userId!);
  }

  Future<void> getAlreadyReadList() async {
    await _userBookService.getUserAlreadyReadList(userId!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        logger.d("State on homepage is $state");
        if (state is AuthStateLoggedIn) {
          logger.d("User on homepage is ${widget.user}");
          userId = widget.user!.id;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: SingleChildScrollView(
            child: StreamBuilder(
                stream: _allBooks,
                // initialData: _books,
                builder: (context, allBooksSnapshot) {
                  logger.d("YES BOSS");
                  logger.d(allBooksSnapshot.connectionState);
                  switch (allBooksSnapshot.connectionState) {
                    // case ConnectionState.waiting:
                    case ConnectionState.active:
                      logger.d(allBooksSnapshot.data);
                      if (allBooksSnapshot.hasData &&
                          allBooksSnapshot.data!.isNotEmpty) {
                        List<DatabaseBook> books = allBooksSnapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GridView.builder(
                              itemCount: books.length,
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                              ),
                              itemBuilder: (context, index) {
                                final favouriteList = favlist;
                                logger.d('All books length is ${books.length}');
                                final book = books.elementAt(index);
                                if (favouriteList != null) {
                                  logger.d('favourite list is $favouriteList');
                                  isFavourite = favouriteList.any(
                                      (favouriteBook) =>
                                          favouriteBook.id == book.id);
                                  if (isFavourite) {
                                    book.isFavourite = 1;
                                  } else {
                                    book.isFavourite = 0;
                                  }
                                  logger.d(
                                      'item builder isFavourite is ${book.isFavourite} at index $index and book is ${book.id}');
                                }
                                //logger.d( "UserId on homepage is ${widget.user!.id}");
                                return GestureDetector(
                                  key: ValueKey(index),
                                  onTap: () async {
                                    var userBooks = await _userBookService
                                        .getUserBook(book.id, userId!);
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BookPage(
                                                  book: book,
                                                  userId: userId!,
                                                  userBook: userBooks,
                                                  onListToggled: reloadList,
                                                )));
                                  },
                                  child: Card(
                                    elevation: 4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Image.network(
                                          book.imageUrl,
                                          height: 100,
                                          width: double.infinity,
                                          fit: BoxFit.fitWidth,
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 5, 0, 5),
                                              child: Text(
                                                book.bookName,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text("by"),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 0, 0, 0),
                                            child: Text(
                                              book.author,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: (book.isFavourite == 1)
                                                  ? filledFavouriteIcon
                                                  : borderedFavouriteIcon,
                                              color: Colors.red,
                                              iconSize: 22,
                                              onPressed: () {
                                                switchFavouriteIcons(
                                                    isFavourite, book);
                                              },
                                            ),
                                            IconButton(
                                              onPressed: dropDownCard,
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_up),
                                              iconSize: 30,
                                            ),
                                            // Visibility(
                                            //     visible: dropdown,
                                            //     child: Text(
                                            //         "Published by ${book.publisher}"))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        );
                      } else {
                        logger.d("NO DATA IN STREAM");
                        return const Center(
                          child: Text("No data here"),
                        );
                      }

                    default:
                      return const CircularProgressIndicator();
                  }
                }),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books_sharp),
                label: 'All Books',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_sharp),
                  label: 'Favourite',
                  backgroundColor: Colors.white),
              BottomNavigationBarItem(
                icon: Icon(Icons.read_more_sharp),
                label: 'Reading',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mark_chat_read_sharp),
                label: 'Already Read',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            selectedItemColor: PRIMARY_COLOR,
            selectedLabelStyle: const TextStyle(
              overflow: TextOverflow.visible,
            ),
            onTap: toggleList,
          )),
    );
  }

  void dropDownCard() {
    setState(() {
      dropdown = !dropdown;
      //cardHeight = dropdown ? 220 : 200;
    });
  }

  Future<Stream<List<DatabaseBook>>> toggleList(int index) async {
    Stream<List<DatabaseBook>> books;
    if (index == 0) {
      books = _bookService.allBooks;
      setState(() {
        _allBooks = books;
        selectedIndex = index;
        title = "All Books";
      });
    } else if (index == 1) {
      books = _userBookService.favouriteList;
      var fav = await _userBookService.getUserFavouriteList(userId!);
      favlist = fav;
      logger.d("Fave streeeeam");
      setState(() {
        selectedIndex = index;
        _allBooks = books;
        favlist = fav;
        title = "Favourite List";
      });
    } else if (index == 2) {
      logger.d("Reading streeeeam");
      //await _userBookService.getUserReadingList(userId!);
      books = _userBookService.readingList;
      setState(() {
        selectedIndex = index;
        _allBooks = books;
        title = "Reading List";
      });
    } else {
      getAlreadyReadList();
      books = _userBookService.alreadyReadList;
      setState(() {
        selectedIndex = index;
        _allBooks = books;
        title = "Already Read List";
      });
    }

    return books;
  }

  void switchFavouriteIcons(bool isFavourite, DatabaseBook book) async {
    logger.d('in switchMethod');
    logger.d('book id is ${book.id}');
    logger.d('switch favourite is ${book.isFavourite}');
    if (book.isFavourite == 0) {
      await _userBookService.addBookToList(
          widget.user!.id, book.id, isFavouriteFK);
      setState(() {
        book.isFavourite = 1;
      });
    } else {
      await _userBookService.removeBookFromList(
          widget.user!.id, book.id, isFavouriteFK);
      setState(() {
        book.isFavourite = 0;
      });
    }
  }

  void reloadList() {
    if (mounted) {
      setState(() {});
    }
  }
}

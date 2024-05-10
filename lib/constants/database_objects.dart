//Database name
const databaseName = 'BookLibrary.db';

//User table
const userTable = 'User';
const idColumn = 'id';
const usernameColumn = 'username';
const passwordColumn = 'password';

//Book table
const bookIdColumn = 'id';
const bookTable = 'Books';
const bookNameColumn = 'name';
const authorColumn = 'author';
const overviewColumn = 'overview';
const aboutAuthorColumn = 'about_author';
const imageUrlColumn = 'image_url';
const isbnColumn = 'isbn';
const publisherColumn = 'publisher';
const publicationDateColumn = 'publication_date';
const seriesColumn = 'series';
const pagesColumn = 'pages';
const salesRankColumn = 'sales_rank';
const productDimensionsColumn = 'product_dimensions';
const isFavouriteColumn = 'is_favourite';
const hasBeenReadColumn = 'has_been_read';
const currentlyReadingColumn = 'currently_reading';

//User books table
const userBooksTable = 'User_Books';
const userBookIdColumn = 'id';
const userIdFK = 'user_id';
const bookIdFK = 'book_id';
const bookNameFK = 'book_name';
const isFavouriteFK = 'is_favourite';
const currentlyReadingFK = 'currently_reading';
const hasBeenReadFK = 'has_been_read';

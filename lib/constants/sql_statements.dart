const createBookTable = '''
CREATE TABLE  IF NOT EXISTS Books (
    id                 INTEGER NOT NULL PRIMARY KEY,
    name               TEXT NOT NULL,
    author             TEXT NOT NULL,
    overview           TEXT NOT NULL,
    about_author       TEXT NOT NULL,
    image_url          TEXT NOT NULL,
    isbn               TEXT NOT NULL,
    publisher          TEXT NOT NULL,
    publication_date   TEXT NOT NULL,
    series             TEXT NOT NULL,
    pages              INTEGER NOT NULL,
    sales_rank         INTEGER NOT NULL,
    product_dimensions TEXT NOT NULL,
    is_favourite       INTEGER DEFAULT (0),
    has_been_read      INTEGER DEFAULT (0),
    currently_reading  INTEGER DEFAULT (0)
);
''';
const createUserBooksTable = '''
CREATE TABLE  IF NOT EXISTS User_Books (
    id                INTEGER PRIMARY KEY AUTOINCREMENT
                              NOT NULL,
    user_id           INTEGER REFERENCES User (id) 
                              NOT NULL,
    book_id           INTEGER REFERENCES Books (id) 
                              NOT NULL,
    book_name         TEXT    NOT NULL,
    is_favourite      INTEGER DEFAULT (0),
    currently_reading INTEGER DEFAULT (0),
    has_been_read     INTEGER DEFAULT (0) 
);
''';

const createUserTable =
    "CREATE TABLE IF NOT EXISTS User (id  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, username TEXT    UNIQUE NOT NULL, password TEXT    NOT NULL);";

// ignore: prefer_interpolation_to_compose_strings
const insertBooksString = "INSERT INTO Books (\n" +
    "                      id,\n" +
    "                      name,\n" +
    "                      author,\n" +
    "                      overview,\n" +
    "                      about_author,\n" +
    "                      image_url,\n" +
    "                      isbn,\n" +
    "                      publisher,\n" +
    "                      publication_date,\n" +
    "                      series,\n" +
    "                      pages,\n" +
    "                      sales_rank,\n" +
    "                      product_dimensions,\n" +
    "                      is_favourite,\n" +
    "                      has_been_read,\n" +
    "                      currently_reading\n" +
    "                  )\n" +
    "                  VALUES (\n" +
    "                      1,\n" +
    "                      'Book 1',\n" +
    "                      'John Smith',\n" +
    "                      'A gripping tale of mystery and suspense.',\n" +
    "                      'John Smith is an award-winning author known for his captivating storytelling skills. With a career spanning over two decades, he has written numerous bestsellers that have enthralled readers worldwide. His unique ability to create intricate plots, compelling characters, and unexpected twists has earned him critical acclaim and a dedicated fan base. John''s passion for literature shines through in his writing, transporting readers to thrilling and immersive worlds.',\n" +
    "                      'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1295750108i/8164754.jpg',\n" +
    "                      'ISBN1',\n" +
    "                      'Publisher 1',\n" +
    "                      '2021-01-01',\n" +
    "                      'Series 1',\n" +
    "                      200,\n" +
    "                      10,\n" +
    "                      '10x15x2',\n" +
    "                      0,\n" +
    "                      0,\n" +
    "                      0\n" +
    "                  );\n" +
    "\n" +
    "INSERT INTO Books (\n" +
    "                      id,\n" +
    "                      name,\n" +
    "                      author,\n" +
    "                      overview,\n" +
    "                      about_author,\n" +
    "                      image_url,\n" +
    "                      isbn,\n" +
    "                      publisher,\n" +
    "                      publication_date,\n" +
    "                      series,\n" +
    "                      pages,\n" +
    "                      sales_rank,\n" +
    "                      product_dimensions,\n" +
    "                      is_favourite,\n" +
    "                      has_been_read,\n" +
    "                      currently_reading\n" +
    "                  )\n" +
    "                  VALUES (\n" +
    "                      2,\n" +
    "                      'Book 2',\n" +
    "                      'Emma Johnson',\n" +
    "                      'An epic fantasy adventure filled with magic and intrigue.',\n" +
    "                      'Emma Johnson is a highly imaginative writer with a passion for world-building. Her enchanting storytelling transports readers to mesmerizing realms where mythical creatures roam and epic battles unfold. With her lyrical prose and attention to detail, Emma weaves intricate narratives that leave readers spellbound. She is hailed as a rising star in the fantasy genre and continues to captivate audiences with her boundless creativity and vivid imagination.',\n" +
    "                      'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1400436772i/17277854.jpg',\n" +
    "                      'ISBN2',\n" +
    "                      'Publisher 2',\n" +
    "                      '2021-02-01',\n" +
    "                      'Series 2',\n" +
    "                      250,\n" +
    "                      15,\n" +
    "                      '12x18x3',\n" +
    "                      0,\n" +
    "                      0,\n" +
    "                      0\n" +
    "                  );\n" +
    "\n" +
    "INSERT INTO Books (\n" +
    "                      id,\n" +
    "                      name,\n" +
    "                      author,\n" +
    "                      overview,\n" +
    "                      about_author,\n" +
    "                      image_url,\n" +
    "                      isbn,\n" +
    "                      publisher,\n" +
    "                      publication_date,\n" +
    "                      series,\n" +
    "                      pages,\n" +
    "                      sales_rank,\n" +
    "                      product_dimensions,\n" +
    "                      is_favourite,\n" +
    "                      has_been_read,\n" +
    "                      currently_reading\n" +
    "                  )\n" +
    "                  VALUES (\n" +
    "                      3,\n" +
    "                      'Book 3',\n" +
    "                      'Michael Brown',\n" +
    "                      'A heartwarming story of love, loss, and redemption.',\n" +
    "                      'Michael Brown is a bestselling author known for his emotionally charged narratives that resonate deeply with readers. His profound exploration of the human condition and heartfelt storytelling have touched the hearts of millions. Through his poignant prose and relatable characters, Michael delves into themes of love, loss, and redemption, inviting readers on an emotional journey of self-discovery and healing. His books have garnered widespread praise for their authenticity and ability to evoke powerful emotions.',\n" +
    "                      'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1264898635i/7157310.jpg',\n" +
    "                      'ISBN3',\n" +
    "                      'Publisher 3',\n" +
    "                      '2021-03-01',\n" +
    "                      'Series 3',\n" +
    "                      300,\n" +
    "                      20,\n" +
    "                      '11x16x2',\n" +
    "                      0,\n" +
    "                      0,\n" +
    "                      0\n" +
    "                  );\n" +
    "\n" +
    "INSERT INTO Books (\n" +
    "                      id,\n" +
    "                      name,\n" +
    "                      author,\n" +
    "                      overview,\n" +
    "                      about_author,\n" +
    "                      image_url,\n" +
    "                      isbn,\n" +
    "                      publisher,\n" +
    "                      publication_date,\n" +
    "                      series,\n" +
    "                      pages,\n" +
    "                      sales_rank,\n" +
    "                      product_dimensions,\n" +
    "                      is_favourite,\n" +
    "                      has_been_read,\n" +
    "                      currently_reading\n" +
    "                  )\n" +
    "                  VALUES (\n" +
    "                      4,\n" +
    "                      'Book 4',\n" +
    "                      'Emily Davis',\n" +
    "                      'A thrilling science fiction tale set in a dystopian future.',\n" +
    "                      'Emily Davis is a rising star in the sci-fi genre, pushing boundaries with her imaginative concepts and thought-provoking narratives. Her visionary exploration of futuristic worlds and technological advancements captivates readers, raising profound questions about the human condition and the impact of technology on society. With her gripping storytelling and intricate world-building, Emily continues to redefine the boundaries of science fiction, leaving readers on the edge of their seats and craving more.',\n" +
    "                      'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1391963345i/13481282.jpg',\n" +
    "                      'ISBN4',\n" +
    "                      'Publisher 4',\n" +
    "                      '2021-04-01',\n" +
    "                      'Series 4',\n" +
    "                      350,\n" +
    "                      25,\n" +
    "                      '9x12x1',\n" +
    "                      0,\n" +
    "                      0,\n" +
    "                      0\n" +
    "                  );\n" +
    "\n" +
    "INSERT INTO Books (\n" +
    "                      id,\n" +
    "                      name,\n" +
    "                      author,\n" +
    "                      overview,\n" +
    "                      about_author,\n" +
    "                      image_url,\n" +
    "                      isbn,\n" +
    "                      publisher,\n" +
    "                      publication_date,\n" +
    "                      series,\n" +
    "                      pages,\n" +
    "                      sales_rank,\n" +
    "                      product_dimensions,\n" +
    "                      is_favourite,\n" +
    "                      has_been_read,\n" +
    "                      currently_reading\n" +
    "                  )\n" +
    "                  VALUES (\n" +
    "                      5,\n" +
    "                      'Book 5',\n" +
    "                      'Daniel Wilson',\n" +
    "                      'A thought-provoking exploration of artificial intelligence and its impact on society.',\n" +
    "                      'Daniel Wilson is a renowned author and roboticist, merging science and fiction seamlessly. His deep understanding of technological advancements and their potential consequences allows him to craft compelling narratives that delve into the ethical and societal implications of artificial intelligence. Daniel''s expertise and imagination shine through in his works, challenging readers to ponder the boundaries of human existence and the ever-evolving relationship between humans and machines.',\n" +
    "                      'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1344216126i/8164566.jpg',\n" +
    "                      'ISBN5',\n" +
    "                      'Publisher 5',\n" +
    "                      '2021-05-01',\n" +
    "                      'Series 5',\n" +
    "                      400,\n" +
    "                      30,\n" +
    "                      '8x10x1',\n" +
    "                      0,\n" +
    "                      0,\n" +
    "                      0\n" +
    "                  )";

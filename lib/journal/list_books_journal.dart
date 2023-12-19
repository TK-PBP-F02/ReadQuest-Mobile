import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
//import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class Book {
  final String isbn;
  final String title;
  final String author;
  final String description;
  final String publisher;
  final String pageCount;
  final String category;
  final String language;
  final String publicationDate;
  final String imageUrl;

  Book({
    required this.isbn,
    required this.title,
    required this.author,
    required this.description,
    required this.publisher,
    required this.pageCount,
    required this.category,
    required this.language,
    required this.publicationDate,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'isbn': isbn,
      'title': title,
      'author': author,
      'description': description,
      'publisher': publisher,
      'pageCount': pageCount,
      'category': category,
      'language': language,
      'publicationDate': publicationDate,
      'imageUrl': imageUrl,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      isbn: map['isbn'],
      title: map['title'],
      author: map['author'],
      description: map['description'],
      publisher: map['publisher'],
      pageCount: map['pageCount'],
      category: map['category'],
      language: map['language'],
      publicationDate: map['publicationDate'],
      imageUrl: map['imageUrl'],
    );
  }
}

class JournalPage extends StatefulWidget {
  final List<Book> books;

  JournalPage({required this.books});

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late List<Book> books;

  @override
  void initState() {
    super.initState();
    books = widget.books;
    loadBooksFromSharedPreferences();
    loadBooksFromDjangoService();
  }
  Future<List<Book>> fetchBooks() async {
  var url = Uri.parse('https://readquest-f02-tk.pbp.cs.ui.ac.id/json/');
  var response = await http.get(
    url,
    headers: {"Content-Type": "application/json"},
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Book> books = [];
    for (var bookData in data) {
      if (bookData != null) {
        books.add(Book.fromMap(bookData));
      }
    }
    return books;
  } else {
    throw Exception('Failed to load books');
  }
}
  Future<void> loadBooksFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final bookData = prefs.getStringList('books') ?? [];
    setState(() {
      books = bookData.map((e) => Book.fromMap(json.decode(e))).toList();
    });
  }

  Future<void> loadBooksFromDjangoService() async {
    try {
      List<Book> fetchedBooks = await fetchBooks(); 
      setState(() {
        books = fetchedBooks;
      });
    } catch (e) {
      // Handle error
      print('Failed to fetch books from Django service: $e');
    }
  }

  Future<void> saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookData = books.map((e) => json.encode(e.toMap())).toList();
    await prefs.setStringList('books', bookData);
  }

  Future<void> _navigateToAddBookPage() async {
    final newBook = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddBookPage()),
    );

    if (newBook != null && newBook is Book) {
      setState(() {
        books.add(newBook);
      });
      saveBooks(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User-Created Books'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: _navigateToAddBookPage,
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    size: 28,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Add User-Created Book',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: books.isEmpty
          ? Center(child: Text('No books added yet.'))
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookDetailPage(book: books[index]),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            books[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                books[index].title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'By ${books[index].author}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}


class AddBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Book'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: BookForm(),
      ),
    );
  }
}

class BookForm extends StatefulWidget {
  @override
  _BookFormState createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  final _formKey = GlobalKey<FormState>();

  late String _isbn;
  late String _title;
  late String _author;
  late String _description;
  late String _publisher;
  late String _pageCount;
  late String _category;
  late String _language;
  late String _publicationDate;
  late String _imageUrl;

  Future<void> saveBookToJournal() async { //No async before
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Kirim ke Django dan tunggu respons
        // final response = await request.postJson(
        // "http://localhost:8000/create-flutter/",
        // jsonEncode(<String, String>{
        //     isbn: _isbn,
        //     title: _title,
        //     author: _author,
        //    description: _description,
        //    publisher: _publisher,
        //    pageCount: _pageCount,
        //    category: _category,
        //    language: _language,
        //    publicationDate: _publicationDate,
        //    imageUrl: _imageUrl,
        // }));
      Book newBook = Book(
        isbn: _isbn,
        title: _title,
        author: _author,
        description: _description,
        publisher: _publisher,
        pageCount: _pageCount,
        category: _category,
        language: _language,
        publicationDate: _publicationDate,
        imageUrl: _imageUrl,
      );
      Navigator.pop(context, newBook);
    }
  }

  @override
  Widget build(BuildContext context) {
    //final request = context.watch<CookieRequest>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'ISBN'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter ISBN';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _isbn = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Author'),
                  onSaved: (value) {
                    _author = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Publisher'),
                  onSaved: (value) {
                    _publisher = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Page Count'),
                  onSaved: (value) {
                    _pageCount = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Category'),
                  onSaved: (value) {
                    _category = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Language'),
                  onSaved: (value) {
                    _language = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Publication Date'),
                  onSaved: (value) {
                    _publicationDate = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Image URL'),
                  onSaved: (value) {
                    _imageUrl = value!;
                  },
                ),
                ElevatedButton(
                  onPressed: saveBookToJournal,
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                book.imageUrl,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return CircularProgressIndicator();
                },
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error);
                },
              ),
              Text("${book.title}"),
              Text("Author: ${book.author}"),
              Text("Published Date: ${book.publicationDate}"),
              Text("Publisher: ${book.publisher}"),
              Text("Publication Date: ${book.publicationDate}"),
              Text("Page Count: ${book.pageCount}"),
              Text("Category: ${book.category}"),
              Text("Description: ${book.description}"),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Back to Book List"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

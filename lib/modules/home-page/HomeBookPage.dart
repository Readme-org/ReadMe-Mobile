import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:readme/modules/list-book/list.dart';
import 'package:readme/widgets/appbar.dart';
import 'package:readme/widgets/navbar.dart';
import 'package:readme/widgets/background.dart';
import 'package:readme/core/url.dart' as app_data;

class HomebookPage extends StatefulWidget {
  const HomebookPage({Key? key}) : super(key: key);

  @override
  BookPageState createState() => BookPageState();
}

class BookPageState extends State<HomebookPage> with TickerProviderStateMixin {
  String placeholder = 'Search for books...';
  TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 15))
      ..repeat(reverse: true);
    _colorTween = ColorTween(begin: Colors.blue.shade400, end: Colors.blue.shade900)
      .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<List<Book>> _searchBooks(String query) async {
    final response = await http.post(
      Uri.parse('${app_data.baseUrl}/search-books/'),


      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'query': query}),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<Book> books = [];
      for (var bookData in jsonResponse['books']) {
        books.add(Book.fromJson(bookData));
      }
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  void _onSearch() {
    String query = _searchController.text;
    _searchBooks(query).then((books) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchResultPage(books: books)),
      );
    });
  }

  void _navigateToSearchHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchHistoryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'ReadMe'),
      body: GradientBackground(
        colorTween: _colorTween,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'AI Book Discovery',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Container(
                width: 300,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: TextStyle(color: Colors.blue.shade300),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.blue.shade700),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue.shade700,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                  shape: StadiumBorder(),
                ),
                onPressed: _onSearch,
                icon: Icon(Icons.search, size: 24),
                label: Text('Search', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToSearchHistory,
                child: Text('View Search History'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 0,
      ),
    );
  }
}

class Book {
  final String title;
  final String author;
  final String description;
  final String thumbnailUrl;
  final double rating;

  Book({required this.title, required this.author, required this.description, required this.thumbnailUrl, required this.rating});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['volumeInfo']['title'],
      author: (json['volumeInfo']['authors'] as List).join(', '),
      description: json['volumeInfo']['description'],
      thumbnailUrl: json['volumeInfo']['imageLinks']['thumbnail'],
      rating: json['volumeInfo']['averageRating'] ?? 0.0,
    );
  }
}

class SearchResultPage extends StatelessWidget {
  final List<Book> books;

  SearchResultPage({Key? key, required this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            return BookCard(book: books[index]);
          },
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;

  BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: Image.network(
                book.thumbnailUrl,
                fit: BoxFit.cover,
                width: 50,
                height: 75,
              ),
              title: Text(book.title, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(book.author),
              trailing: (book.rating > 0) ? Icon(Icons.star, color: Colors.amber) : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                book.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                },
                child: Text('More Details', style: TextStyle(color: Colors.blue)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchHistoryPage extends StatefulWidget {
  @override
  _SearchHistoryPageState createState() => _SearchHistoryPageState();
}

class _SearchHistoryPageState extends State<SearchHistoryPage> {
  List<Map<String, dynamic>> searchHistories = []; // Menyimpan daftar history sebagai map
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    try {
      final response = await http.get(
        Uri.parse('${app_data.baseUrl}/history/history-json/'),

        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          searchHistories = data.cast<Map<String, dynamic>>(); // Proper casting of the list items
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load search history with status code: ${response.statusCode}.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Search History'),
          backgroundColor: Colors.blue.shade800,
        ),
        body: ListView.builder( // Pastikan di dalam Scaffold
          itemCount: searchHistories.length,
          itemBuilder: (context, index) {
            // Akses 'fields' untuk mendapatkan 'query'
            final historyItem = searchHistories[index];
            final query = historyItem['fields']['query'] as String? ?? 'Unknown'; // Gunakan 'fields' dan 'query'
            
            return ListTile(
              title: Text(query),
              subtitle: Text("Created at: ${historyItem['fields']['created_at']}"),
            );
          },
        ),
      );
    }
  }
}
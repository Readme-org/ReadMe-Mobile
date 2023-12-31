import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readme/modules/details-book/details_mybook.dart';
import 'package:readme/modules/list-book/list.dart';
import 'package:readme/modules/list-book/models/myBook.dart';
import 'package:readme/core/url.dart' as app_data;

FutureBuilder<List<dynamic>> buildMyBooks(BuildContext context) {
  final request = Provider.of<CookieRequest>(context, listen: false);

  Future<List<dynamic>> fetchBooks() async {
    var response = await request.get('${app_data.baseUrl}/list-book/myBook-json/');

    if (!response.isEmpty) {
      return response.map((json) => MyBook.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  return FutureBuilder<List<dynamic>>(
    future: fetchBooks(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('No books found'));
      } else {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.6,
          ),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            MyBook book = snapshot.data![index];
            Fields fields = book.fields;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsMyBookPage(book: book),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.network(
                          fields.image,
                          fit: BoxFit.fill, // Fill the space of the container
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          fields.title,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Penulis: ${fields.authors}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    },
  );
}

Future<void> addBook(BuildContext context, String title, String authors, String isbn, String imageUrl, String description) async {
  final request = Provider.of<CookieRequest>(context, listen: false);

    final response = await request.postJson(
        '${app_data.baseUrl}/list-book/add-book-flutter/', jsonEncode({
        'title': title,
        'authors': authors,
        'isbn': isbn,
        'image': imageUrl,
        'description': description,
      })
    );

    if (response["status"] == "success") {
      // Jika server mengembalikan respon "OK", maka tampilkan snackbar dengan pesan sukses.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book added successfully!')),
      );
    } else {
      // Jika server tidak mengembalikan respon "OK", maka tampilkan error.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add the book.')),
      );
    }
}

Future<void> deleteMyBook(BuildContext context, int bookId) async {
  final request = Provider.of<CookieRequest>(context, listen: false);

  final response = await request.postJson(
    '${app_data.baseUrl}/list-book/delete-book-flutter/$bookId/' , jsonEncode({
      "galen": "'kece",
    })
  );

  if (response["status"] == "success") {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => ListPage(initialTab: 1)), // 1 untuk My Book tab
      (Route<dynamic> route) => false,
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to delete the book.')),
    );
  }
}

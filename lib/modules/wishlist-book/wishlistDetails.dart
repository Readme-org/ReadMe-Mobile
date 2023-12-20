import 'dart:convert';
import 'package:readme/core/url.dart' as app_data;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readme/modules/home-page/models/book.dart';
import 'package:flutter/material.dart';
import 'package:readme/modules/wishlist-book/models/wishlistBook.dart';
import 'package:readme/modules/wishlist-book/wishlistPage.dart';

class wishlistDetails extends StatefulWidget {
  final WishlistBook book;

  const wishlistDetails({Key? key, required this.book}) : super(key: key);

  @override
  _wishlistDetailState createState() => _wishlistDetailState();
}

class _wishlistDetailState extends State<wishlistDetails> {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title), // Book title in the AppBar
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              // Centering the container
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius:
                      BorderRadius.circular(5), // More circular corners
                ),
                margin: EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                child: ClipRRect(
                  // Clip the image with the same border radius
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    widget.book.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.book.title,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Penulis: ${widget.book.penulis}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'ISBN: ${widget.book.isbn}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    'Deskripsi:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    widget.book.description,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your delete logic here
          // This is a placeholder, replace it with your actual delete functionality
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Konfirmasi'),
                content: Text('Buang dari wishlist?'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      // Add delete action here
                      final response = await request.postJson(
                          "${app_data.baseUrl}/wishlist-book/delete/",
                          jsonEncode(
                              <String, dynamic>{'book_id': widget.book.pk}));
                      if (response['status'] == 'Berhasil dihapus') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Berhasil dihapus dari wishlsit"),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Terjadi kesalahan")));
                      }
                      // For example, you can use Navigator.pop(context) to close the dialog
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => wishlistPage()));
                    },
                    child: Text('Delete'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Dismiss the dialog
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.red, // Red button color
        child: Icon(Icons.delete), // Delete icon
      ),
    );
  }
}

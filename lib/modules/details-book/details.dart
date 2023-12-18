import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readme/modules/diskusi-book/diskusiBook.dart';
import 'package:readme/modules/home-page/models/book.dart';

class DetailsPage extends StatefulWidget {
  final Book book;

  const DetailsPage({Key? key, required this.book}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isWishlistSelected = false; // State to manage wishlist button selection

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.fields.title), // Book title in the AppBar
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
                    widget.book.fields.image,
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
                    widget.book.fields.title,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Penulis: ${widget.book.fields.authors}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'ISBN: ${widget.book.fields.isbn}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          // Jangan lupa ganti routing
                          final response = await request.postJson(
                              'http://127.0.0.1:8000/wishlist-book/add-flutter/',
                              jsonEncode(<String, String>{
                                'book_id': widget.book.pk.toString()
                              }));
                          if (response['status'] ==
                              'Buku berhasil ditambahkan ke Wishlist') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Buku berhasil ditambahkan ke Wishlist.")));
                          }
                          else if(response['status'] == 'Buku sudah ada di Wishlist'){
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                      content:
                                          Text("Buku sudah ada dalam Wishlist."),
                                  ));
                          }
                          else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                      content:
                                          Text("Terdapat kesalahan, silakan coba lagi."),
                                  ));
                              }
                          setState(() {
                            isWishlistSelected =
                                !isWishlistSelected; // Toggle wishlist selection
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          primary:
                              isWishlistSelected ? Colors.white : Colors.black,
                          backgroundColor:
                              isWishlistSelected ? Colors.red : Colors.white,
                          side: BorderSide(
                              color: isWishlistSelected
                                  ? Colors.red
                                  : Colors.grey),
                        ),
                        child: Text(isWishlistSelected
                            ? 'Added to Wishlist'
                            : 'Wishlist'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          // Diskusi Chat button logic
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DiscussionPage(book: widget.book),
                              ));
                        },
                        style: OutlinedButton.styleFrom(
                          primary: Colors.black,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text('Diskusi Chat'),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    'Deskripsi:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    widget.book.fields.description,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Wishlist/Add Review logic
                    },
                    child: Text('Add Review'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

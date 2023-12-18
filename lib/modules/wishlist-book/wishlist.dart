import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:readme/modules/details-book/details_mybook.dart';
import 'package:readme/modules/wishlist-book/wishlistPage.dart';
import 'package:readme/modules/wishlist-book/wishlistDetails.dart';
import 'package:readme/modules/wishlist-book/models/wishlistBook.dart';
// import 'package:readme/modules/list-book/models';

FutureBuilder<List<WishlistBook>> buildwishlist(BuildContext context) {
  Future<List<WishlistBook>> fetchBooks() async {
    // TODO:
    // URL UNTUK AKSES DJANGO
    // var url = Uri.parse('https://readme-c11-tk.pbp.cs.ui.ac.id/wishlit-book/wishlist-json');

    // Testing url
    var url = Uri.parse('http://127.0.0.1:8000/wishlist-book/get-json/');
    var request = context.read<CookieRequest>();
    var response = await request.get(url.toString());

    List<WishlistBook> wishlist_product = [];
    for (var d in response) {
      // print(d);
      if (d != null) {
        wishlist_product.add(WishlistBook.fromJson(d));
      }
    }
    return wishlist_product;
  }

  return FutureBuilder<List<WishlistBook>>(
    future: fetchBooks(),
    builder: (context, AsyncSnapshot snapshot) {
      print(snapshot);
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(
          child: Text('No books found'),
        );
      } else {
        return Container(
          height: MediaQuery.of(context).size.height,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              WishlistBook book = snapshot.data![index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => wishlistDetails(book: book),
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
                            book.image,
                            fit: BoxFit.fill, // Fill the space of the container
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            book.title,
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
                            'Penulis: ${book.penulis}',
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
          ),
        );
      }
    },
  );
}

// To parse this JSON data, do
//
//     final wishlistBook = wishlistBookFromJson(jsonString);

import 'dart:convert';

List<WishlistBook> wishlistBookFromJson(String str) => List<WishlistBook>.from(json.decode(str).map((x) => WishlistBook.fromJson(x)));

String wishlistBookToJson(List<WishlistBook> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WishlistBook {
    String title;
    String penulis;
    String isbn;
    String image;
    String description;

    WishlistBook({
        required this.title,
        required this.penulis,
        required this.isbn,
        required this.image,
        required this.description,
    });

    factory WishlistBook.fromJson(Map<String, dynamic> json) => WishlistBook(
        title: json["title"],
        penulis: json["penulis"],
        isbn: json["isbn"],
        image: json["image"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "penulis": penulis,
        "isbn": isbn,
        "image": image,
        "description": description,
    };
}

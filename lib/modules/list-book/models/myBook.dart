// To parse this JSON data, do
//
//     final myBook = myBookFromJson(jsonString);

import 'dart:convert';

List<MyBook> myBookFromJson(String str) => List<MyBook>.from(json.decode(str).map((x) => MyBook.fromJson(x)));

String myBookToJson(List<MyBook> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyBook {
    String model;
    int pk;
    Fields fields;

    MyBook({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory MyBook.fromJson(Map<String, dynamic> json) => MyBook(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String title;
    String displayTitle;
    String authors;
    String image;
    String description;
    String isbn;

    Fields({
        required this.user,
        required this.title,
        required this.displayTitle,
        required this.authors,
        required this.image,
        required this.description,
        required this.isbn,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        title: json["title"],
        displayTitle: json["display_title"],
        authors: json["authors"],
        image: json["image"],
        description: json["description"],
        isbn: json["isbn"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "title": title,
        "display_title": displayTitle,
        "authors": authors,
        "image": image,
        "description": description,
        "isbn": isbn,
    };
}

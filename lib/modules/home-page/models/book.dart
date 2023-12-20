// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

List<Book> bookFromJson(String str) => List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
    Model model;
    int pk;
    Fields fields;

    Book({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Book.fromJson(Map<String, dynamic> json) => Book(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String title;
    String displayTitle;
    String authors;
    String image;
    String description;
    String isbn;
    Genre genre;

    Fields({
        required this.title,
        required this.displayTitle,
        required this.authors,
        required this.image,
        required this.description,
        required this.isbn,
        required this.genre,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        displayTitle: json["display_title"],
        authors: json["authors"],
        image: json["image"],
        description: json["description"],
        isbn: json["isbn"],
        genre: genreValues.map[json["genre"]]!,
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "display_title": displayTitle,
        "authors": authors,
        "image": image,
        "description": description,
        "isbn": isbn,
        "genre": genreValues.reverse[genre],
    };
}

enum Genre {
    ACTION,
    FANTASY,
    FICTION,
    MANGA,
    ROMANCE_COMEDY,
    SCIENCE
}

final genreValues = EnumValues({
    "action": Genre.ACTION,
    "Fantasy": Genre.FANTASY,
    "fiction": Genre.FICTION,
    "manga": Genre.MANGA,
    "romance comedy": Genre.ROMANCE_COMEDY,
    "science": Genre.SCIENCE
});

enum Model {
    MAIN_BOOK
}

final modelValues = EnumValues({
    "main.book": Model.MAIN_BOOK
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}

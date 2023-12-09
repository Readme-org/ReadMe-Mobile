// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

List<Post> postFromJson(String str) => List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
    String model;
    int pk;
    Fields fields;

    Post({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Post.fromJson(Map<String, dynamic> json) => Post(
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
    int book;
    int user;
    String title;
    String content;
    DateTime date;

    Fields({
        required this.book,
        required this.user,
        required this.title,
        required this.content,
        required this.date,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        book: json["book"],
        user: json["user"],
        title: json["title"],
        content: json["content"],
        date: DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "book": book,
        "user": user,
        "title": title,
        "content": content,
        "date": date.toIso8601String(),
    };
}

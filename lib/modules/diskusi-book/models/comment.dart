// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

List<Comment> commentFromJson(String str) => List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String commentToJson(List<Comment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comment {
  String model;
  int pk;
  Fields fields;
  String username;

  Comment({
    required this.model,
    required this.pk,
    required this.fields,
    required this.username,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
        username: 'Anonymous',
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int post;
  int user;
  String content;
  DateTime date;

  Fields({
    required this.post,
    required this.user,
    required this.content,
    required this.date,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        post: json["post"],
        user: json["user"],
        content: json["content"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "post": post,
        "user": user,
        "content": content,
        "date": date.toIso8601String(),
      };
}

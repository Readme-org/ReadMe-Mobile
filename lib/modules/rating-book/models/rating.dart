// To parse this JSON data, do
//
//     final rating = ratingFromJson(jsonString);

import 'dart:convert';

List<Rating> ratingFromJson(String str) =>
    List<Rating>.from(json.decode(str).map((x) => Rating.fromJson(x)));

String ratingToJson(List<Rating> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rating {
  int id;
  int user;
  int book;
  int rating;
  String message;
  String username;

  Rating({
    required this.id,
    required this.user,
    required this.book,
    required this.rating,
    required this.message,
    required this.username,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        id: json["id"],
        user: json["user"],
        book: json["book"],
        rating: json["rating"],
        message: json["message"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "book": book,
        "rating": rating,
        "message": message,
        "username": username,
      };
}

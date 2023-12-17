// To parse this JSON data, do
//
//     final reply = replyFromJson(jsonString);

import 'dart:convert';

List<Reply> replyFromJson(String str) => List<Reply>.from(json.decode(str).map((x) => Reply.fromJson(x)));

String replyToJson(List<Reply> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reply {
  Model model;
  int pk;
  Fields fields;
  String username;

  Reply({
    required this.model,
    required this.pk,
    required this.fields,
    required this.username,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
        username: 'Anonymous',
      );

  Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int comment;
  int user;
  String content;
  DateTime date;

  Fields({
    required this.comment,
    required this.user,
    required this.content,
    required this.date,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        comment: json["comment"],
        user: json["user"],
        content: json["content"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "user": user,
        "content": content,
        "date": date.toIso8601String(),
      };
}

enum Model { DISKUSI_BOOK_REPLY }

final modelValues = EnumValues({"diskusiBook.reply": Model.DISKUSI_BOOK_REPLY});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

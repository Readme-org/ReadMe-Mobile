// file: lib/models/search_history.dart

import 'package:flutter/foundation.dart';

class SearchHistoryList {
  List<SearchHistory> searchHistories;

  SearchHistoryList({
    required this.searchHistories,
  });

  factory SearchHistoryList.fromJson(List<dynamic> parsedJson) {
    List<SearchHistory> searchHistories = parsedJson.map((i) => SearchHistory.fromJson(i)).toList();
    return SearchHistoryList(
        searchHistories: searchHistories,
    );
  }
}

class SearchHistory {
  String model;
  int pk;
  SearchHistoryFields fields;

  SearchHistory({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      model: json['model'],
      pk: json['pk'],
      fields: SearchHistoryFields.fromJson(json['fields']),
    );
  }
}

class SearchHistoryFields {
  int user;
  String query;
  String createdAt;
  bool isImportant;
  String tag;

  SearchHistoryFields({
    required this.user,
    required this.query,
    required this.createdAt,
    required this.isImportant,
    required this.tag,
  });

  factory SearchHistoryFields.fromJson(Map<String, dynamic> json) {
    return SearchHistoryFields(
      user: json['user'],
      query: json['query'],
      createdAt: json['created_at'],
      isImportant: json['is_important'],
      tag: json['tag'],
    );
  }
}
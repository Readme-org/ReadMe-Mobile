class SearchHistory {
  final String query;
  final String createdAt;

  SearchHistory({
    required this.query,
    required this.createdAt,
  });

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    // If the JSON fields are potentially null, provide a default value
    return SearchHistory(
      query: json['query'] ?? 'Default query value',
      createdAt: json['created_at'] ?? 'Default date value',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'created_at': createdAt,
    };
  }
}
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:readme/modules/home-page/models/book.dart';
import 'package:readme/modules/rating-book/models/rating.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String baseUrl = 'http://127.0.0.1:8000/rating-book';

  static bool isLoggedIn(CookieRequest cookieRequest) {
    return cookieRequest.loggedIn;
  }

  static Future<List<Book>> getBooks(CookieRequest cookieRequest) async {
    final request = http.Request('GET', Uri.parse('$baseUrl/mobile/books/'));
    request.headers.addAll(cookieRequest.headers);

    final response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final books = bookFromJson(body);
      return books;
    } else {
      return [];
    }
  }

  static Future<Image?> getBookImage(
      CookieRequest cookieRequest, int id) async {
    final request =
        http.Request('GET', Uri.parse('$baseUrl/mobile/image/$id/'));
    request.headers.addAll(cookieRequest.headers);

    final response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.toBytes();
      final image = Image.memory(body);
      return image;
    } else {
      return null;
    }
  }

  static Future<List<Rating>> getRating(
      CookieRequest cookieRequest, int book) async {
    final request = http.Request('GET', Uri.parse('$baseUrl/reviews/$book/'));
    request.headers.addAll(cookieRequest.headers);

    final response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final rating = ratingFromJson(body);
      return rating;
    } else {
      return [];
    }
  }

  static Future<bool> addRating(
      CookieRequest cookieRequest, int book, int rating, String message) async {
    final request = http.Request('POST', Uri.parse('$baseUrl/mobile/create/'));
    request.headers.addAll(cookieRequest.headers);
    request.bodyFields = {
      'book': book.toString(),
      'rating': rating.toString(),
      'message': message,
    };

    final response = await request.send();
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateRating(CookieRequest cookieRequest, int id,
      int book, int rating, String message) async {
    final request = http.Request('POST', Uri.parse('$baseUrl/mobile/update/'));
    request.headers.addAll(cookieRequest.headers);
    request.bodyFields = {
      'book': book.toString(),
      'rating': rating.toString(),
      'message': message,
    };

    final response = await request.send();
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteRating(CookieRequest cookieRequest, int id) async {
    final request =
        http.Request('GET', Uri.parse('$baseUrl/mobile/delete/$id/'));
    request.headers.addAll(cookieRequest.headers);

    final response = await request.send();
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}

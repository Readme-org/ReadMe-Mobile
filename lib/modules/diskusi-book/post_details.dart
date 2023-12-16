import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:readme/modules/diskusi-book/post_form.dart';
import 'package:readme/modules/home-page/models/book.dart';
import 'package:readme/modules/diskusi-book/models/post.dart';
import 'package:readme/authentication/user.dart';
import 'package:readme/modules/diskusi-book/post_form.dart';

class PostPage extends StatefulWidget {
  final Book book;
  final Post post;

  const PostPage({Key? key, required this.book, required this.post}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  int titleMaxLength = 100;
  int contentMaxLength = 500;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    String title = widget.post.fields.title;
    String displayTitle = title.length > titleMaxLength ? title.substring(0, titleMaxLength) : title;
    String content = widget.post.fields.content;
    String displayContent = content.length > contentMaxLength ? content.substring(0, contentMaxLength) : content;

    return Scaffold(
      backgroundColor: Color(0xFFCDEFFF),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Discussion Thread for "${widget.book.fields.title}"',
          style: TextStyle(fontSize: 18),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        // backgroundColor: Colors.deepPurple,
        // foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                displayTitle,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              if (title.length > titleMaxLength)
                TextButton(
                  onPressed: () {
                    setState(() {
                      titleMaxLength += 200;
                    });
                  },
                  child: Text('Show More'),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Posted by ${widget.post.username}',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 100.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayContent,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (content.length > contentMaxLength)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            contentMaxLength += 2000;
                          });
                        },
                        child: Text('Show More'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

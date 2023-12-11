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

class DiscussionPage extends StatefulWidget {
  final Book book;

  const DiscussionPage({Key? key, required this.book}) : super(key: key);
  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  late Book _selectedBook;

  @override
  void initState() {
    super.initState();
    _selectedBook = widget.book;
  }

  Future<List<Post>> fetchPosts() async {
    // var url = Uri.parse('https://readme-c11-tk.pbp.cs.ui.ac.id/diskusi-book/json/');

    //For testing, unComment for testing,tapi janlupa dicomment kode atasnya
    var url = Uri.parse('http://127.0.0.1:8000/diskusi-book/json/');

    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Post> postsJson = [];
      for (var d in data) {
        if (d != null) {
          Post post = Post.fromJson(d);
          if (post.fields.book == _selectedBook.pk) {
            postsJson.add(post);
          }
        }
      }
      return postsJson;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Discussion Thread for "${_selectedBook.fields.title}"'),
      ),
      body: FutureBuilder<List<Post>>(
        future: fetchPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Create your post here!'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => PostFormPage(book: _selectedBook),
                            //   ),
                            // );
                          },
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshot.data![index].fields.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  snapshot.data![index].fields.content,
                                  style: const TextStyle(fontSize: 16),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    if (snapshot.data![index].fields.user ==
                                        biguname.uid) ...[
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          // Edit post
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            // Remove post
                                          });
                                        },
                                      ),
                                    ]
                                  ],
                                ),
                              ]),
                        )));
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add post
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostFormPage(book: _selectedBook),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

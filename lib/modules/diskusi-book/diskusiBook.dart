import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:readme/modules/diskusi-book/post_details.dart';
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
  late Future<List<Post>> _postsFuture;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedBook = widget.book;
    _postsFuture = fetchPosts();
  }

  void navigateToPostForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostFormPage(book: _selectedBook)),
    );
    setState(
      () {
        _postsFuture = fetchPosts();
      },
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<List<Post>> fetchPosts() async {
    // var url = Uri.parse('https://readme-c11-tk.pbp.cs.ui.ac.id/diskusi-book/json/');

    //For testing, unComment for testing,tapi janlupa dicomment kode atasnya
    var url = Uri.parse('http://127.0.0.1:8000/diskusi-book/json/');

    var response = await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Post> postsJson = [];
      for (var d in data) {
        if (d != null) {
          Post post = Post.fromJson(d);
          if (post.fields.book == _selectedBook.pk) {
            var url2 = Uri.parse('http://127.0.0.1:8000/diskusi-book/get_username/${post.fields.user}/');
            var response2 = await http.get(url2, headers: {"Content-Type": "application/json"});
            if (response2.statusCode == 200) {
              var data2 = jsonDecode(response2.body);
              post.username = data2['username'];
            }
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Discussion Thread for "${_selectedBook.fields.title}"',
            style: TextStyle(fontSize: 18),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // backgroundColor: Colors.deepPurple,
          // foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: _postsFuture,
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
                        return Material(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostPage(book: _selectedBook, post: snapshot.data![index]),
                                ),
                              );
                            },
                            child: Card(
                              color: Color(0xFFCDEFFF),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Posted by ${snapshot.data![index].username}',
                                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                                      ),
                                      Text(
                                        snapshot.data![index].fields.title,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                                          if (snapshot.data![index].fields.user == biguname.uid) ...[
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                titleController.text = snapshot.data![index].fields.title;
                                                contentController.text = snapshot.data![index].fields.content;
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return SingleChildScrollView(
                                                      // Tambahkan SingleChildScrollView
                                                      padding: const EdgeInsets.all(16),
                                                      child: Form(
                                                        key: _formKey,
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: <Widget>[
                                                            TextFormField(
                                                              controller: titleController,
                                                              decoration: const InputDecoration(
                                                                labelText: 'Title',
                                                                border: OutlineInputBorder(),
                                                              ),
                                                              maxLength: 300,
                                                              validator: (value) {
                                                                if (value == null || value.isEmpty) {
                                                                  return 'Please enter a title';
                                                                } else if (value.length > 300) {
                                                                  return 'Title cannot exceed 300 characters';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                            const SizedBox(height: 10),
                                                            TextFormField(
                                                              controller: contentController,
                                                              decoration: const InputDecoration(
                                                                labelText: 'Content',
                                                                border: OutlineInputBorder(),
                                                              ),
                                                              maxLines: 3,
                                                              maxLength: 40000,
                                                              validator: (value) {
                                                                if (value == null || value.isEmpty) {
                                                                  return 'Please enter the content';
                                                                } else if (value.length > 40000) {
                                                                  return 'Content cannot exceed 40000 characters';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                            const SizedBox(height: 20),
                                                            ElevatedButton(
                                                              onPressed: () async {
                                                                if (_formKey.currentState!.validate()) {
                                                                  final String title = titleController.text;
                                                                  final String content = contentController.text;
                                                                  // Panggil fungsi addBook
                                                                  final response = await request.postJson(
                                                                    // Uri.parse('https://readme-c11-tk.pbp.cs.ui.ac.id/diskusi-book/edit_post_flutter/'),

                                                                    //For testing
                                                                    "http://127.0.0.1:8000/diskusi-book/edit_post_flutter/",
                                                                    jsonEncode(
                                                                      <String, dynamic>{
                                                                        'title': title,
                                                                        'content': content,
                                                                        'book': _selectedBook.pk,
                                                                        'post': snapshot.data![index].pk,
                                                                      },
                                                                    ),
                                                                  );
                                                                  if (response['status'] == 'success') {
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                      const SnackBar(
                                                                        content: Text("Post telah berhasil diedit!"),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                      const SnackBar(
                                                                        content: Text("Terdapat kesalahan, silakan coba lagi."),
                                                                      ),
                                                                    );
                                                                  }
                                                                  setState(
                                                                    () {
                                                                      _postsFuture = fetchPosts();
                                                                    },
                                                                  );

                                                                  // Tutup bottom sheet
                                                                  Navigator.pop(context);
                                                                }
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                primary: Colors.blue,
                                                                onPrimary: Colors.white,
                                                              ),
                                                              child: const Text('Edit'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).whenComplete(
                                                  () {
                                                    titleController.clear();
                                                    contentController.clear();
                                                  },
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('Delete'),
                                                      content: Text('Apakah anda yakin ingin menghapus post ini?'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('Cancel'),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text('Delete'),
                                                          onPressed: () async {
                                                            final response = await request.postJson(
                                                              // Uri.parse('https://readme-c11-tk.pbp.cs.ui.ac.id/diskusi-book/remove_post_flutter/'),

                                                              //For testing
                                                              "http://127.0.0.1:8000/diskusi-book/remove_post_flutter/",
                                                              jsonEncode(
                                                                <String, dynamic>{
                                                                  'post': snapshot.data![index].pk,
                                                                },
                                                              ),
                                                            );

                                                            if (response['status'] == 'success') {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(
                                                                  content: Text(response['message']),
                                                                ),
                                                              );
                                                            } else {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(
                                                                  content: Text(response['message']),
                                                                ),
                                                              );
                                                            }
                                                            setState(
                                                              () {
                                                                // Remove post
                                                                _postsFuture = fetchPosts();
                                                              },
                                                            );
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ]
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              mini: true,
              onPressed: () {
                // Add post
                navigateToPostForm();
              },
              child: Transform.scale(
                scale: 0.7,
                child: const Icon(Icons.add),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

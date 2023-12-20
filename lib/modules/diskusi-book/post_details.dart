import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:readme/modules/diskusi-book/diskusi_book.dart';
import 'package:readme/modules/home-page/models/book.dart';
import 'package:readme/modules/diskusi-book/models/post.dart';
import 'package:readme/modules/diskusi-book/models/comment.dart';
import 'package:readme/modules/diskusi-book/models/reply.dart';
import 'package:readme/authentication/user.dart';
import 'package:readme/core/url.dart' as app_data;

class PostPage extends StatefulWidget {
  final Book book;
  final Post post;

  const PostPage({Key? key, required this.book, required this.post}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PostPageState createState() => _PostPageState();
}

class CommentWithReplies {
  final Comment comment;
  final List<Reply> replies;

  CommentWithReplies({required this.comment, required this.replies});
}

class _PostPageState extends State<PostPage> {
  late Book _selectedBook;
  late Post _selectedPost;
  late Future<List<CommentWithReplies>> _commentsFuture;
  int titleMaxLength = 100;
  int contentMaxLength = 500;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController commentContentController = TextEditingController();
  TextEditingController createReplyController = TextEditingController();
  TextEditingController editReplyContentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _editCommentFormKey = GlobalKey<FormState>();
  final _addReplyFormKey = GlobalKey<FormState>();
  final _editReplyFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedBook = widget.book;
    _selectedPost = widget.post;
    _commentsFuture = fetchComments();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    commentController.dispose();
    createReplyController.dispose();
    commentContentController.dispose();
    editReplyContentController.dispose();
    super.dispose();
  }

  Future<List<CommentWithReplies>> fetchComments() async {
    var url = Uri.parse('${app_data.baseUrl}/diskusi-book/json-comment/');

    var response = await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<CommentWithReplies> commentsWithReplies = [];
      for (var d in data) {
        if (d != null) {
          Comment comment = Comment.fromJson(d);
          if (comment.fields.post == _selectedPost.pk) {
            var url2 = Uri.parse('${app_data.baseUrl}/diskusi-book/get_username/${comment.fields.user}/');
            var response2 = await http.get(url2, headers: {"Content-Type": "application/json"});
            if (response2.statusCode == 200) {
              var data2 = jsonDecode(response2.body);
              comment.username = data2['username'];
            }
            List<Reply> replies = await fetchReplies(comment);

            commentsWithReplies.add(CommentWithReplies(comment: comment, replies: replies));
          }
        }
      }

      return commentsWithReplies;
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<List<Reply>> fetchReplies(Comment comment) async {
    var url = Uri.parse('${app_data.baseUrl}/diskusi-book/json-reply/');

    var response = await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Reply> replies = [];
      for (var d in data) {
        if (d != null) {
          Reply reply = Reply.fromJson(d);
          if (reply.fields.comment == comment.pk) {
            var url2 = Uri.parse('${app_data.baseUrl}/diskusi-book/get_username/${reply.fields.user}/');
            var response2 = await http.get(url2, headers: {"Content-Type": "application/json"});
            if (response2.statusCode == 200) {
              var data2 = jsonDecode(response2.body);
              reply.username = data2['username'];
            }
            replies.add(reply);
          }
        }
      }
      return replies;
    } else {
      throw Exception('Failed to load replies');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    String title = _selectedPost.fields.title;
    String displayTitle = title.length > titleMaxLength ? title.substring(0, titleMaxLength) : title;
    String content = _selectedPost.fields.content;
    String displayContent = content.length > contentMaxLength ? content.substring(0, contentMaxLength) : content;

    return Scaffold(
      backgroundColor: const Color(0xFFCDEFFF),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Discussion Thread for "${_selectedBook.fields.title}"',
          style: const TextStyle(fontSize: 18),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        // backgroundColor: Colors.deepPurple,
        // foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<CommentWithReplies>>(
          future: _commentsFuture,
          builder: (BuildContext context, AsyncSnapshot<List<CommentWithReplies>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView(
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
                      child: const Text('Show More'),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Posted by ${_selectedPost.username}',
                      style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
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
                      children: <Widget>[
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
                            child: const Text('Show More'),
                          ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            if (_selectedPost.fields.user == biguname.uid) ...[
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  titleController.text = _selectedPost.fields.title;
                                  contentController.text = _selectedPost.fields.content;
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
                                                      "${app_data.baseUrl}/diskusi-book/edit_post_flutter/",
                                                      jsonEncode(
                                                        <String, dynamic>{
                                                          'title': title,
                                                          'content': content,
                                                          'book': _selectedBook.pk,
                                                          'post': _selectedPost.pk,
                                                        },
                                                      ),
                                                    );
                                                    if (response['status'] == 'success') {
                                                      // ignore: use_build_context_synchronously
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                          content: Text("Post telah berhasil diedit!"),
                                                        ),
                                                      );
                                                    } else {
                                                      // ignore: use_build_context_synchronously
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                          content: Text("Terdapat kesalahan, silakan coba lagi."),
                                                        ),
                                                      );
                                                    }

                                                    setState(() {
                                                      _selectedPost.fields.title = title;
                                                      _selectedPost.fields.content = content;
                                                    });

                                                    // Tutup bottom sheet
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: Colors.blue,
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
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Delete'),
                                        content: const Text('Apakah anda yakin ingin menghapus post ini?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Delete'),
                                            onPressed: () async {
                                              final response = await request.postJson(
                                                "${app_data.baseUrl}/diskusi-book/remove_post_flutter/",
                                                jsonEncode(
                                                  <String, dynamic>{
                                                    'post': _selectedPost.pk,
                                                  },
                                                ),
                                              );

                                              if (response['status'] == 'success') {
                                                // ignore: use_build_context_synchronously
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(response['message']),
                                                  ),
                                                );
                                              } else {
                                                // ignore: use_build_context_synchronously
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(response['message']),
                                                  ),
                                                );
                                              }
                                              // ignore: use_build_context_synchronously
                                              Navigator.of(context).pop();

                                              // ignore: use_build_context_synchronously
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => DiscussionPage(book: _selectedBook),
                                                ),
                                              );
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
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Comments',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          labelText: 'Add a comment',
                        ),
                        maxLines: null,
                        maxLength: 40000,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            final comment = commentController.text;
                            if (comment.isNotEmpty) {
                              // Kirim ke Django dan tunggu respons
                              final response = await request.postJson(
                                  "${app_data.baseUrl}/diskusi-book/create_comment_flutter/",
                                  jsonEncode(<String, dynamic>{
                                    'content': comment,
                                    'post': _selectedPost.pk,
                                  }));
                              if (response['status'] == 'success') {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Comment telah berhasil dibuat!"),
                                ));
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostPage(book: _selectedBook, post: _selectedPost),
                                  ),
                                );
                              } else {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Terdapat kesalahan, silakan coba lagi."),
                                ));
                              }
                            }
                          },
                          child: const Text('Add Comment'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (snapshot.hasData && snapshot.data!.isNotEmpty)
                    ...snapshot.data!.map(
                      (CommentWithReplies commentWithReplies) {
                        // CommentWithReplies commentWithReplies = snapshot.data![index];
                        return Material(
                          color: const Color(0xFFCDEFFF),
                          child: InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 236, 249, 255),
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Commented by ${commentWithReplies.comment.username}',
                                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 8),
                                    ExpandableText(commentWithReplies.comment.fields.content),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        TextButton(
                                          child: const Text('Reply'),
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SingleChildScrollView(
                                                  padding: const EdgeInsets.all(16),
                                                  child: Form(
                                                    key: _addReplyFormKey,
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        TextFormField(
                                                          controller: createReplyController,
                                                          decoration: const InputDecoration(
                                                            labelText: 'Reply',
                                                            border: OutlineInputBorder(),
                                                          ),
                                                          maxLines: 3,
                                                          maxLength: 40000,
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return 'Please enter the reply';
                                                            } else if (value.length > 40000) {
                                                              return 'Reply cannot exceed 40000 characters';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                        const SizedBox(height: 16),
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            foregroundColor: Colors.white,
                                                            backgroundColor: Colors.blue,
                                                          ),
                                                          child: const Text('Post Your Reply'),
                                                          onPressed: () async {
                                                            if (_addReplyFormKey.currentState!.validate()) {
                                                              final String content = createReplyController.text;
                                                              // Panggil fungsi addBook
                                                              final response = await request.postJson(
                                                                "${app_data.baseUrl}/diskusi-book/create_reply_flutter/",
                                                                jsonEncode(
                                                                  <String, dynamic>{
                                                                    'content': content,
                                                                    'comment': commentWithReplies.comment.pk,
                                                                  },
                                                                ),
                                                              );
                                                              if (response['status'] == 'success') {
                                                                // ignore: use_build_context_synchronously
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text("Reply telah berhasil diedit!"),
                                                                  ),
                                                                );
                                                              } else {
                                                                // ignore: use_build_context_synchronously
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text("Terdapat kesalahan, silakan coba lagi."),
                                                                  ),
                                                                );
                                                              }
                                                              setState(
                                                                () {
                                                                  _commentsFuture = fetchComments();
                                                                },
                                                              );

                                                              // Tutup bottom sheet
                                                              // ignore: use_build_context_synchronously
                                                              Navigator.pop(context);
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).whenComplete(
                                              () {
                                                createReplyController.clear();
                                              },
                                            );
                                          },
                                        ),
                                        if (commentWithReplies.comment.fields.user == biguname.uid) ...[
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () {
                                              commentContentController.text = commentWithReplies.comment.fields.content;
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return SingleChildScrollView(
                                                    // Tambahkan SingleChildScrollView
                                                    padding: const EdgeInsets.all(16),
                                                    child: Form(
                                                      key: _editCommentFormKey,
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: <Widget>[
                                                          TextFormField(
                                                            controller: commentContentController,
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
                                                              if (_editCommentFormKey.currentState!.validate()) {
                                                                final String content = commentContentController.text;
                                                                // Panggil fungsi addBook
                                                                final response = await request.postJson(
                                                                  "${app_data.baseUrl}/diskusi-book/edit_comment_flutter/",
                                                                  jsonEncode(
                                                                    <String, dynamic>{
                                                                      'content': content,
                                                                      'post': _selectedPost.pk,
                                                                      'comment': commentWithReplies.comment.pk,
                                                                    },
                                                                  ),
                                                                );
                                                                if (response['status'] == 'success') {
                                                                  // ignore: use_build_context_synchronously
                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                    const SnackBar(
                                                                      content: Text("Comment telah berhasil diedit!"),
                                                                    ),
                                                                  );
                                                                } else {
                                                                  // ignore: use_build_context_synchronously
                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                    const SnackBar(
                                                                      content: Text("Terdapat kesalahan, silakan coba lagi."),
                                                                    ),
                                                                  );
                                                                }
                                                                setState(
                                                                  () {
                                                                    _commentsFuture = fetchComments();
                                                                  },
                                                                );

                                                                // Tutup bottom sheet
                                                                // ignore: use_build_context_synchronously
                                                                Navigator.pop(context);
                                                              }
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              foregroundColor: Colors.white,
                                                              backgroundColor: Colors.blue,
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
                                                  commentContentController.clear();
                                                },
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () async {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('Delete'),
                                                    content: const Text('Apakah anda yakin ingin menghapus comment ini?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: const Text('Cancel'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: const Text('Delete'),
                                                        onPressed: () async {
                                                          final response = await request.postJson(
                                                            "${app_data.baseUrl}/diskusi-book/remove_comment_flutter/",
                                                            jsonEncode(
                                                              <String, dynamic>{
                                                                'comment': commentWithReplies.comment.pk,
                                                              },
                                                            ),
                                                          );

                                                          if (response['status'] == 'success') {
                                                            // ignore: use_build_context_synchronously
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                content: Text(response['message']),
                                                              ),
                                                            );
                                                          } else {
                                                            // ignore: use_build_context_synchronously
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                content: Text(response['message']),
                                                              ),
                                                            );
                                                          }
                                                          setState(
                                                            () {
                                                              // Remove post
                                                              _commentsFuture = fetchComments();
                                                            },
                                                          );
                                                          // ignore: use_build_context_synchronously
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ],
                                    ),
                                    for (var reply in commentWithReplies.replies)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 236, 249, 255),
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        margin: const EdgeInsets.all(8.0),
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Replied by ${reply.username}',
                                                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                                              ),
                                              const SizedBox(height: 8),
                                              ExpandableText(reply.fields.content),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: <Widget>[
                                                  if (reply.fields.user == biguname.uid) ...[
                                                    IconButton(
                                                      icon: const Icon(Icons.edit),
                                                      onPressed: () {
                                                        editReplyContentController.text = reply.fields.content;
                                                        showModalBottomSheet(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return SingleChildScrollView(
                                                              // Tambahkan SingleChildScrollView
                                                              padding: const EdgeInsets.all(16),
                                                              child: Form(
                                                                key: _editReplyFormKey,
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: <Widget>[
                                                                    TextFormField(
                                                                      controller: editReplyContentController,
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
                                                                        if (_editReplyFormKey.currentState!.validate()) {
                                                                          final String content = editReplyContentController.text;
                                                                          // Panggil fungsi addBook
                                                                          final response = await request.postJson(
                                                                            "${app_data.baseUrl}/diskusi-book/edit_reply_flutter/",
                                                                            jsonEncode(
                                                                              <String, dynamic>{
                                                                                'content': content,
                                                                                'reply': reply.pk,
                                                                              },
                                                                            ),
                                                                          );
                                                                          if (response['status'] == 'success') {
                                                                            // ignore: use_build_context_synchronously
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              const SnackBar(
                                                                                content: Text("Reply telah berhasil diedit!"),
                                                                              ),
                                                                            );
                                                                          } else {
                                                                            // ignore: use_build_context_synchronously
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              const SnackBar(
                                                                                content: Text("Terdapat kesalahan, silakan coba lagi."),
                                                                              ),
                                                                            );
                                                                          }
                                                                          setState(
                                                                            () {
                                                                              _commentsFuture = fetchComments();
                                                                            },
                                                                          );

                                                                          // Tutup bottom sheet
                                                                          // ignore: use_build_context_synchronously
                                                                          Navigator.pop(context);
                                                                        }
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                        foregroundColor: Colors.white,
                                                                        backgroundColor: Colors.blue,
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
                                                            editReplyContentController.clear();
                                                          },
                                                        );
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(Icons.delete),
                                                      onPressed: () async {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: const Text('Delete'),
                                                              content: const Text('Apakah anda yakin ingin menghapus reply ini?'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child: const Text('Cancel'),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  child: const Text('Delete'),
                                                                  onPressed: () async {
                                                                    final response = await request.postJson(
                                                                      "${app_data.baseUrl}/diskusi-book/remove_reply_flutter/",
                                                                      jsonEncode(
                                                                        <String, dynamic>{
                                                                          'reply': reply.pk,
                                                                        },
                                                                      ),
                                                                    );

                                                                    if (response['status'] == 'success') {
                                                                      // ignore: use_build_context_synchronously
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(
                                                                          content: Text(response['message']),
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      // ignore: use_build_context_synchronously
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(
                                                                          content: Text(response['message']),
                                                                        ),
                                                                      );
                                                                    }
                                                                    setState(
                                                                      () {
                                                                        // Remove reply
                                                                        _commentsFuture = fetchComments();
                                                                      },
                                                                    );
                                                                    // ignore: use_build_context_synchronously
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int initialMaxLength;

  const ExpandableText(this.text, {super.key, this.initialMaxLength = 500});

  @override
  // ignore: library_private_types_in_public_api
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  late int _maxLength;

  @override
  void initState() {
    super.initState();
    _maxLength = widget.initialMaxLength;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.text.length <= _maxLength ? widget.text : widget.text.substring(0, _maxLength),
          style: const TextStyle(fontSize: 16),
        ),
        if (widget.text.length > _maxLength)
          TextButton(
            child: const Text("Show More"),
            onPressed: () {
              setState(() {
                _maxLength += 2000;
              });
            },
          ),
      ],
    );
  }
}

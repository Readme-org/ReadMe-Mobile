import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:readme/modules/home-page/models/book.dart';
import 'package:readme/modules/diskusi-book/models/post.dart';
import 'package:readme/authentication/user.dart';

class DiscussionPage extends StatefulWidget {
  final Book book;

  const DiscussionPage({Key? key, required this.book}) : super(key: key);
  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  List<String> discussions = ['Discussion 1', 'Discussion 2']; // Placeholder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discussion Thread'),
      ),
      body: ListView.builder(
        itemCount: discussions.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(discussions[index]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Buat edit post
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        discussions.removeAt(index);
                      });
                      // Tambah fungsionalitas buat remove
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Buat add post
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

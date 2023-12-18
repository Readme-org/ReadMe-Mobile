import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readme/modules/home-page/models/book.dart';

class PostFormPage extends StatefulWidget {
  final Book book;

  const PostFormPage({Key? key, required this.book}) : super(key: key);

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _content = "";
  late Book _selectedBook;

  @override
  void initState() {
    super.initState();
    _selectedBook = widget.book;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color(0xFFCDEFFF),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Form Tambah Post',
          style: TextStyle(fontSize: 18),
        ),
        // backgroundColor: Colors.deepPurple,
        // foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Title Post",
                    labelText: "Title Post",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _title = value!;
                    });
                  },
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Content",
                    labelText: "Content",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _content = value!;
                    });
                  },
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
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Kirim ke Django dan tunggu respons
                        final response = await request.postJson(
                            // Uri.parse('https://readme-c11-tk.pbp.cs.ui.ac.id/diskusi-book/create_post_flutter/'),

                            //For testing
                            "http://127.0.0.1:8000/diskusi-book/create_post_flutter/",
                            jsonEncode(<String, dynamic>{
                              'title': _title,
                              'content': _content,
                              'book': _selectedBook.pk,
                            }));
                        if (response['status'] == 'success') {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Post telah berhasil dibuat!"),
                          ));
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        } else {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Terdapat kesalahan, silakan coba lagi."),
                          ));
                        }
                      }
                    },
                    child: const Text(
                      "Create",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:async';



class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  BookPageState createState() => BookPageState();
}

class BookPageState extends State<BookPage> with TickerProviderStateMixin {
  String placeholder = 'Search for books...';
  late AnimationController _animationController;
  late Animation _colorTween;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 15))
      ..repeat(reverse: true);
    _colorTween = ColorTween(begin: Colors.blue.shade400, end: Colors.blue.shade900)
      .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ReadMe',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _colorTween,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, _colorTween.value],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'AI Book Discovery',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: 300,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade100,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: placeholder,
                        hintStyle: TextStyle(color: Colors.blue.shade300),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.blue.shade700),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue.shade700,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                      shape: StadiumBorder(),
                    ),
                    onPressed: () {
                      // Perform search operation
                    },
                    icon: Icon(Icons.search, size: 24),
                    label: Text('Search', style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list, color: Colors.blue.shade700),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.blue.shade700),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.blue.shade700),
            label: 'My Book',
          ),
        ],
        currentIndex: 1, // Assuming 'Search' is always the centered item
        selectedItemColor: Colors.blue.shade700,
        onTap: (int index) {
          // Handle navigation
        },
      ),
    );
  }
}
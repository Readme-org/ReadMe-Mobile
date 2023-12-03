import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:readme/modules/list-book/list.dart';
import 'package:readme/widgets/appbar.dart';
import 'package:readme/widgets/navbar.dart';
import 'package:readme/widgets/background.dart';

class HomebookPage extends StatefulWidget {
  const HomebookPage({Key? key}) : super(key: key);

  @override
  BookPageState createState() => BookPageState();
}

class BookPageState extends State<HomebookPage> with TickerProviderStateMixin {
  String placeholder = 'Search for books...';
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

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
      appBar: CustomAppBar(title: 'ReadMe'),
      body: GradientBackground(
        colorTween: _colorTween,
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
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 0,
      ),
    );
  }
}
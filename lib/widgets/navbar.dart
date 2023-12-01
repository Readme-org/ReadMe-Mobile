import 'package:flutter/material.dart';
import 'package:readme/modules/home-page/HomeBookPage.dart';
import 'package:readme/modules/list-book/list.dart';
// Import halaman yang relevan di sini

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  const CustomBottomNavigationBar({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigasi berdasarkan index yang dipilih
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomebookPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListPage()),
        );
        break;
      case 2:
        // Navigasi ke halaman My Book
        break;
      case 3:
        // Navigasi ke halaman Wishlist
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books_outlined),
          label: 'List',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_border_rounded),
          label: 'Rating',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_add_outlined),
          label: 'Wishlist',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue.shade700,
      unselectedItemColor: Color.fromARGB(255, 101, 103, 105),
      onTap: _onItemTapped,
    );
  }
}

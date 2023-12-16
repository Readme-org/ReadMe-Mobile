import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readme/modules/home-page/HomeBookPage.dart';
import 'package:readme/modules/list-book/list.dart';
import 'package:readme/modules/rating-book/screens/reviews.dart';
import 'package:readme/authentication/login.dart';
import 'package:readme/modules/wishlist-book/wishlistPage.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  const CustomBottomNavigationBar({Key? key, required this.selectedIndex})
      : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
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

    if (index != 0 &&
        !Provider.of<CookieRequest>(context, listen: false).loggedIn) {
      // Jika pengguna belum masuk dan mencoba mengakses halaman lain selain HomeBookPage
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      if (!Provider.of<CookieRequest>(context, listen: false).loggedIn) {
        _selectedIndex = 0;
      }
      return;
    }

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
        // Navigasi ke halaman Rating
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RatingPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => wishlistPage()),
        );
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
          icon: Icon(Icons.library_books),
          label: 'List',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_rounded),
          label: 'Rating',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_add),
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

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readme/widgets/appbar.dart';
import 'package:readme/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:readme/modules/wishlist-book/wishlist.dart';

class wishlistPage extends StatefulWidget {
  const wishlistPage({Key? key}) : super(key: key);

  @override
  _wishlistPageState createState() => _wishlistPageState();
}

class _wishlistPageState extends State<wishlistPage> {

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: "Wishlist"),
      body: Container(
        color: Color(0xFFCDEFFF),
        child: buildwishlist(context), // Menampilkan konten wishlist
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 3),
    );
  }
}

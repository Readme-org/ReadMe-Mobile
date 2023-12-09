import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:readme/authentication/user.dart';
import 'package:readme/modules/home-page/HomeBookPage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double? height;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.height = 45.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    String username = biguname.isLoggedIn ? biguname.username : "Guest";

    void _handleLogout() async {
      // final response = await request.logout("https://readme-c11-tk.pbp.cs.ui.ac.id/auth/logout/");

      // For testing ONLY
      final response = await request.logout("http://127.0.0.1:8000/auth/logout/");

      String message = response["message"];

      if (response['status']) {
        String uname = response["username"];
        biguname = UserData(isLoggedIn: false, username: "Guest");

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("$message Sampai jumpa, $uname."),
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomebookPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("$message"),
        ));
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        toolbarHeight: height,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (biguname.isLoggedIn)
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: PopupMenuButton(
                onSelected: (value) {
                  if (value == 'logout') {
                    _handleLogout();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 'logout',
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                      ),
                  ),
                ],
                child: Row(
                  children: <Widget>[
                    Text(
                      username,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.account_circle),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}

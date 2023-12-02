import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

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
    final request = Provider.of<CookieRequest>(context);

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
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                // Logika ketika ikon profil diklik
              },
              child: Row(
                children: <Widget>[
                  Text(
                    "guest",
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

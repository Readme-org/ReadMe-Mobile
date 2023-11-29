import 'package:flutter/material.dart';
import 'package:readme/menu.dart';
import 'package:readme/modules/list-book/list.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Column(
              children: [
                Text(
                  'ReadMe',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text("Catat seluruh keperluan belanjamu di sini!",
                    ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            },
          ),

          ListTile(
              leading: const Icon(Icons.shopping_basket),
              title: const Text('Daftar Produk'),
              onTap: () {
                  // Route menu ke halaman produk
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListPage()),
                  );
              },
          ),

        ],
      ),
    );
  }
}
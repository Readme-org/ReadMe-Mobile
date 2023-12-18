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
  TextEditingController searchController = TextEditingController();

  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

  return Scaffold(
    appBar: CustomAppBar(title: "Wishlist"),
    body: Container(
      color: Color(0xFFCDEFFF),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "Search by Title",
                    ),
                    onChanged: (value) {
                      // Implement search filter logic
                      setState(() {
                        // Update state based on search input
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: (){
                    //Implement filter logic
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Wrap(
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(Icons.library_books),
                                title: const Text('All'),
                                onTap: () => {},
                              ),
                              ListTile(
                                leading: const Icon(Icons.fitness_center_rounded),
                                title: const Text('Action'),
                                onTap: () => {},
                              ),
                              ListTile(
                                leading: const Icon(Icons.favorite),
                                title: const Text('Romance'),
                                onTap: () => {},
                              ),
                              ListTile(
                                leading: const Icon(Icons.science),
                                title: const Text('Science'),
                                onTap: () => {},
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: buildwishlist(context),
          ),
        ],
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 3),
  );
  }
}

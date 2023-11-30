import 'package:flutter/material.dart';
import 'package:readme/modules/list-book/allBook.dart'; 

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  TextEditingController searchController = TextEditingController();
  String filterType = 'All'; // Can be 'All' or 'My'
  bool isAllBooksSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isAllBooksSelected = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: isAllBooksSelected ? Colors.blue : Colors.grey,
                  ),
                  child: const Text('All Book', style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isAllBooksSelected = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: !isAllBooksSelected ? Colors.blue : Colors.grey,
                  ),
                  child: const Text('My Book', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search by Title',
                    ),
                    onChanged: (value) {
                      // Implement search filter logic based on currentSearchFilter
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // Implement filter logic
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
                                  leading: const Icon(Icons.music_note),
                                  title: const Text('Action'),
                                  onTap: () => {}),
                              ListTile(
                                leading: const Icon(Icons.videocam),
                                title: const Text('Romance'),
                                onTap: () => {},
                              ),
                              ListTile(
                                leading: const Icon(Icons.book),
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
          // Display AllBook content or other content based on the flag
          Expanded(
            child: isAllBooksSelected ? buildAllBooks(context) : Container(
              // Content when "My Book" is selected or another state
              alignment: Alignment.center,
              child: const Text("My Book content goes here"),
            ),
          ),
        ],
      ),
    );
  }
}

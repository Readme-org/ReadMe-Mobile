import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:readme/modules/home-page/models/book.dart';
import 'package:readme/widgets/left_drawer.dart';
import 'package:readme/modules/details-book/details.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future<List<Book>> fetchProduct() async {
    var url = Uri.parse('https://readme-c11-tk.pbp.cs.ui.ac.id/json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Book> list_book = [];
    for (var d in data) {
      if (d != null) {
        list_book.add(Book.fromJson(d));
      }
    }
    return list_book;
  }

  TextEditingController searchController = TextEditingController();
  String filterType = 'All'; // Can be 'All' or 'My'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: Column(
        children: [
          // Buttons for All Book and My Book
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filterType = 'All';
                    });
                  },
                  child: const Text('All Book'),
                  style: ElevatedButton.styleFrom(
                    primary: filterType == 'All' ? Colors.blue : Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filterType = 'My';
                    });
                  },
                  child: const Text('My Book'),
                  style: ElevatedButton.styleFrom(
                    primary: filterType == 'My' ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Search field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by Title',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // Implement filter functionality
                  },
                ),
              ),
              onChanged: (value) {
                // Implement search filter logic
              },
            ),
          ),
          // GridView.builder
          Expanded(
            child: FutureBuilder(
              future: fetchProduct(),
              builder: (context, AsyncSnapshot<List<Book>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ada data produk.",
                      style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Number of books in a row
                    childAspectRatio: 0.6, // The aspect ratio of each item
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Book book = snapshot.data![index];
                    Fields fields = book.fields;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsPage(book: book),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.all(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Image.network(
                                  fields.image,
                                  fit: BoxFit.fill, // Fill the space of the container
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  fields.title,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  'Penulis: ${fields.authors}',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

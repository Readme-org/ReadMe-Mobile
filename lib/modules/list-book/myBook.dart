// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:readme/modules/home-page/models/book.dart';
// import 'package:readme/widgets/left_drawer.dart';
// import 'package:readme/modules/details-book/details.dart';

// class MyBookPage extends StatefulWidget {
//   const MyBookPage({Key? key}) : super(key: key);

//   @override
//   _ListPageState createState() => _ListPageState();
// }

// class _ListPageState extends State<MyBookPage> {
//   Future<List<Book>> fetchProduct() async {
//     var url = Uri.parse('https://readme-c11-tk.pbp.cs.ui.ac.id/myBook-json/');
//     var response = await http.get(
//       url,
//       headers: {"Content-Type": "application/json"},
//     );

//     var data = jsonDecode(utf8.decode(response.bodyBytes));
//     List<Book> listBook = [];
//     for (var d in data) {
//       if (d != null) {
//         listBook.add(Book.fromJson(d));
//       }
//     }
//     return listBook;
//   }

//   TextEditingController searchController = TextEditingController();
//   String filterType = 'All'; // Can be 'All' or 'My'
//   String currentSearchFilter = 'All';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Product'),
//       ),
//       drawer: const LeftDrawer(),
//       body: Column(
//         children: [
//           // Buttons for All Book and My Book
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       filterType = 'All';
//                     });
//                   },
//                   style: ElevatedButton.styleFrom(
//                     primary: filterType == 'All' ? Colors.blue : Colors.grey,
//                   ),
//                   child: const Text('All Book', style: TextStyle(color: Colors.black)),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       filterType = 'My';
//                     });
//                   },
//                   style: ElevatedButton.styleFrom(
//                     primary: filterType == 'My' ? Colors.blue : Colors.grey,
//                   ),
//                   child: const Text('My Book', style: TextStyle(color: Colors.black)),
//                 ),
//               ],
//             ),
//           ),
//           // GridView.builder
//           Expanded(
//             child: FutureBuilder(
//               future: fetchProduct(),
//               builder: (context, AsyncSnapshot<List<Book>> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       "Tidak ada data produk.",
//                       style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
//                     ),
//                   );
//                 }

//                 return GridView.builder(
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     childAspectRatio: 0.6,
//                   ),
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index) {
//                     Book book = snapshot.data![index];
//                     Fields fields = book.fields;

//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => DetailsPage(book: book),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Color(0xFFEEEEEE),
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         margin: const EdgeInsets.all(12),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(15),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               Expanded(
//                                 child: Image.network(
//                                   fields.image,
//                                   fit: BoxFit.fill, // Fill the space of the container
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Text(
//                                   fields.title,
//                                   style: const TextStyle(
//                                     fontSize: 16.0,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                                 child: Text(
//                                   'Penulis: ${fields.authors}',
//                                   style: const TextStyle(
//                                     fontSize: 14.0,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
    var url = Uri.parse('https://readme-c11-tk.pbp.cs.ui.ac.id/book-json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Book> listBook = [];
    for (var d in data) {
      if (d != null) {
        listBook.add(Book.fromJson(d));
      }
    }
    return listBook;
  }

  TextEditingController searchController = TextEditingController();
  String filterType = 'All'; // Can be 'All' or 'My'
  String currentSearchFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
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
                  style: ElevatedButton.styleFrom(
                    primary: filterType == 'All' ? Colors.blue : Colors.grey,
                  ),
                  child: const Text('All Book', style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filterType = 'My';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: filterType == 'My' ? Colors.blue : Colors.grey,
                  ),
                  child: const Text('My Book', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
          // Search field and filter button
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
                PopupMenuButton<String>(
                  onSelected: (String newValue) {
                    setState(() {
                      currentSearchFilter = newValue;
                      // TODO: Apply the filter to your product fetching logic
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Action',
                      child: Text('Action'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Romance',
                      child: Text('Romance'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Science',
                      child: Text('Science'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'All',
                      child: Text('All'),
                    ),
                  ],
                  icon: const Icon(Icons.filter_list),
                ),
              ],
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
                    crossAxisCount: 3,
                    childAspectRatio: 0.6,
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


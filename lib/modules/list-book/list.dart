import 'package:flutter/material.dart';
import 'package:readme/modules/details-book/details_mybook.dart';
import 'package:readme/modules/list-book/allBookPage.dart';
import 'package:readme/modules/list-book/myBookPage.dart';
import 'package:readme/widgets/appbar.dart';
import 'package:readme/widgets/navbar.dart'; 

class ListPage extends StatefulWidget {
  final int initialTab;

  const ListPage({Key? key, this.initialTab = 0}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> with TickerProviderStateMixin{
  TextEditingController searchController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController authorsController = TextEditingController();
  TextEditingController isbnController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String filterType = 'All'; // Can be 'All' or 'My'
  bool isAllBooksSelected = true;

  @override
  void initState() {
    super.initState();
    isAllBooksSelected = widget.initialTab == 0;
  }

  @override
  void dispose() {
    titleController.dispose();
    authorsController.dispose();
    isbnController.dispose();
    imageUrlController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Book List'),
      body: Container(
        color: Color(0xFFCDEFFF),
        child: Column(
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
            //Saat user klik allBook
            isAllBooksSelected ? Padding(
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
                                  leading: const Icon(Icons.fitness_center_rounded),
                                  title: const Text('Action'),
                                  onTap: () => {}),
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
            )
            : Container(), //Saat user klik myBook

            // Display AllBook content or other content based on the flag
            Expanded(
              child: isAllBooksSelected ? buildAllBooks(context) : buildMyBooks(context)
            ),
          ],
        ),
      ),
      
      floatingActionButton: !isAllBooksSelected ? Padding(
        padding: EdgeInsets.only(bottom: 65),
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SingleChildScrollView(  // Tambahkan SingleChildScrollView
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: authorsController,
                        decoration: InputDecoration(
                          labelText: 'Authors',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: isbnController,
                        decoration: InputDecoration(
                          labelText: 'ISBN',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: imageUrlController,
                        decoration: InputDecoration(
                          labelText: 'Image URL',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        child: Text('Submit'),
                        onPressed: () {
                          final String title = titleController.text;
                          final String authors = authorsController.text;
                          final String isbn = isbnController.text;
                          final String imageUrl = imageUrlController.text;
                          final String description = descriptionController.text;

                          // Panggil fungsi addBook
                          addBook(context, title, authors, isbn, imageUrl, description).then((_) {
                            setState(() {
                              buildMyBooks(context);
                            });
                          });

                          // Tutup bottom sheet
                          Navigator.pop(context);
                          
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, 
                          onPrimary: Colors.white, 
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).whenComplete(() {
              // Clear the text fields here
              titleController.clear();
              authorsController.clear();
              isbnController.clear();
              imageUrlController.clear();
              descriptionController.clear();
            });
          },
          child: Icon(Icons.add),
          backgroundColor: Color.fromARGB(255, 64, 64, 235),
        ),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 1,
      ),
    );
  }
}

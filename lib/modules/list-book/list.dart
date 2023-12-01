import 'package:flutter/material.dart';
import 'package:readme/modules/list-book/allBookPage.dart';
import 'package:readme/widgets/background.dart';
import 'package:readme/widgets/navbar.dart'; 

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> with TickerProviderStateMixin{
  TextEditingController searchController = TextEditingController();
  String filterType = 'All'; // Can be 'All' or 'My'
  bool isAllBooksSelected = true;
  late Animation<Color?> _colorTween;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 15))
      ..repeat(reverse: true);
    _colorTween = ColorTween(begin: Colors.blue.shade400, end: Colors.blue.shade900)
      .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
      ),
      body: GradientBackground(
        colorTween: _colorTween,
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
              child: isAllBooksSelected ? buildAllBooks(context) : Container(
                // Content when "My Book" is selected or another state
                alignment: Alignment.center,
                child: const Text("My Book content goes here"),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 1,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:readme/modules/home-page/models/book.dart';
import 'package:readme/modules/rating-book/models/rating.dart';
import 'package:readme/modules/rating-book/utils/api_service.dart';
// import 'package:readme/modules/rating-book/widgets/rating_list.dart';

class RatingPage extends StatefulWidget {
  final int? bookId;

  const RatingPage({Key? key, this.bookId}) : super(key: key);

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  late CookieRequest cookieRequest;
  late Future<List<Book>> books;
  late Future<List<Rating>> rating;
  late Future<Book>? book;
  late int bookId;

  final baseImageUrl = 'http://127.0.0.1:8000/rating-book/mobile/image';
  final ratingController = TextEditingController();
  final ratingFocusNode = FocusNode();
  var ratingValue = 0;

  @override
  void initState() {
    super.initState();
    bookId = widget.bookId ?? 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cookieRequest = Provider.of<CookieRequest>(context);
    books = ApiService.getBooks(cookieRequest);
    if (widget.bookId != null) {
      rating = ApiService.getRating(cookieRequest, widget.bookId!);
      book = books.then((value) =>
          value.firstWhere((element) => element.pk == widget.bookId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Rating'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 128,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: bookId == 0
                            ? // show a border if no book is selected
                            Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                height: 200,
                                width: double.infinity,
                                child: const Icon(Icons.book),
                              )
                            : CachedNetworkImage(
                                imageUrl: '$baseImageUrl/$bookId/',
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 128 - 32 - 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // There are 3 form fields
                          // 1. Book choice (use DropdownButtonFormField)
                          // 2. Rating (use DropdownButtonFormField)
                          // 3. Message (use TextFormField)
                          // The form should be submitted to the API when the user presses the submit button
                          // The form should be reset when the user presses the submit button

                          // Book choice
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: FutureBuilder<List<Book>>(
                              future: books,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Book',
                                    ),
                                    value: bookId,
                                    items: // add null value to the beginning of the list
                                        [
                                      const DropdownMenuItem(
                                        value: 0,
                                        child: Text('Select a book'),
                                      ),
                                      ...snapshot.data!
                                          .map((e) => DropdownMenuItem(
                                                value: e.pk,
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      224,
                                                  child: Text(
                                                    e.fields.title,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ))
                                          .toList()
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        if (value is int) {
                                          bookId = value;
                                          book = books.then((value) =>
                                              value.firstWhere((element) =>
                                                  element.pk == bookId));
                                        }
                                      });
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  return const Icon(Icons.error);
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          ),

                          // Rating using DropdownButtonFormField
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Rating',
                              ),
                              value: ratingValue,
                              items: const [
                                DropdownMenuItem(
                                  value: 0,
                                  child: Text('Select a rating'),
                                ),
                                DropdownMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.blue)
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.blue),
                                      Icon(Icons.star, color: Colors.blue)
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 3,
                                  child: Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.blue),
                                      Icon(Icons.star, color: Colors.blue),
                                      Icon(Icons.star, color: Colors.blue),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 4,
                                  child: Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.blue),
                                      Icon(Icons.star, color: Colors.blue),
                                      Icon(Icons.star, color: Colors.blue),
                                      Icon(Icons.star, color: Colors.blue),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 5,
                                  child: Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.blue),
                                      Icon(Icons.star, color: Colors.blue),
                                      Icon(Icons.star, color: Colors.blue),
                                      Icon(Icons.star, color: Colors.blue),
                                      Icon(Icons.star, color: Colors.blue),
                                    ],
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                if (value is int) {
                                  ratingFocusNode.requestFocus();
                                  ratingValue = value;
                                }
                              },
                            ),
                          ),

                          // Message
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              controller: ratingController,
                              focusNode: ratingFocusNode,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Message',
                              ),
                              maxLines: 3,
                              minLines: 3,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (value) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ),

                          // Submit button
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (bookId == 0) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Please select a book'),
                                  ));
                                  return;
                                }
                                if (ratingValue == 0) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Please select a rating'),
                                  ));
                                  return;
                                }
                                if (ratingController.text.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Please enter a message'),
                                  ));
                                  return;
                                }
                                final result = await ApiService.addRating(
                                    cookieRequest,
                                    bookId,
                                    ratingValue,
                                    ratingController.text);
                                if (result) {
                                  // Navigator.pop(context, true);
                                  print(result);
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
              //   const Divider(),
              //   FutureBuilder<List<Rating>>(
              //     future: rating,
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData) {
              //         return RatingList(
              //           ratings: snapshot.data!,
              //         );
              //       } else if (snapshot.hasError) {
              //         return Center(
              //           child: Text('Error: ${snapshot.error}'),
              //         );
              //       } else {
              //         return const Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       }
              //     },
              //   ),


//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Rating'),
//         centerTitle: true,
//       ),
//       body: FutureBuilder<List<Rating>>(
//         future: rating,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return RatingList(
//               ratings: snapshot.data!,
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final result = await showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return RatingDialog();
//             },
//           );

//           if (result != null) {
//             setState(() {
//               rating = ApiService.getRating(cookieRequest, book);
//             });
//           }
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

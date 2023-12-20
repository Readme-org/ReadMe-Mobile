import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readme/modules/rating-book/models/rating.dart';
import 'package:readme/modules/rating-book/utils/api_service.dart';

class RatingList extends StatefulWidget {
  final List<Rating> ratings;

  const RatingList({Key? key, required this.ratings}) : super(key: key);

  @override
  _RatingListState createState() => _RatingListState();
}

class _RatingListState extends State<RatingList> {
  late Future<List<Rating>> _ratings;
  late Future<int> _userId;

  @override
  void initState() {
    super.initState();
    _ratings = Future.value(widget.ratings);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userId = ApiService.getUserID(Provider.of<CookieRequest>(context));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Rating>>(
      future: _ratings,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return FutureBuilder<int>(
                future: _userId,
                builder: (context, snapshot2) {
                  if (snapshot2.hasData) {
                    return _buildRatingItem(
                        context, snapshot.data![index], snapshot2.data!);
                  } else {
                    return const SizedBox();
                  }
                },
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildRatingItem(BuildContext context, Rating rating, int userId) {
    // The rating item is a card that contains
    // the user's message in a column
    // and the user's name and rating in a row (left and right)
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 50,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(rating.message),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: rating.rating.toDouble(),
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                      direction: Axis.horizontal,
                    ),
                    const SizedBox(width: 8),
                    Text('by ${rating.username}'),
                  ],
                ),
                _buildDeleteButton(rating, userId),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(Rating rating, int userId) {
    // The delete button is only shown if the user is the owner of the rating
    if (rating.user == userId) {
      return IconButton(
        onPressed: () async {
          final result = await ApiService.deleteRating(
              Provider.of<CookieRequest>(context, listen: false), rating.id);
          if (result) {
            setState(() {
              _ratings = ApiService.getRating(
                  Provider.of<CookieRequest>(context, listen: false),
                  rating.book);
            });
          }
        },
        icon: const Icon(Icons.delete),
      );
    } else {
      return const SizedBox();
    }
  }
}

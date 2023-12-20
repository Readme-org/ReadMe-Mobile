import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
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
          children: [
            Text(rating.message),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(rating.username),
                    const SizedBox(width: 10),
                    _buildRatingStars(rating.rating),
                  ],
                ),
                _buildDeleteButton(context, rating, userId),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(int rating) {
    // This widget builds the stars for the rating
    // The stars are built using the rating value
    // and the star icon is either filled or not filled
    // depending on the rating value
    return Row(
      children: [
        for (int i = 0; i < 5; i++)
          Icon(
            Icons.star,
            color: i < rating ? Colors.yellow : Colors.grey,
          ),
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context, Rating rating, int userId) {
    // This widget builds the delete button
    // The delete button is only shown if the user
    // is the owner of the rating
    return FutureBuilder<bool>(
      future: ApiService.deleteRating(
        Provider.of<CookieRequest>(context),
        rating.id,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!) {
            return IconButton(
              onPressed: () {
                setState(() {
                  _ratings = ApiService.getRating(
                    Provider.of<CookieRequest>(context),
                    rating.book,
                  );
                });
              },
              icon: const Icon(Icons.delete),
            );
          } else {
            return const SizedBox();
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

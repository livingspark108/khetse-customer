import 'package:flutter/material.dart';
import 'package:user/constants/color_constants.dart';
import 'package:user/screens/use_rating.dart';
import 'package:user/widgets/rate_widget.dart';

class ShowRatingsScreen extends StatelessWidget {
  ShowRatingsScreen({super.key});

  List<Map<String, dynamic>> data = [
    {"comment": "Great for the price", "rating": 5, "userName": "John Doe"},
    {
      "comment": "Decent quality, fast shipping",
      "rating": 4,
      "userName": "Jane Smith"
    },
    {
      "comment": "Exceeded expectations!",
      "rating": 5,
      "userName": "Alice Johnson"
    },
    {
      "comment": "Not bad, could be better",
      "rating": 3,
      "userName": "Bob Martin"
    },
    {"comment": "Terrible packaging", "rating": 2, "userName": "Chris Lee"},
    {"comment": "Amazing deal!", "rating": 5, "userName": "Diana Prince"},
    {"comment": "Would buy again", "rating": 4, "userName": "Ethan Clark"},
    {"comment": "Below average", "rating": 2, "userName": "Fiona Wells"},
    {"comment": "Works as expected", "rating": 4, "userName": "George Brown"},
    {"comment": "Just okay", "rating": 3, "userName": "Hannah White"},
    {
      "comment": "Terrible customer support",
      "rating": 1,
      "userName": "Isaac Stone"
    },
    {"comment": "Love it!", "rating": 5, "userName": "Julia Black"},
    {"comment": "Good value for money", "rating": 4, "userName": "Kevin Young"},
    {
      "comment": "Stopped working after a week",
      "rating": 1,
      "userName": "Laura King"
    },
    {"comment": "Very satisfied", "rating": 5, "userName": "Mike Adams"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Rating & Reviews"),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => UserList(
            item: data[index],
          ),
        ));
  }
}

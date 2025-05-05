import 'package:flutter/material.dart';
import 'package:user/models/businessLayer/apiHelper.dart';
import 'package:user/models/orderReviewModal.dart';
import 'package:user/screens/user_rating.dart';

class ShowRatingsScreen extends StatefulWidget {
  ShowRatingsScreen({super.key});

  @override
  State<ShowRatingsScreen> createState() => _ShowRatingsScreenState();
}

class _ShowRatingsScreenState extends State<ShowRatingsScreen> {
  List<OrderReview> data = [];
  late APIHelper _apiHelper;

  void getOrderReviews() async {
    data = await _apiHelper.getOrderReviews();
    setState(() {});
  }

  @override
  void initState() {
    _apiHelper = APIHelper();
    getOrderReviews();
    super.initState();
  }

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

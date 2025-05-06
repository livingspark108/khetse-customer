import 'package:flutter/material.dart';
import 'package:user/constants/color_constants.dart';
import 'package:user/models/orderReviewModal.dart';
import 'package:user/widgets/rate_widget.dart';

class UserList extends StatefulWidget {
  const UserList({super.key, required this.item});
  final OrderReview item;

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> with TickerProviderStateMixin {
  bool isExpanded = false;

  double getAverageRating() {
    final ratings = [
      widget.item.vegetablesFruitsQuality ?? 0,
      widget.item.deliveryExperience ?? 0,
      widget.item.packagingQuality ?? 0,
      widget.item.hygiene ?? 0,
    ];
    return ratings.isNotEmpty
        ? ratings.reduce((a, b) => a + b) / ratings.length
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    final averageRating = getAverageRating();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ColorConstants.getBackgroundColor(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xff3b9d2f)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => {
                setState(() {
                  isExpanded = !isExpanded;
                })
              },
              child: Row(
                children: [
                  CircleAvatar(child: Icon(Icons.account_circle_rounded)),
                  SizedBox(width: 10),
                  Text(
                    widget.item.reviewerName ?? "",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff3b9d2f)),
                  ),
                  Spacer(),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RateWidget(
                  rating: averageRating.toInt(),
                  size: 28,
                  padding: EdgeInsets.zero,
                  editable: false,
                ),
              ],
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: isExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRatingItem("Vegetables & Fruits Quality",
                              widget.item.vegetablesFruitsQuality!.toDouble()),
                          _buildRatingItem("Delivery Experience",
                              widget.item.deliveryExperience!.toDouble()),
                          _buildRatingItem("Packaging Quality",
                              widget.item.packagingQuality!.toDouble()),
                          _buildRatingItem(
                              "Hygiene", widget.item.hygiene!.toDouble()),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRatingItem(String title, double rating) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          RateWidget(
            rating: rating.round(),
            size: 28,
            padding: EdgeInsets.zero,
            editable: false,
          ),
        ],
      ),
    );
  }
}

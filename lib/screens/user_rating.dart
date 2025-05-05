import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user/constants/color_constants.dart';
import 'package:user/models/orderReviewModal.dart';
import 'package:user/widgets/rate_widget.dart';

class UserList extends StatelessWidget {
  const UserList({super.key, required this.item});
  final OrderReview item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.all(20),
        // height: MediaQuery.of(context).size.height * 0.50,
        decoration: BoxDecoration(
          color: ColorConstants.getBackgroundColor(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColorConstants.getForegroundColor(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 3), // horizontal & vertical offset
            ),
          ],
        ),
        child: Column(children: [
          Row(
            children: [
              CircleAvatar(
                child: Icon(Icons.account_circle_rounded),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                item.reviewerName ?? "",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Vegetables & Fruites Quality",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      RateWidget(
                        rating: item.vegetablesFruitsQuality ?? 0,
                        size: 32,
                        padding: EdgeInsets.zero,
                        editable: false,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Delivery Experience",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      RateWidget(
                        rating: item.deliveryExperience ?? 0,
                        size: 32,
                        padding: EdgeInsets.zero,
                        editable: false,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Packaging Quality",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      RateWidget(
                        rating: item.packagingQuality ?? 0,
                        size: 32,
                        padding: EdgeInsets.zero,
                        editable: false,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Hygiene",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      RateWidget(
                        rating: item.hygiene ?? 0,
                        size: 32,
                        padding: EdgeInsets.zero,
                        editable: false,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ]),
      ),
    );
  }
}

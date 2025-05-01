import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/constants/color_constants.dart';
import 'package:user/widgets/rate_widget.dart';

class UserList extends StatelessWidget {
  const UserList({super.key, required this.item});
  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(
          color: ColorConstants.getBackgroundColor(context),
          borderRadius: BorderRadius.circular(20),
          border:
          Border.all(color: ColorConstants.getForegroundColor(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 3), // horizontal & vertical offset
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item['comment']),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                CircleAvatar(
                  child: Icon(Icons.account_circle_rounded),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RateWidget(
                      rating: item['rating'],
                      size: 40,
                      editable: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Text(
                        item['userName'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

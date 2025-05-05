import 'package:flutter/material.dart';
import 'package:user/constants/strings.dart';
import 'package:user/models/businessLayer/global.dart' as global;

class AppBarTitleMessage extends StatelessWidget {
  final bool showMessage;
  const AppBarTitleMessage({super.key, this.showMessage = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              global.defaultImage,
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              Strings.appName,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
        SizedBox(height: showMessage ? 10 : 0),
        showMessage
            ? Text(
                Strings.appMessage,
                style: TextStyle(fontSize: 15, color: Colors.white),
              )
            : SizedBox(),
        SizedBox(height: 10)
      ],
    );
  }
}

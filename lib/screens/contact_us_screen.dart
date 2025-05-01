import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '/constants/color_constants.dart';
import '/constants/strings.dart';
import '/widgets/screen_header.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: ColorConstants.getForegroundColor(context)
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenHeader(title: Strings.contactUs),
          SizedBox(
            height: 20,
          ),
          _buildTile(
            context,
            title: Strings.callUs,
            onTap: () {
              _contactUs();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(color: ColorConstants.getForegroundColor(context)),
          ),
          _buildTile(
            context,
            title: Strings.emailUs,
            onTap: () {
              _contactUs(uri: Strings.mailToUrl);
            },
          )
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, {required String title, required Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: InkWell(
        onTap: onTap,
        splashColor: ColorConstants.getForegroundColor(context).withOpacity(0.3),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              Icon(Icons.north_east)
            ],
          ),
        ),
      ),
    );
  }

  void _contactUs({String uri = Strings.callUsUrl}) async {
    final Uri url = Uri.parse(uri);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Could not launch $url";
    }
  }
}

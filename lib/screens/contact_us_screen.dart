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
      backgroundColor: Colors.white,
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

  Widget _buildTile(
      BuildContext context, {
        required String title,
        required VoidCallback? onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor:
        Theme.of(context).colorScheme.primary.withOpacity(0.1),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300), // light grey border
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const Icon(
                Icons.north_east,
                size: 20,
                color: Colors.black87,
              )
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

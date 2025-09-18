import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/screens/location_screen.dart';
import 'package:user/theme/style.dart';
import 'package:user/widgets/app_bar_title_message.dart';

class DashboardLocationTitle extends StatelessWidget {
  final FirebaseAnalytics? analytics;
  final FirebaseAnalyticsObserver? observer;
  final Function() getCurrentPosition;

  const DashboardLocationTitle(
      {super.key,
      this.analytics,
      this.observer,
      required this.getCurrentPosition});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        global.currentLocation != null
            ? Text(
                "${AppLocalizations.of(context)!.txt_deliver}",
                style: boldCaptionStyle(context).copyWith(color: Colors.white),
              )
            : SizedBox(),
        GestureDetector(
          onTap: () async {
            if (global.lat != null && global.lng != null) {
              Get.to(() => LocationScreen(
                    analytics: analytics,
                    observer: observer,
                  ));
            } else {
              await getCurrentPosition().then((_) async {
                if (global.lat != null && global.lng != null) {
                  Get.to(() => LocationScreen(
                        analytics: analytics,
                        observer: observer,
                      ));
                }
              });
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  global.currentLocation != null
                      ? global.currentLocation!
                      : '${AppLocalizations.of(context)!.txt_deliver} No Location',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: textTheme.bodyLarge!.copyWith(color: Colors.white),
                ),
              ),
              Transform.rotate(
                angle: pi / 2,
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

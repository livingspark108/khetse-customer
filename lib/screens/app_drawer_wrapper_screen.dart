import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/screens/app_menu_screen.dart';
import 'package:user/screens/dashboard_screen.dart';
import 'package:user/screens/home_screen.dart';
import 'package:user/widgets/swiper_drawer.dart';

class AppDrawerWrapperScreen extends BaseRoute {
  AppDrawerWrapperScreen({super.analytics, super.observer, super.routeName = 'AppDrawerWrapperScreen'});

  @override
  _AppDrawerWrapperScreenState createState() => _AppDrawerWrapperScreenState();
}

class _AppDrawerWrapperScreenState extends BaseRouteState {
  GlobalKey<SwiperDrawerState> drawerKey = GlobalKey<SwiperDrawerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body:

        Container(
        decoration: BoxDecoration(
        color: Colors.white, // keep background same
        border: Border.all(
        color: Colors.grey.shade300, // 👈 border color
        width: 2, // 👈 border thickness
    ),
    borderRadius: BorderRadius.circular(30), // 👈 rounded corners (same as radius)
    ),
    child:
    SwiperDrawer(
        radius: 30,
        bodySize: 40,
        key: drawerKey,
        hasClone: false,
        bodyBackgroundPeekSize: 30,
        backgroundColor: Colors.white,
        // pass drawer widget
        drawer: AppMenuScreen(
          analytics: widget.analytics,
          observer: widget.observer,
          drawerKey: drawerKey,
          onBackPressed: () {
            drawerKey.currentState!.closeDrawer();
            if (global.isNavigate) {
              Get.to((HomeScreen(
                analytics: widget.analytics,
                observer: widget.observer,
              )));
            }
          },
        ),
        // pass body widget
        child:


    DashboardScreen(
          analytics: widget.analytics,
          observer: widget.observer,
          onAppDrawerButtonPressed: () {
            if (drawerKey.currentState!.isOpened()) {
              drawerKey.currentState!.closeDrawer();
            } else {
              drawerKey.currentState!.openDrawer();
            }
          },
        ),
      ),
    ));
  }
}

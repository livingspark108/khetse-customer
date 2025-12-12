import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/controllers/home_controller.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/screens/app_drawer_wrapper_screen.dart';
import 'package:user/screens/cart_screen.dart';
import 'package:user/screens/login_screen.dart';
import 'package:user/screens/order_history_screen.dart';
import 'package:user/screens/search_results_screen.dart';
import 'package:user/screens/search_screen.dart';
import 'package:user/screens/user_profile_screen.dart';
import 'package:user/widgets/my_bottom_navigation_bar.dart';

class HomeScreen extends BaseRoute {
  final int? screenId;
  final Function? onAppDrawerButtonPressed;
  HomeScreen(
      {super.analytics,
      super.observer,
      super.routeName = 'HomeScreen',
      this.onAppDrawerButtonPressed,
      this.screenId});
  @override
  _HomeScreenState createState() => _HomeScreenState(
      onAppDrawerButtonPressed: onAppDrawerButtonPressed, screenId: screenId);
}

class _HomeScreenState extends BaseRouteState {
  int? screenId;
  Function? onAppDrawerButtonPressed;
  final CartController cartController = Get.put(CartController());
  final HomeController homeController = Get.put(HomeController());

  _HomeScreenState({this.onAppDrawerButtonPressed, this.screenId});

  @override
  Widget build(BuildContext context) {
    final List<Widget> _homeScreenItems = [
      AppDrawerWrapperScreen(
        analytics: widget.analytics,
        observer: widget.observer,
      ),
      Container(),
      OrderHistoryScreen(
          analytics: widget.analytics, observer: widget.observer),
      UserProfileScreen(analytics: widget.analytics, observer: widget.observer),
    ];

    return WillPopScope(
      onWillPop: () async {
        exitAppDialog();
        return false;
      },
      child: GetBuilder<HomeController>(
        builder: (controller) {
          return Scaffold(
            // appBar: AppBar(
            //   automaticallyImplyLeading: false,
            //   toolbarHeight: 100,
            //   surfaceTintColor: Colors.transparent,
            //   title: Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 10.0),
            //     child: Column(
            //       children: [
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Image.asset(
            //               global.defaultImage,
            //               height: 40,
            //             ),
            //             SizedBox(width: 10),
            //             Text('Khet Se'),
            //           ],
            //         ),
            //         SizedBox(height: 10),
            //         Text(
            //           'Order by 11:59 PM for next day delivery',
            //           style: TextStyle(fontSize: 15),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // body: IndexedStack(
            //   index: controller.tabIndex,
            //   children: _homeScreenItems,
            // ),
            body: _homeScreenItems[controller.tabIndex],

            // body: Builder(
            //   builder: (context) {
            //     switch (controller.tabIndex) {
            //       case 0:
            //         return AppDrawerWrapperScreen(analytics: widget.analytics, observer: widget.observer);
            //       case 2:
            //         return OrderHistoryScreen(analytics: widget.analytics, observer: widget.observer);
            //       case 3:
            //         return UserProfileScreen(analytics: widget.analytics, observer: widget.observer);
            //       default:
            //         return Container(); // Search is handled via navigation
            //     }
            //   },
            // ),
            bottomNavigationBar: MyBottomNavigationBar(
              onTap: (value) {
                if (value == 1)
                  return Get.to(() => SearchResultsScreen(
                      analytics: widget.analytics, observer: widget.observer, searchParams:
                  ""));
                if (value == 2) {
                  if (global.currentUser?.id == null) {
                    return Get.to(() => LoginScreen(
                        analytics: widget.analytics,
                        observer: widget.observer));
                  }
                }
                if (value == 3) {
                  if (global.currentUser?.id == null) {
                    return Get.to(() => LoginScreen(
                        analytics: widget.analytics,
                        observer: widget.observer));
                  }
                }

                if (value == 4) {
                  if (global.currentUser?.id == null) {
                    return Get.to(() => LoginScreen(
                        analytics: widget.analytics,
                        observer: widget.observer));
                  }
                }
                controller.changeTabIndex(value);
              },
            ),
            floatingActionButton: Stack(
              clipBehavior: Clip.none,
              children: [
                FloatingActionButton(
                  child: const Icon(Icons.add_shopping_cart_outlined),
                  onPressed: () {
                    if (global.currentUser?.id == null) {
                      Get.to(() => LoginScreen(
                          analytics: widget.analytics, observer: widget.observer));
                    } else {
                      Get.to(() => CartScreen(
                          analytics: widget.analytics, observer: widget.observer));
                    }
                  },
                ),

                // BADGE POSITION
                Positioned(
                  right: -2,
                  top: -2,
                  child: GetBuilder<CartController>(
                    builder: (controller) {
                      return controller.cartItemsList == null ||
                          controller.cartItemsList!.cartList.isEmpty
                          ? SizedBox()
                          : Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "${global.cartCount}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    cartController.getCartList();
    if (screenId == 1) {
      homeController.changeTabIndex(4);
    } else if (screenId == 2) {
      homeController.changeTabIndex(2);
    } else {
      homeController.changeTabIndex(0);
    }
    global.isNavigate = false;
  }
}

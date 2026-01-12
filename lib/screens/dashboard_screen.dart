import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:user/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/homeScreenDataModel.dart';
import 'package:user/screens/login_screen.dart';
import 'package:user/screens/notification_screen.dart';
import 'package:user/screens/product_description_screen.dart';
import 'package:user/screens/product_request_screen.dart';
import 'package:user/screens/productlist_screen.dart';
import 'package:user/screens/search_results_screen.dart';
import 'package:user/screens/search_screen.dart';
import 'package:user/screens/wallet_screen.dart';
import 'package:user/utils/navigation_utils.dart';
import 'package:user/widgets/app_bar_title_message.dart';
import 'package:user/widgets/dashboard_widgets.dart';

import '../models/notificationModel.dart';

class DashboardScreen extends BaseRoute {
  final Function()? onAppDrawerButtonPressed;

  DashboardScreen(
      {super.analytics,
      super.observer,
      super.routeName = 'DashboardScreen',
      this.onAppDrawerButtonPressed});

  @override
  _DashboardScreenState createState() =>
      _DashboardScreenState(onAppDrawerButtonPressed: onAppDrawerButtonPressed);
}

class _DashboardScreenState extends BaseRouteState {
  Function()? onAppDrawerButtonPressed;
  Future<HomeScreenData> _homeScreenData =
      Future.delayed(Duration(seconds: 8), () => throw 'No Data');
  IconData lastTapped = Icons.notifications;
  AnimationController? menuAnimation;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CartController cartController = Get.put(CartController());

  _DashboardScreenState({this.onAppDrawerButtonPressed});
  bool hasUnreadNotifications = false;
  Future<void> markNotificationsAsRead() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('allNotificationsRead', true);
  }

  Future<void> _checkUnreadNotifications() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (!isConnected) return;

      var response = await apiHelper.getAllNotification(1); // first page
      if (response != null && response.statusCode == 200) {
        var notifications = response.data as List<NotificationModel>;

        // Check if any notification is unread (e.g., is_read != 1)
        hasUnreadNotifications = notifications.any((n) => n.readByUser != 1);

        setState(() {}); // update UI
      }
    } catch (e) {
      print("Exception in _checkUnreadNotifications: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: DashboardFloatingActionButton(
            analytics: widget.analytics,
            observer: widget.observer,
            callNumberStore: callNumberStore,
            inviteFriendShareMessage: br.inviteFriendShareMessage),
        appBar:
              PreferredSize(
                preferredSize: const Size.fromHeight(140),
                child: AppBar(

                  automaticallyImplyLeading: false,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  flexibleSpace: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                     SizedBox(height: 40,),
                     AppBarTitleMessage(),

                      // ✅ White row content (your given logic plugged in)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left: Drawer + Location
                            Row(
                              children: [
                                IconButton(
                                  visualDensity:
                                  const VisualDensity(horizontal: -4, vertical: -4),
                                  icon: const Icon(
                                    Icons.menu,
                                    color: Colors.black,
                                  ),
                                  onPressed: onAppDrawerButtonPressed,
                                ),
                                DashboardLocationTitle(
                                  analytics: widget.analytics,
                                  observer: widget.observer,
                                  getCurrentPosition: getCurrentPosition,
                                ),
                              ],
                            ),

                            // Right: Wallet + Search + Notifications
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (global.currentUser!.id == null) {
                                          Get.to(() => LoginScreen(
                                              analytics: widget.analytics,
                                              observer: widget.observer));
                                        } else {
                                          Get.to(
                                                () => WalletScreen(
                                              analytics: widget.analytics,
                                              observer: widget.observer,
                                            ),
                                          );
                                        }
                                      },
                                      child: Icon(
                                        Icons.account_balance_wallet_outlined,
                                        color: Colors.green,
                                      ),
                                    ),

                                  ],
                                ),
                                IconButton(
                                  visualDensity: const VisualDensity(horizontal: -4),
                                  icon: const Icon(Icons.search_outlined,
                                      color: Colors.black),
                                  onPressed: () => Navigator.of(context).push(
                                    NavigationUtils.createAnimatedRoute(
                                      1.0,
                                      SearchResultsScreen(
                                        analytics: widget.analytics,
                                        observer: widget.observer,
                                        searchParams: "",
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  visualDensity: VisualDensity(horizontal: -4),
                                  icon: Icon(
                                    Icons.article,
                                    color: Colors.black,
                                  ),
                                  onPressed: () => Get.to(() => ProductRequestScreen(
                                    analytics: widget.analytics,
                                    observer: widget.observer,
                                  )),
                                ),
                                global.currentUser?.id != null
                                    ?
                                Stack(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.notifications),
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) =>  NotificationScreen()),
                                        );
                                        // ✅ Recheck after coming back
                                        _checkUnreadNotifications();
                                      },
                                    ),
                                    if (hasUnreadNotifications)
                                      Positioned(
                                        right: 8,
                                        top: 8,
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                  ],
                                )


                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),



        body: RefreshIndicator(
          onRefresh: () async {
            await _onRefresh();
          },
          child: FutureBuilder<HomeScreenData>(
            future: _homeScreenData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const DashboardLoadingView();
              }
              else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(global.locationMessage ?? "Something went wrong"),
                    ),
                  );
                }

                if (global.nearStoreModel != null &&
                    global.nearStoreModel?.id != null &&
                    snapshot.hasData) {
                  final data = snapshot.data!;
                  final bool hasStore = global.nearStoreModel != null && global.nearStoreModel?.id != null;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DashboardAppNotice(),
                         Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                          child: DashboardScreenHeading(),
                        ),

                        if (data.banner.isNotEmpty)
                          DashboardBanner(items: _bannerItems(data)),

                        if (data.topCat.isNotEmpty)
                          DashboardCategories(
                            analytics: widget.analytics,
                            observer: widget.observer,
                            topCategoryList: data.topCat,
                          ),

                        if (data.dealproduct.isNotEmpty)
                          DashboardBundleProducts(
                            analytics: widget.analytics,
                            observer: widget.observer,
                            title:
                            "${AppLocalizations.of(context)!.tle_bundle_offers}",
                            categoryName:
                            '${AppLocalizations.of(context)!.tle_bundle_offers} ${AppLocalizations.of(context)!.tle_products}',
                            dealProducts: data.dealproduct,
                            screenId: 1, showAddToCart: hasStore,
                          ),

                        if (data.catProdList.isNotEmpty)
                          DashboardProductListByCategory(
                            analytics: widget.analytics,
                            observer: widget.observer,
                            productListByCategory: data.catProdList,
                          ),

                        if (data.whatsnewProductList.isNotEmpty)
                          DashboardBundleProducts(
                            analytics: widget.analytics,
                            observer: widget.observer,
                            title:
                            "${AppLocalizations.of(context)!.lbl_whats_new}",
                            categoryName:
                            '${AppLocalizations.of(context)!.lbl_whats_new} ${AppLocalizations.of(context)!.tle_products}',
                            dealProducts: data.whatsnewProductList,
                            screenId: 3,
                            showAddToCart: hasStore,
                          ),

                        if (data.secondBanner.isNotEmpty)
                          DashboardBanner(
                            margin: const EdgeInsets.only(top: 20),
                            items: _secondBannerItems(data),
                          ),

                        if (data.spotLightProductList.isNotEmpty)
                          DashboardBundleProducts(
                            analytics: widget.analytics,
                            observer: widget.observer,
                            title:
                            "${AppLocalizations.of(context)!.lbl_in_spotlight} ${AppLocalizations.of(context)!.tle_products}",
                            categoryName:
                            '${AppLocalizations.of(context)!.lbl_in_spotlight} ${AppLocalizations.of(context)!.tle_products}',
                            dealProducts: data.spotLightProductList,
                            screenId: 4,
                            showAddToCart: hasStore,
                          ),

                        if (data.recentSellingProductList.isNotEmpty)
                          DashboardBundleProducts(
                            analytics: widget.analytics,
                            observer: widget.observer,
                            title:
                            "${AppLocalizations.of(context)!.lbl_recent_selling} ${AppLocalizations.of(context)!.tle_products}",
                            categoryName:
                            '${AppLocalizations.of(context)!.lbl_recent_selling} ${AppLocalizations.of(context)!.tle_products}',
                            dealProducts: data.recentSellingProductList,
                            screenId: 5,
                            showAddToCart: hasStore,
                          ),

                        if (data.topselling.isNotEmpty)
                          DashboardTopSellingProductList(
                            analytics: widget.analytics,
                            observer: widget.observer,
                            topSellingProducts: data.topselling,
                          ),
                      ],
                    ),
                  );
                }

                // ✅ If no store data but snapshot has some data
                if (snapshot.hasData) {
                  final data = snapshot.data!;

                  final bool hasStore = global.nearStoreModel != null && global.nearStoreModel?.id != null;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (data.whatsnewProductList.isNotEmpty)
                          DashboardBundleProducts(
                            analytics: widget.analytics,
                            observer: widget.observer,
                            title: "${AppLocalizations.of(context)!.lbl_whats_new}",
                            categoryName:
                            '${AppLocalizations.of(context)!.lbl_whats_new} ${AppLocalizations.of(context)!.tle_products}',
                            dealProducts: data.whatsnewProductList,
                            screenId: 3,
                            showAddToCart: hasStore,
                          ),
                        if (data.secondBanner.isNotEmpty)
                          DashboardBanner(
                            margin: const EdgeInsets.only(top: 20),
                            items: _secondBannerItems(data),
                          ),
                        if (data.spotLightProductList.isNotEmpty)
                          DashboardBundleProducts(
                            analytics: widget.analytics,
                            observer: widget.observer,
                            title:
                            "${AppLocalizations.of(context)!.lbl_in_spotlight} ${AppLocalizations.of(context)!.tle_products}",
                            categoryName:
                            '${AppLocalizations.of(context)!.lbl_in_spotlight} ${AppLocalizations.of(context)!.tle_products}',
                            dealProducts: data.spotLightProductList,
                            screenId: 4,
                            showAddToCart: hasStore,
                          ),
                      ],
                    ),
                  );
                }

                // ✅ Fallback UI if everything else fails
                return Center(
                  child: Text(global.locationMessage ?? "No data available"),
                );
              }
              else {
                // Shouldn't normally happen
                return const Center(child: Text("Unexpected state"));
              }
            },


          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    menuAnimation = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _init();

  }

  List<Widget> _bannerItems(HomeScreenData homeScreenData) {
    List<Widget> list = [];
    for (int i = 0; i < homeScreenData.banner.length; i++) {
      list.add(InkWell(
        onTap: () {
          Get.to(() => ProductListScreen(
                analytics: widget.analytics,
                observer: widget.observer,
                categoryId: homeScreenData.banner[i].catId,
                screenId: 0,
                categoryName: homeScreenData.banner[i].title,
              ));
        },
        child: CachedNetworkImage(
          imageUrl:
              global.appInfo!.imageUrl! + homeScreenData.banner[i].bannerImage!,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: AssetImage('assets/images/icon.png'),
                  fit: BoxFit.cover),
            ),
          ),
        ),
      ));
    }
    return list;
  }

  Future<HomeScreenData> _getHomeScreenData() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        dynamic result = await apiHelper.getHomeScreenData();
        if (result != null) {
          if (result.status == "1") {


            String? token = await FirebaseMessaging.instance.getToken();
            if (token != null) {


              print("Token"+token);
              await apiHelper.saveFcmToken(token);
            }
            return result.data;
          }
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - dashboard_screen.dart - _getHomeScreenData():" +
          e.toString());
    }

    throw 'No HomeScreen Data';
  }

  _init() async {
    try {
      if (global.lat == null && global.lng == null) {
        await getCurrentPosition();
      }

      _homeScreenData = _getHomeScreenData();

      if (global.currentUser?.id != null) {
        cartController.getCartList();
      }
      setState(() {
        _checkUnreadNotifications();


      });
    } catch (e) {
      print("Exception - dashboard_screen.dart - _init():" + e.toString());
    }
  }

  _onRefresh() async {
    try {
      await _init();
    } catch (e) {
      print("Exception - dashboard_screen.dart - _onRefresh():" + e.toString());
    }
  }

  List<Widget> _secondBannerItems(HomeScreenData homeScreenData) {
    List<Widget> list = [];
    for (int i = 0; i < homeScreenData.secondBanner.length; i++) {
      list.add(InkWell(
        onTap: () {
          Get.to(() => ProductDescriptionScreen(
                analytics: widget.analytics,
                observer: widget.observer,
                productId: homeScreenData.secondBanner[i].varientId,
                screenId: 0,
              ));
        },
        child: CachedNetworkImage(
          imageUrl: global.appInfo!.imageUrl! +
              homeScreenData.secondBanner[i].bannerImage!,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: AssetImage('assets/images/icon.png'),
                  fit: BoxFit.cover),
            ),
          ),
        ),
      ));
    }
    return list;
  }

  void callNumberStore(store_number) async {
    await launchUrlString('tel:$store_number');
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:user/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/constants/color_constants.dart';
import 'package:user/constants/image_constants.dart';
import 'package:user/controllers/user_profile_controller.dart';
import 'package:user/models/addressModel.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/userModel.dart';
import 'package:user/screens/add_address_screen.dart';
import 'package:user/screens/addressListScreen.dart';
import 'package:user/screens/change_password_screen.dart';
import 'package:user/screens/chat_screen.dart';
import 'package:user/screens/login_screen.dart';
import 'package:user/screens/membership_screen.dart';
import 'package:user/screens/order_history_screen.dart';
import 'package:user/screens/profile_edit_screen.dart';
import 'package:user/screens/refer_and_earn_screen.dart';
import 'package:user/screens/uploadphoto.dart';
import 'package:user/screens/wallet_screen.dart';
import 'package:user/screens/wishlist_screen.dart';
import 'package:user/widgets/app_bar_title_message.dart';
import 'package:user/widgets/profile_picture.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserInfoTile extends StatefulWidget {
  final String? value;
  final Widget? leadingIcon;
  final String heading;
  final Function? onPressed;
  final Key? key;

  UserInfoTile(
      {required this.heading,
      this.value,
      this.leadingIcon,
      this.onPressed,
      this.key})
      : super();

  @override
  _UserInfoTileState createState() => _UserInfoTileState(
      heading: heading,
      value: value,
      leadingIcon: leadingIcon,
      onPressed: onPressed,
      key: key);
}

class UserOrdersDashboardBox extends StatefulWidget {
  final String heading;
  final String? value;

  UserOrdersDashboardBox({required this.heading, this.value}) : super();

  @override
  _UserOrdersDashboardBoxState createState() =>
      _UserOrdersDashboardBoxState(heading: heading, value: value);
}

class UserProfileScreen extends BaseRoute {
  UserProfileScreen(
      {super.analytics, super.observer, super.routeName = 'UserProfileScreen'});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserInfoTileState extends State<UserInfoTile> {
  String? value;
  Widget? leadingIcon;
  String heading;
  Function? onPressed;
  var key;

  _UserInfoTileState(
      {required this.heading,
      this.value,
      this.leadingIcon,
      this.onPressed,
      this.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      key: key,
      onTap: () => onPressed!(),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  leadingIcon ?? Container(),
                  leadingIcon == null ? Container() : SizedBox(width: 8),
                  Text(
                    heading,
                    style: textTheme.bodyLarge!.copyWith(
                        fontWeight:
                            value == null ? FontWeight.bold : FontWeight.normal,
                        fontSize: 15),
                  ),
                ],
              ),
              SizedBox(height: 8),
              value == null
                  ? Container()
                  : Text(
                      value!,
                      style: textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
              value == null ? Container() : SizedBox(height: 8),
              Divider(
                thickness: 2.0,
              ),
            ],
          ),
          onPressed == null
              ? Container()
              : Positioned(
                  bottom: 24,
                  right: global.isRTL ? null : 0,
                  left: global.isRTL ? 0 : null,
                  child: Icon(
                    Icons.chevron_right,
                  ),
                ),
        ],
      ),
    );
  }
}

class _UserOrdersDashboardBoxState extends State<UserOrdersDashboardBox> {
  String? value;
  Widget? leadingIcon;
  String heading;
  Function? onPressed;

  _UserOrdersDashboardBoxState({required this.heading, this.value});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          heading,
          style: textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value!,
          style: textTheme.titleMedium,
        )
      ],
    );
  }
}

_signOutDialog(BuildContext context) async {
  try {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: ThemeData(dialogBackgroundColor: Colors.white),
            child: CupertinoAlertDialog(
              title: Text(
                '${AppLocalizations.of(context)!.btn_logout}  ',
              ),
              content: Text(
                '${AppLocalizations.of(context)!.txt_logout_app_msg}  ',
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('${AppLocalizations.of(context)!.lbl_cancel}'),
                  onPressed: () {
                    return Navigator.of(context).pop(false);
                  },
                ),
                CupertinoDialogAction(
                  child: Text('${AppLocalizations.of(context)!.btn_logout}',
                      style: TextStyle(color: Colors.red)),
                  onPressed: () async {
                   //global.sp!.remove("currentUser");
                    SharedPreferences prefs = await SharedPreferences.getInstance();


                    await prefs.setBool('allNotificationsRead', true);

                    await prefs.remove('lastUserId');
                    global.sp!.clear();

                    global.currentUser = CurrentUser();
                    Get.offAll(
                      () => LoginScreen(),
                    );
                  },
                ),
              ],
            ),
          );
        });
  } catch (e) {
    print(
        'Exception - app_menu_screen.dart - exitAppDialog(): ' + e.toString());
  }
}

class _UserProfileScreenState extends BaseRouteState {
  bool _isDataLoaded = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final user = global.userProfileController.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xfffffffff),
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarTitleMessage(showMessage: true),
            ],
          ),
        ),
        body: _isDataLoaded
            ? GetBuilder<UserProfileController>(
                init: global.userProfileController,
                builder: (value) => RefreshIndicator(
                      onRefresh: () async {
                        _isDataLoaded = false;
                        global.userProfileController.currentUser =
                            CurrentUser();
                        setState(() {});
                        await _getMyProfile();
                      },
                      child:

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child:

   // adjust according to your project

 SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Profile header
    Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Center( child:
      ProfilePicture( isShow: false, radius: 30, ), ),
    const SizedBox(width: 12),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    (user?.name != null && user!.name!.isNotEmpty)
    ? user.name!
        : "User",
    style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 4),
    Text(
    user?.userPhone ?? "",
    style: const TextStyle(
    color: Colors.grey,
    fontSize: 14,
    ),
    ),
    ],
    ),
    ),
    IconButton(
    onPressed: () {
    Get.to(() => ProfileEditScreen(
    analytics: null, observer: null)); // pass params
    },
    icon: const Icon(Icons.edit, size: 22),
    ),
    ],
    ),
    const SizedBox(height: 20),

    // Menu list
    _buildMenuTile(
    Icons.account_balance_wallet,
    "My Wallet",
    onTap: () => Get.to(() => WalletScreen(
      analytics: widget.analytics,
      observer: widget.observer,
    )),
    ),
    _divider(),
    _buildMenuTile(
    Icons.favorite,
    "Wishlist",
    iconColor: Colors.pink,
    onTap: () => Get.to(() => WishListScreen(
      analytics: widget.analytics,
      observer: widget.observer,
    )),
    ),
    _divider(),
    _buildMenuTile(
    Icons.history,
    "Order History",
    onTap: () => Get.to(() => OrderHistoryScreen(
      analytics: widget.analytics,
      observer: widget.observer,
    disableWillpop: false,
    )),
    ),
    _divider(),
    _buildMenuTile(
    Icons.chat,
    "Live Chat",
    onTap: () => Get.to(() => ChatScreen(
    analytics: widget.analytics,
    observer: widget.observer,
    )),
    ),
      _divider(),
      _buildMenuTile(
        Icons.subscriptions,
        "Membership",
        onTap: () =>
            Get.to(() => MemberShipScreen(
          analytics: widget.analytics,
          observer: widget.observer,
        )),
      ),
    _divider(),
    _buildMenuTile(
    Icons.location_on_outlined,
    "Address List",
    onTap: () =>
        Get.to(() => AddressListScreen(
      analytics: widget.analytics,
      observer: widget.observer,
    )),
    ),
    const SizedBox(height: 60),

    // Refer section
    GestureDetector(
    onTap: () => Get.to(() => ReferAndEarnScreen(
      analytics: widget.analytics,
      observer: widget.observer,
    )),
    child: Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
    color: Colors.green.shade50,
    borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
    children: const [
    Icon(Icons.group_outlined, color: Colors.black87),
    SizedBox(width: 12),
    Expanded(
    child: Text(
    "Refer and Earn",
    style: TextStyle(
    fontSize: 15, fontWeight: FontWeight.w500),
    ),
    ),
    Icon(Icons.arrow_forward_ios,
    size: 16, color: Colors.black54),
    ],
    ),
    ),
    ),
    const SizedBox(height: 16),

    // Logout button
    GestureDetector(
    onTap: () {
    if (user?.id != null) {
    _signOutDialog(context);
    } else {
    Get.to(() => LoginScreen(
    analytics: null,
    observer: null,
    ));
    }
    },
    child: Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
    color: Colors.red.shade50,
    borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
    child: Text(
    user?.id == null ? "Login / Signup" : "Logout",
    style: const TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.bold,
    fontSize: 15,
    ),
    ),
    ),
    ),
    ),
    ],
    ),
    ),
                      ),
                    ))
            : _shimmer());
  }
  Widget _divider() {
    return const Divider(height: 1, thickness: 0.6);
  }

  Widget _buildMenuTile(IconData icon, String title,
      {Color? iconColor, VoidCallback? onTap}) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: iconColor ?? Colors.black87),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }



  @override
  void initState() {
    super.initState();
    if (global.currentUser!.id != null) {
      _getMyProfile();
    }
  }

  _getMyProfile() async {
    try {
      await global.userProfileController.getMyProfile();

      if (global.userProfileController.isDataLoaded.value == true) {
        _isDataLoaded = true;
      } else {
        _isDataLoaded = false;
      }
      setState(() {});
    } catch (e) {
      print("Exception - UserProfileScreen.dart - _getMyProfile():" +
          e.toString());
    }
  }

  _shimmer() {
    try {
      return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(
                    child: CircleAvatar(
                      radius: 50,
                      child: Card(),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 60,
                        child: Card()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 80,
                          width: (MediaQuery.of(context).size.width - 30) / 3,
                          child: Card()),
                      SizedBox(
                          height: 80,
                          width: (MediaQuery.of(context).size.width - 30) / 3,
                          child: Card()),
                      SizedBox(
                          height: 80,
                          width: (MediaQuery.of(context).size.width - 30) / 3,
                          child: Card()),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  child: SizedBox(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: Card()),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  child: SizedBox(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: Card()),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  child: SizedBox(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: Card()),
                ),
              ],
            ),
          ));
    } catch (e) {
      print("Exception - UserProfileScreen.dart - _shimmer():" + e.toString());
    }
  }
}

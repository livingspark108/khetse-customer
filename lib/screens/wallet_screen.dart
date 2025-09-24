import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/controllers/user_profile_controller.dart';
import 'package:user/models/businessLayer/apiHelper.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/walletModel.dart';
import 'package:user/screens/payment_screen.dart';

class WalletScreen extends BaseRoute {
  WalletScreen({super.analytics, super.observer, super.routeName = 'WalletScreen'});

  @override
  _WalletScreenState createState() => new _WalletScreenState();
}

class _WalletScreenState extends BaseRouteState {
  ScrollController _rechargeHistoryScrollController = ScrollController();
  ScrollController _walletSpentScrollController = ScrollController();
  TextEditingController _cAmount = new TextEditingController();
  int rechargeHistoryPage = 1;
  int walletSpentPage = 1;
  bool _isDataLoaded = false;
  bool _isRechargeHistoryPending = true;
  bool _isSpentHistoryPending = true;
  bool _isRechargeHistoryMoreDataLoaded = false;
  bool _isSpentHistoryMoreDataLoaded = false;
  List<Wallet> _walletRechargeHistoryList = [];
  List<Wallet> _walletSpentHistoryList = [];
  GlobalKey<ScaffoldState>? _scaffoldKey;
  APIHelper apiHelper4 = new APIHelper();
  _WalletScreenState() : super();
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "${AppLocalizations.of(context)!.btn_my_wallet}",
            style: textTheme.titleLarge,

          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.keyboard_arrow_left)),
        ),
        body: SafeArea(
          child: _isDataLoaded
              ? Padding(
            padding: const EdgeInsets.only(top: 25),
            child:

         /*   Column(
              children: [
                Text(
                  "${AppLocalizations.of(context)!.lbl_available_balance}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: GetBuilder<UserProfileController>(init: global.userProfileController, builder: (value) => Text("${global.appInfo?.currencySign} ${global.userProfileController.currentUser?.wallet ?? '0.00'}", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 25))),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 80,
                      child: AppBar(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        bottom: TabBar(
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 3.0,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            insets: EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                          labelColor: Theme.of(context).colorScheme.onSecondaryContainer,
                          indicatorWeight: 4,
                          unselectedLabelStyle: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w400),
                          labelStyle: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Color(0xFFEF5656),
                          tabs: [
                            Tab(
                                icon: Icon(
                                  MdiIcons.wallet,
                                  size: 18,
                                ),
                                child: Text(
                                  '${AppLocalizations.of(context)!.lbl_recharge_history}',
                                  textAlign: TextAlign.center,
                                )),
                            Tab(
                                icon: Icon(
                                  MdiIcons.walletPlus,
                                  size: 18,
                                ),
                                child: Text(
                                  '${AppLocalizations.of(context)!.lbl_wallet_recharge}',
                                  textAlign: TextAlign.center,
                                )),
                            Tab(
                                icon: Icon(
                                  MdiIcons.currencyInr,
                                  size: 18,
                                ),
                                child: Text(
                                  '${AppLocalizations.of(context)!.lbl_spent_analysis}',
                                  textAlign: TextAlign.center,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TabBarView(
                      children: [
                        _rechargeHistoryWidget(),
                        _rechargeWallet(),
                        _spentAnalysis(),
                      ],
                    ),
                  ),
                ),
              ],
            ),*/

            Column(
              children: [
                // Wallet Balance Card
                Container(
                  width: double.infinity, // cover full screen width
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/backwallet.png"), // your image
                      fit: BoxFit.cover, // cover whole container
                    ),
                  ),

                  child: Column(
                    children: [
                      const Text(
                        "Available Balance",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                   GetBuilder<UserProfileController>(init: global.userProfileController, builder: (value) => Text("${global.appInfo?.currencySign} ${global.userProfileController.currentUser?.wallet ?? '0.00'}", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 25,color: Colors.white))),


                      const SizedBox(height: 6),
                      const Text(
                        "Happy Shopping!",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),

                // TabBar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TabBar(

                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(width: 3, color: Colors.green),
                      insets: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.black54,
                    tabs: [
                      Tab(
                        icon: Icon(MdiIcons.wallet, size: 18),
                        child: const Text("Recharge History",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12)),
                      ),
                      Tab(
                        icon: Icon(MdiIcons.walletPlus, size: 18),
                        child: const Text("Wallet Recharge",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12)),
                      ),
                      Tab(
                        icon: Icon(MdiIcons.currencyInr, size: 18),
                        child: const Text("Transaction History",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),

                // TabBar Content
                Expanded(
                  child: TabBarView(

                    children: [

                      Padding(padding: EdgeInsets.all(10),child:

                      _rechargeHistoryWidget(),),

            Padding(padding: EdgeInsets.all(10),child:
                      _rechargeWallet(),),
            Padding(padding: EdgeInsets.all(10),child:
                      _spentAnalysis(),),
                    ],
                  ),
                ),
              ],
            ),
          )
              : _shimmerWidget(),
        )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _getWalletRechargeHistory() async {
    try {
      if (_isRechargeHistoryPending) {
        setState(() {
          _isRechargeHistoryMoreDataLoaded = true;
        });
        if (_walletRechargeHistoryList.isEmpty) {
          rechargeHistoryPage = 1;
        } else {
          rechargeHistoryPage++;
        }
        await apiHelper4.getWalletRechargeHistory(rechargeHistoryPage).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              List<Wallet> _tList = result.data;
              if (_tList.isEmpty) {
                _isRechargeHistoryPending = false;
              }
              _walletRechargeHistoryList.addAll(_tList);
              setState(() {
                _isRechargeHistoryMoreDataLoaded = false;
              });
            }
          }
        });
      }
    } catch (e) {
      print("Exception - wallet_screen.dart  - _getWalletRechargeHistory():" + e.toString());
    }
  }

  _getWalletSpentHistory() async {
    try {
      if (_isSpentHistoryPending) {
        setState(() {
          _isSpentHistoryMoreDataLoaded = true;
        });
        if (_walletSpentHistoryList.isEmpty) {
          walletSpentPage = 1;
        } else {
          walletSpentPage++;
        }
        await apiHelper4.getWalletSpentHistory(walletSpentPage).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              List<Wallet> _tList = result.data;
              if (_tList.isEmpty) {
                _isSpentHistoryPending = false;
              }
              _walletSpentHistoryList.addAll(_tList);
              setState(() {
                _isSpentHistoryMoreDataLoaded = false;
              });
            }
          }
        });
      }
    } catch (e) {
      print("Exception - wallet_screen.dart  - _getWalletSpentHistory():" + e.toString());
    }
  }

  _init() async {
    try {
      print("token   ${global.currentUser?.token}  ${global.userProfileController.currentUser?.wallet} ${global.currentUser?.wallet}  ||||    id   ${global.currentUser?.id}");
      await _getWalletRechargeHistory();
      await _getWalletSpentHistory();
      await _getAppInfo();
      _rechargeHistoryScrollController.addListener(() async {
        if (_rechargeHistoryScrollController.position.pixels == _rechargeHistoryScrollController.position.maxScrollExtent && !_isRechargeHistoryMoreDataLoaded) {
          setState(() {
            _isRechargeHistoryMoreDataLoaded = true;
          });
          await _getWalletRechargeHistory();
          setState(() {
            _isRechargeHistoryMoreDataLoaded = false;
          });
        }
      });

      _walletSpentScrollController.addListener(() async {
        if (_walletSpentScrollController.position.pixels == _walletSpentScrollController.position.maxScrollExtent && !_isSpentHistoryMoreDataLoaded) {
          setState(() {
            _isSpentHistoryMoreDataLoaded = true;
          });
          await _getWalletSpentHistory();
          setState(() {
            _isSpentHistoryMoreDataLoaded = false;
          });
        }
      });
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - wallet_screen.dart - _init():" + e.toString());
    }
  }

  _getAppInfo() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper4.getAppInfo(global.currentUser?.id != null ? global.currentUser!.id : null).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              global.appInfo = result.data;
              global.userProfileController.currentUser!.wallet = global.appInfo!.userwallet;
              setState(() { });
            }
          }
        });
      }
    } catch (e) {
      print("Exception - wallet_screen.dart - _getAppInfo():" + e.toString());
    }
  }

  Widget _rechargeHistoryWidget() {
    return _walletRechargeHistoryList.length > 0
        ? SingleChildScrollView(
            controller: _rechargeHistoryScrollController,
            child: Column(
              children: [
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _walletRechargeHistoryList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 6.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                Text(
                                      '${_walletRechargeHistoryList[index].paymentGateway}', style: TextStyle(color: Colors.black, fontSize: 16),
                                    ),

                                  Expanded(child: SizedBox()),
                                  Icon(
                                    MdiIcons.checkDecagram,
                                    size: 20,
                                    color: _walletRechargeHistoryList[index].rechargeStatus == 'success' ? Colors.greenAccent : Colors.red,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      '${_walletRechargeHistoryList[index].rechargeStatus}',
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ListTile(
                              visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                              contentPadding: EdgeInsets.all(0),
                              minLeadingWidth: 0,
                              title: Text(
                                '${_walletRechargeHistoryList[index].dateOfRecharge}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              trailing: Text(
                                "${global.appInfo!.currencySign} ${_walletRechargeHistoryList[index].amount}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            Divider(
                              color: Theme.of(context).dividerTheme.color,
                            ),
                          ],
                        ),
                      );
                    }),
                _isRechargeHistoryMoreDataLoaded
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : SizedBox()
              ],
            ),
          )
        : Center(
            child: Text(
              "${AppLocalizations.of(context)!.txt_nothing_to_show}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
  }

  Widget _rechargeWallet() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enter Amount Label
          const Text(
            "Enter Amount",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // Amount Input Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  "₹",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: TextField(
                    controller: _cAmount,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "0",
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Quick Select Buttons
          Wrap(
            spacing: 12,
            children: [
              _amountChip("+1200", "1200"),
              _amountChip("+1000", "1000"),
              _amountChip("+500", "500"),
              _amountChip("+100", "100"),
            ],
          ),

          const SizedBox(height: 32),

          // Add Money Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                if (_cAmount.text.trim().isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PaymentGatewayScreen(
                        screenId: 3,
                        totalAmount: double.parse(_cAmount.text.trim()),
                        analytics: widget.analytics,
                        observer: widget.observer,
                      ),
                    ),
                  );
                } else {
                  showSnackBar(
                    key: _scaffoldKey,
                    snackBarMessage:
                    '${AppLocalizations.of(context)!.txt_enter_amount}',
                  );
                }
              },
              child: const Text(
                "Add Money",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Reusable Chip Widget (clickable)
  Widget _amountChip(String label, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _cAmount.text = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }


// Reusable Chip Widget



  Widget _shimmerWidget() {
    try {
      return Padding(
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 0, top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: SizedBox(
                  height: 80,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: Card(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        child: Card(),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      width: 20,
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        child: Card(),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      width: 20,
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        child: Card(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: SizedBox(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            child: Card(),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ));
    } catch (e) {
      print("Exception - wallet_screen.dart - _shimmerWidget():" + e.toString());
      return SizedBox();
    }
  }

  Widget _spentAnalysis() {
    return _walletSpentHistoryList.length > 0
        ? SingleChildScrollView(
            controller: _walletSpentScrollController,
            child: Column(
              children: [
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _walletSpentHistoryList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                      color: Color(0xFFFFBEBE),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                    child: Text(
                                      '#${_walletSpentHistoryList[index].cartId}',
                                      style: TextStyle(color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    '${_walletSpentHistoryList[index].delivery_date}',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                  )
                                ],
                              ),
                              Expanded(child: SizedBox()),
                              Text(
                                "${global.appInfo!.currencySign} ${_walletSpentHistoryList[index].paidbywallet}",
                                style: Theme.of(context).textTheme.titleMedium,
                              )
                            ],
                          ),
                          Divider(
                            color: Theme.of(context).dividerTheme.color,
                          ),
                        ],
                      );
                    }),
                _isRechargeHistoryMoreDataLoaded
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : SizedBox()
              ],
            ),
          )
        : Center(
            child: Text(
              "${AppLocalizations.of(context)!.txt_nothing_to_show}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
  }
}

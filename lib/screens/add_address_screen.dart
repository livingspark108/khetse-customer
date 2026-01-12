import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:user/l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/models/addressModel.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/cityModel.dart';
import 'package:user/models/societyModel.dart';
import 'package:user/screens/placesearch.dart';
import 'package:user/widgets/bottom_button.dart';
import 'package:user/widgets/my_text_field.dart';

class AddAddressScreen extends BaseRoute {
  final Address? address;
  final int? screenId;
  AddAddressScreen(this.address, {super.analytics, super.observer, super.routeName = 'AddAddressScreen', this.screenId});
  @override
  _AddAddressScreenState createState() => new _AddAddressScreenState(this.address, screenId);
}

class _AddAddressScreenState extends BaseRouteState {
  String? venueadd;
  LatLng? _cityLatLng;
  int _touchCount=0;
  var _cAddress = new TextEditingController();
  var _cLandmark = new TextEditingController();
  var _cPincode = new TextEditingController();
  var _cState = new TextEditingController();
  var _cCity = new TextEditingController();
  var _cName = new TextEditingController();
  var _cPhone = new TextEditingController();
  var _cSociety = new TextEditingController();
  var _cSearchSociety = new TextEditingController();
  var _fSociety = new FocusNode();
  var _fName = new FocusNode();
  var _fPhone = new FocusNode();
  var _fAddress = new FocusNode();
  var _fLandmark = new FocusNode();
  var _fPincode = new FocusNode();
  var _fState = new FocusNode();
  var _fCity = new FocusNode();
  var _fDismiss = new FocusNode();
  GlobalKey<ScaffoldState>? _scaffoldKey;
  Society? _selectedSociety = new Society();
  String type = 'Home';
  Address? address;
  int? screenId;
  bool _isDataLoaded = false;
  var _cSearchCity = new TextEditingController();
  City? _selectedCity = new City();
 // Society? _selectedSociety = new Society();
  bool _mapDraggable = true;
  List<City>? _citiesList = [];
  List<Society>? _societyList = [];
  List<City> _tCityList = [];
  List<Society> _tSocietyList = [];
  LatLng? _selectedLatLng;
/*  List<Society>? _societyList = [];
  List<Society> _tSocietyList = [];*/
  var _fSearchSociety = new FocusNode();
  double? latitude,longitute;
  GoogleMapController? _controller;
  _AddAddressScreenState(this.address, this.screenId) : super();
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.keyboard_arrow_left,
              ),
            ),
            title: address!.addressId == null
                ? Text(
                    '${AppLocalizations.of(context)!.tle_add_new_address}',
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                : Text(
                    '${AppLocalizations.of(context)!.tle_edit_address}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
          ),
          body: global.nearStoreModel != null && global.nearStoreModel!.id != null
              ? _isDataLoaded
                  ? SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                            margin: EdgeInsets.only(top: 15, left: 16, right: 16),
                            padding: EdgeInsets.only(),
                            child: MyTextField(
                              Key('19'),
                              controller: _cName,
                              focusNode: _fName,
                              autofocus: false,
                              textCapitalization: TextCapitalization.words,
                              hintText: '${AppLocalizations.of(context)!.lbl_name}',
                              onFieldSubmitted: (val) {
                                setState(() {});
                                FocusScope.of(context).requestFocus(_fPhone);
                              },
                              onChanged: (value) {},
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                            margin: EdgeInsets.only(top: 15, left: 16, right: 16),
                            padding: EdgeInsets.only(),
                            child: MyTextField(
                              Key('20'),
                              controller: _cPhone,
                              focusNode: _fPhone,
                              autofocus: false,
                              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(global.appInfo!.phoneNumberLength)],
                              hintText: '${AppLocalizations.of(context)!.lbl_phone_number} ',
                              onFieldSubmitted: (val) {
                                FocusScope.of(context).requestFocus(_fAddress);
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                            margin: EdgeInsets.only(top: 15, left: 16, right: 16),
                            padding: EdgeInsets.only(),
                            child: MyTextField(
                              Key('21'),
                              controller: _cAddress,
                              focusNode: _fAddress,
                              hintText: '${AppLocalizations.of(context)!.txt_address} ',
                              onFieldSubmitted: (val) {
                                FocusScope.of(context).requestFocus(_fLandmark);
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                            margin: EdgeInsets.only(top: 15, left: 16, right: 16),
                            padding: EdgeInsets.only(),
                            child: MyTextField(
                              Key('22'),
                              controller: _cLandmark,
                              focusNode: _fLandmark,
                              hintText: '${AppLocalizations.of(context)!.hnt_near_landmark} ',
                              onFieldSubmitted: (val) {
                                FocusScope.of(context).requestFocus(_fPincode);
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                            margin: EdgeInsets.only(top: 15, left: 16, right: 16),
                            padding: EdgeInsets.only(),
                            child: MyTextField(
                              Key('23'),
                              controller: _cPincode,
                              focusNode: _fPincode,
                              hintText: ' ${AppLocalizations.of(context)!.hnt_pincode}',
                              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                              onFieldSubmitted: (val) {
                                FocusScope.of(context).requestFocus(_fSociety);
                              },
                            ),
                          ),


                       Padding(padding: EdgeInsets.all(20),
                       child:
                          CustomPlaceAutocomplete(


                            onPlaceSelected: (latLng, address) {
                              setState(() {
                                _selectedLatLng = latLng;
                                _cityLatLng=latLng;
                                venueadd=address;
                                latitude = latLng.latitude;
                                longitute = latLng.longitude;
                              });
                              _controller?.animateCamera(CameraUpdate.newLatLng(latLng));
                            },
                          ),),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Listener(
                              onPointerDown: (_) {
                                _touchCount++;
                                setState(() {}); // Track finger count
                              },
                              onPointerUp: (_) {
                                _touchCount = (_touchCount - 1).clamp(0, 10);
                                setState(() {});
                              },
                              child: GestureDetector(
                                // Prevent parent (Form) scroll during gestures on the map
                                onVerticalDragDown: (_) {},
                                behavior: HitTestBehavior.opaque,

                                child: SizedBox(
                                  width:  MediaQuery.of(context).size.width * 2,
                                  child: Stack(
                                    children: [

                                      _cityLatLng!=null?

                                      GoogleMap(
                                        initialCameraPosition: CameraPosition(
                                          target: _cityLatLng!,
                                          zoom: 12,
                                        ),
                                        onMapCreated: (controller) => _controller = controller,
                                        markers: {
                                          Marker(
                                            markerId: const MarkerId("selectedLocation"),
                                            position: _selectedLatLng ?? _cityLatLng!,
                                            infoWindow: const InfoWindow(title: "Selected Location"),
                                            draggable: true,
                                            onDragEnd: (newPosition) {
                                              setState(() {
                                                _selectedLatLng = newPosition;
                                                latitude = newPosition.latitude;
                                                longitute = newPosition.longitude;
                                              });
                                            },
                                          ),
                                        },

                                        zoomGesturesEnabled: true,
                                        scrollGesturesEnabled: _mapDraggable,
                                        zoomControlsEnabled: false,
                                        gestureRecognizers: {
                                          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                                        },
                                        onTap: (latLng) {
                                          setState(() {
                                            _selectedLatLng = latLng;
                                            latitude = latLng.latitude;
                                            longitute = latLng.longitude;
                                          });
                                        },
                                      )
                                          :Container()
                                      ,
                                      // Lock/Unlock toggle button
                                      Positioned(
                                        left: 16,
                                        top: 16,
                                        child: FloatingActionButton.extended(
                                          heroTag: "toggle_drag",
                                          onPressed: () {
                                            setState(() {
                                              _mapDraggable = !_mapDraggable;
                                            });
                                          },
                                          label: Text(_mapDraggable ? "Lock Map" : "Drag Map"),
                                          icon: Icon(_mapDraggable ? Icons.lock_open : Icons.lock),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                                  margin: EdgeInsets.only(top: 15, left: 16, right: 8),
                                  padding: EdgeInsets.only(),
                                  child: MyTextField(
                                    Key('25'),
                                    controller: _cCity,
                                    focusNode: _fCity,
                                    hintText: '${AppLocalizations.of(context)!.lbl_city} ',
                                    readOnly: true,
                                    onTap: _showCitySelectDialog,                                    onFieldSubmitted: (val) {
                                      FocusScope.of(context).requestFocus(_fState);
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                                  margin: EdgeInsets.only(top: 15, left: 8, right: 16),
                                  padding: EdgeInsets.only(),
                                  child: MyTextField(
                                    Key('26'),
                                    controller: _cState,
                                    focusNode: _fState,
                                    readOnly: address!.addressId != null ? true : false,
                                    hintText: '${AppLocalizations.of(context)!.hnt_state} ',
                                    onFieldSubmitted: (val) {
                                      FocusScope.of(context).requestFocus(_fDismiss);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                            margin: EdgeInsets.only(top: 15, left: 16, right: 16),
                            padding: EdgeInsets.only(),
                            child: MyTextField(
                              Key('24'),
                              controller: _cSociety,
                              focusNode: _fSociety,
                              readOnly: true,
                              maxLines: 3,
                              hintText: '${AppLocalizations.of(context)!.lbl_society} ',
                              onFieldSubmitted: (val) {
                                FocusScope.of(context).requestFocus(_fCity);
                              },
                              onTap: () {
                                _showSocietySelectDialog();
                              },
                            ),
                          ),
                          ListTile(
                            title: Text(
                              '${AppLocalizations.of(context)!.lbl_save_address}',
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  child: InkWell(
                                    onTap: () {
                                      type = 'Home';
                                      setState(() {});
                                    },
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            color: type == 'Home' ? Theme.of(context).colorScheme.primary : Theme.of(context).scaffoldBackgroundColor),
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${AppLocalizations.of(context)!.txt_home} ",
                                          style: TextStyle(
                                            color: type == 'Home' ? Colors.white : Colors.black,
                                            fontWeight: type == 'Home' ? FontWeight.w400 : FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        )),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    type = 'Office';
                                    setState(() {});
                                  },
                                  customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                          color: type == 'Office' ? Theme.of(context).colorScheme.primary : Theme.of(context).scaffoldBackgroundColor),
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${AppLocalizations.of(context)!.txt_office} ",
                                        style: TextStyle(
                                          color: type == 'Office' ? Colors.white : Colors.black,
                                          fontWeight: type == 'Office' ? FontWeight.w400 : FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  child: InkWell(
                                    onTap: () {
                                      type = 'Others';
                                      setState(() {});
                                    },
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            color: type == 'Others' ? Theme.of(context).colorScheme.primary : Theme.of(context).scaffoldBackgroundColor),
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                        alignment: Alignment.center,
                                        child: Text("${AppLocalizations.of(context)!.txt_others}",
                                            style: TextStyle(
                                              color: type == 'Others' ? Colors.white : Colors.black,
                                              fontWeight: type == 'Others' ? FontWeight.w400 : FontWeight.w700,
                                              fontSize: 13,
                                            ))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : _shimmerList()
              : Center(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(global.locationMessage!),
                  ),
                ),
          bottomNavigationBar: _isDataLoaded
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: BottomButton(
                      key: UniqueKey(),
                      child: Text("${AppLocalizations.of(context)!.btn_save_address}"),
                      loadingState: false,
                      disabledState: false,
                      onPressed: () {
                        _save();
                      }),
                )
              : null,
        ),
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

    if (global.nearStoreModel != null && global.nearStoreModel!.id != null) {
      _init();
    }
  }

  _fillData() {
    try {
      _cName.text = address!.receiverName!;
      _cPhone.text = address!.receiverPhone!;
      _cPincode.text = address!.pincode!;
      _cAddress.text = address!.houseNo!;
      _cSociety.text = address!.society!;
      _cState.text = address!.state!;
      _cCity.text = address!.city!;
      _cLandmark.text = address!.landmark!;
    } catch (e) {
      print("Excetion - addAddessScreen.dart - _fillData():" + e.toString());
    }
  }

  _getSocietyList() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getSocietyForAddress().then((result) async {
          if (result != null) {
            if (result.status == "1") {
              _societyList = result.data;
              _tSocietyList.addAll(_societyList!);
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - add_address_screen.dart -  _getSocietyList():" + e.toString());
    }
  }

  _init() async {
    try {
      await _getCities();
      await _getSocietyList();
      if (global.userProfileController.currentUser != null && global.userProfileController.addressList.length > 0) {
        await _getSociety(global.currentUser!.userCity, false);

      }
      if (address!.addressId != null) {
        _fillData();
      } else {
        // print("USER CITY N AREA${global.currentUser.userCity}, ${global.currentUser.userArea}");
        // _cCity.text = global.userProfileController.currentUser.userCity.
       // _cCity.text = global.nearStoreModel!.city!;
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - add_address_screen.dart -  _init():" + e.toString());
    }
  }
  void _showCitySelectDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              elevation: 2,
              backgroundColor:
              Theme.of(context).inputDecorationTheme.fillColor,

              title: Text(
                AppLocalizations.of(context)!.hnt_select_city,
                textAlign: TextAlign.center,
              ),

              content: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [

                    /// 🔍 SEARCH
                    TextFormField(
                      controller: _cSearchCity,
                      decoration: InputDecoration(
                        hintText:
                        AppLocalizations.of(context)!.hnt_search_city,
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onChanged: (val) {
                        dialogSetState(() {
                          _citiesList!.clear();
                          if (val.length > 2) {
                            _citiesList!.addAll(
                              _tCityList.where(
                                    (e) => e.cityName!
                                    .toLowerCase()
                                    .contains(val.toLowerCase()),
                              ),
                            );
                          } else {
                            _citiesList!.addAll(_tCityList);
                          }
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    /// 📋 CITY LIST
                    Expanded(
                      child: _citiesList!.isNotEmpty
                          ? ListView.builder(
                        itemCount: _citiesList!.length,
                        itemBuilder: (context, index) {
                          final city = _citiesList![index];
                          return RadioListTile(
                            title: Text(city.cityName!),
                            value: city,
                            groupValue: _selectedCity,
                            onChanged: (val) async {
                              dialogSetState(() {
                                _selectedCity = val;
                              });

                              _cCity.text = city.cityName!;
                              _cSociety.clear();
                              _selectedSociety = null;

                              await _getSociety(city.cityId, true);

                              Navigator.pop(context);
                            },
                          );
                        },
                      )
                          : Center(
                        child: Text(
                          AppLocalizations.of(context)!.txt_no_city,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:
                  Text(AppLocalizations.of(context)!.btn_close),
                ),
              ],
            );
          },
        );
      },
    );
  }

  _getCities() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getCity().then((result) {
          if (result != null && result.statusCode == 200 && result.status == '1') {
            _citiesList = result.data;
            _tCityList.addAll(_citiesList!);
          } else {
            _citiesList = [];
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - profile_edit_screen.dart - _getCities():" + e.toString());
    }
  }

  _getSociety(int? cityId, bool openDialog) async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getSociety(cityId).then((result) {
          if (result != null && result.statusCode == 200 && result.status == '1') {
            _societyList = result.data;

            if (openDialog) {
              _tSocietyList.addAll(_societyList!);
              Navigator.of(context).pop();
              _cSearchCity.clear();
              _showSocietySelectDialog();
            }

            setState(() {});
          } else {
            Navigator.of(context).pop();
            _cSearchCity.clear();
            _societyList = [];

            showSnackBar(key: _scaffoldKey, snackBarMessage: result.message);
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - profile_edit_screen.dart - _getSociety():" + e.toString());
    }
  }
  _save() async {
    try {
      if (_cName.text.isNotEmpty && _cPhone.text.isNotEmpty && _cPhone.text.length == global.appInfo!.phoneNumberLength && _cPincode.text.isNotEmpty && _cAddress.text.isNotEmpty && _cLandmark.text.isNotEmpty && _cSociety.text.isNotEmpty && _cCity.text.isNotEmpty) {
        bool isConnected = await br.checkConnectivity();
        if (isConnected) {
          showOnlyLoaderDialog();
          Address _tAddress = new Address();
          _tAddress.receiverName = _cName.text;
          _tAddress.receiverPhone = _cPhone.text;
          _tAddress.houseNo = _cAddress.text;
          _tAddress.landmark = _cLandmark.text;
          _tAddress.pincode = _cPincode.text;
          _tAddress.society = _cSociety.text;
          _tAddress.state = _cState.text;
          _tAddress.city = _cCity.text;
          _tAddress.type = type;
          String? latlng = await getLocationFromAddress('${_cAddress.text}, ${_cLandmark.text}, ${_cSociety.text}');
          print(latlng);
          if(latlng!=null){
            List<String> _tList = latlng.split("|");
            _tAddress.lat = _selectedLatLng!.latitude.toString();
            _tAddress.lng = _selectedLatLng!.longitude.toString();;
            if(_tAddress.lat!=null && _tAddress.lat!=null){
              if (address!.addressId != null) {
                _tAddress.addressId = address!.addressId;
                await apiHelper.editAddress(_tAddress).then((result) async {
                  if (result != null) {
                    if (result.status == "1") {
                      await global.userProfileController.getUserAddressList();

                      hideLoader();
                      Navigator.of(context).pop();
                    } else {
                      hideLoader();
                      showSnackBar(key: _scaffoldKey, snackBarMessage: '${result.message}');
                    }
                  }else{
                    hideLoader();
                    showSnackBar(key: _scaffoldKey, snackBarMessage: 'Some error occurred please try again.');
                  }
                });
              }
              else {
                await apiHelper.addAddress(_tAddress).then((result) async {
                  if (result != null) {
                    if (result.status == "1") {
                      await global.userProfileController.getUserAddressList();
                      hideLoader();
                      Navigator.of(context).pop();
                    }
                  }else{
                    hideLoader();
                    showSnackBar(key: _scaffoldKey, snackBarMessage: 'Some error occurred please try again.');
                  }
                });
                setState(() {});
              }
            }else{
              hideLoader();
              showSnackBar(key: _scaffoldKey, snackBarMessage: 'we are not able to find this location please input correct address');
            }
          }else{
            hideLoader();
            showSnackBar(key: _scaffoldKey, snackBarMessage: 'we are not able to find this location please input correct address');
          }
        } else {
          showNetworkErrorSnackBar(_scaffoldKey);
        }
      } else if (_cName.text.isEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context)!.txt_please_enter_your_name} ');
      } else if (_cPhone.text.isEmpty || (_cPhone.text.isNotEmpty && _cPhone.text.trim().length != global.appInfo!.phoneNumberLength)) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context)!.txt_please_enter_valid_mobile_number}');
      } else if (_cAddress.text.trim().isEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context)!.txt_enter_houseNo}');
      } else if (_cLandmark.text.trim().isEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context)!.txt_enter_landmark} ');
      } else if (_cPincode.text.trim().isEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context)!.txt_enter_pincode}');
      } else if (_selectedSociety!.societyId == null) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context)!.txt_select_society}');
      } else if (_cCity.text.isEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: ' ${AppLocalizations.of(context)!.txt_select_city}');
      } else if (_cState.text.isEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: '${AppLocalizations.of(context)!.txt_select_state}');
      }
    } catch (e) {
      print("Exception - add_address_screen.dart - _save():" + e.toString());
    }
  }

  Widget _shimmerList() {
    try {
      return ListView.builder(
        itemCount: 7,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 15, left: 16, right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 52,
                    width: MediaQuery.of(context).size.width,
                    child: Card(),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print("Exception - add_address_screen.dart - _shimmerList():" + e.toString());
      return SizedBox();
    }
  }

  _showSocietySelectDialog() {
    try {
      showDialog(
          context: context,
          useRootNavigator: true,
          barrierDismissible: true,
          barrierColor: Colors.transparent,
          builder: (BuildContext context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) => Container(
                  child: AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
                    title: Column(
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.hnt_select_society}',
                          style: Theme.of(context).appBarTheme.titleTextStyle,
                        ),
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                          margin: EdgeInsets.only(top: 5, bottom: 15),
                          padding: EdgeInsets.only(),
                          child: TextFormField(
                            controller: _cSearchSociety,
                            focusNode: _fSearchSociety,
                            style: Theme.of(context).textTheme.titleMedium,
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).scaffoldBackgroundColor,
                              hintText: '${AppLocalizations.of(context)!.htn_search_society}',
                              contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                            ),
                            onChanged: (val) {
                              _societyList!.clear();
                              if (val.isNotEmpty && val.length > 2) {
                                _societyList!.addAll(_tSocietyList.where((e) => e.societyName!.toLowerCase().contains(val.toLowerCase())));
                              } else {
                                _societyList!.addAll(_tSocietyList);
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    content: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: _societyList != null && _societyList!.length > 0
                          ? ListView.builder(
                              itemCount: _cSearchSociety.text.isNotEmpty && _tSocietyList.length > 0 ? _tSocietyList.length : _societyList!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return RadioListTile(
                                    title: Text(_cSearchSociety.text.isNotEmpty && _tSocietyList.length > 0 ? '${_tSocietyList[index].societyName}' : '${_societyList![index].societyName}'),
                                    value: _cSearchSociety.text.isNotEmpty && _tSocietyList.length > 0 ? _tSocietyList[index] : _societyList![index],
                                    groupValue: _selectedSociety,
                                    onChanged: (dynamic value) async {
                                      _selectedSociety = value;
                                      _cSociety.text = _selectedSociety!.societyName!;
                                      List<String> _listString = _selectedSociety!.societyName!.split(",");

                                      if (_listString.length >= 2) {
                                        _cState.text = _listString[_listString.length - 2];
                                      } else {
                                        _cState.text = ''; // or handle fallback logic here
                                      }

                                      Navigator.of(context).pop();

                                      setState(() {});
                                    });
                              })
                          : Center(
                              child: Text(
                              '${AppLocalizations.of(context)!.txt_no_society}',
                              textAlign: TextAlign.center,
                            )),
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: Text('${AppLocalizations.of(context)!.btn_close}'))
                    ],
                  ),
                ),
              ));
    } catch (e) {
      print("Exception - add_address_screen.dart - _showSocietySelectDialog():" + e.toString());
    }
  }
}

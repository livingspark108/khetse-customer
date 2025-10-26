import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_polyline_points_plus/flutter_polyline_points_plus.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:user/controllers/order_controller.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/orderModel.dart';
import 'package:user/screens/cancel_order_screen.dart';
import 'package:user/screens/cart_screen.dart';
import 'package:user/screens/home_screen.dart';
import 'package:user/widgets/bottom_button.dart';
import 'package:user/widgets/toastfile.dart';

class BezierPainter extends CustomPainter {
  final Color? color;

  final bool drawStart;
  final bool drawEnd;
  const BezierPainter({
    this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color!;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius, radius)
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius, radius)
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(BezierPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.drawStart != drawStart || oldDelegate.drawEnd != drawEnd;
  }

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }
}

class MapScreen extends BaseRoute {
  final Order? order;
  final OrderController? orderController;
  MapScreen(this.order, this.orderController, {super.analytics, super.observer, super.routeName = 'MapScreen'});
  @override
  _MapScreenState createState() => new _MapScreenState(this.order, this.orderController);
}

class _MapScreenState extends BaseRouteState {
  late GoogleMapController mapController;
  CameraPosition _initialLocation =
  CameraPosition(target: LatLng(global.lat!, global.lng!));
  Completer<GoogleMapController> _controller = Completer();

  Order? order;
  OrderController? orderController;
  Set<Marker> markers = {};
  bool _isDataLoaded = false;
  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  GlobalKey<ScaffoldState>? _scaffoldKey;
  List<String> _processes = [];
  int _processIndex = 0;

  // Colors
  final Color completeColor = Colors.green;
  final Color inProgressColor = Colors.orange;
  final Color todoColor = Colors.grey;

  List<Circle> circleList = [];

  _MapScreenState(this.order, this.orderController) : super();

  @override
  void initState() {
    super.initState();

    // Define full order flow
    _processes = [
      'Pending',
      'Placed',
      'Confirmed',
      'Out_For_Delivery',
      'Completed',
    ];

    // Determine which step is active
    _processIndex = _processes.indexOf(order!.orderStatus!);
    if (_processIndex == -1) _processIndex = 0;

    updateMarker();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.keyboard_arrow_left)),
          title: Text(
            AppLocalizations.of(context)!.tle_track_order,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: true,
        ),
        body: _isDataLoaded
            ? Stack(
          children: [


            if (order!.estimatedTime != null)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  width: 100,
                  height: 25,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColorLight,
                        Theme.of(context).primaryColor
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "ETA: ${order!.estimatedTime}",
                      style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
          ],
        )
            : const Center(child: CircularProgressIndicator()),

        // ==================== BOTTOM TIMELINE ====================
        bottomNavigationBar: Container(
          width: width,
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Timeline progress bar
              Container(
                height: 130,
                child: Timeline.tileBuilder(
                  theme: TimelineThemeData(
                    direction: Axis.horizontal,
                    connectorTheme:
                    const ConnectorThemeData(thickness: 5.0),
                  ),
                  builder: TimelineTileBuilder.connected(
                    connectionDirection: ConnectionDirection.before,
                    itemExtentBuilder: (_, __) =>
                    MediaQuery.of(context).size.width / _processes.length,
                    itemCount: _processes.length,
                    contentsBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          _processes[index],
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: getColor(index)),
                        ),
                      );
                    },
                    indicatorBuilder: (_, index) {
                      Color color = getColor(index);
                      Widget? child;

                      if (index == _processIndex) {
                        child = const Icon(Icons.check,
                            color: Colors.white, size: 16);
                      } else if (index < _processIndex) {
                        child = const Icon(Icons.check,
                            color: Colors.white, size: 16);
                      }

                      return DotIndicator(
                        size: 28,
                        color: color,
                        child: child,
                      );
                    },
                    connectorBuilder: (_, index, __) {
                      if (index < _processIndex) {
                        return SolidLineConnector(color: completeColor);
                      } else if (index == _processIndex) {
                        return SolidLineConnector(color: inProgressColor);
                      } else {
                        return SolidLineConnector(color: todoColor);
                      }
                    },
                  ),
                ),
              ),

              // Bottom action button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BottomButton(
                  loadingState: false,
                  disabledState: false,
                  onPressed: () async {
                    if (order!.orderStatus == 'Pending' ||
                        order!.orderStatus == 'Confirmed') {
                      Get.to(() => CancelOrderScreen(
                        analytics: widget.analytics,
                        observer: widget.observer,
                        order: order,
                        orderController: orderController,
                      ));
                    } else {
                      await _reOrderItems();
                    }
                  },
                  child: Text(
                    order!.orderStatus == 'Pending' ||
                        order!.orderStatus == 'Confirmed'
                        ? AppLocalizations.of(context)!.tle_cancel_order
                        : AppLocalizations.of(context)!.btn_re_order,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to get color for each step
  Color getColor(int index) {
    if (index < _processIndex) return completeColor;
    if (index == _processIndex) return inProgressColor;
    return todoColor;
  }

  _init() async {
    _isDataLoaded = true;
    setState(() {});
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData =
    await DefaultAssetBundle.of(context).load("assets/images/scooter.png");
    return byteData.buffer.asUint8List();
  }

  Future<bool> updateMarker() async {
    try {
      markers.clear();
      polylines.clear();
      polylineCoordinates.clear();

      double startLatitude = order!.storeLat!;
      double startLongitude = order!.storeLng!;
      Marker startMarker = Marker(
        markerId: const MarkerId('store'),
        position: LatLng(startLatitude, startLongitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(180),
      );

      Marker destinationMarker = Marker(
        markerId: const MarkerId('user'),
        position: LatLng(order!.userLat!, order!.userLng!),
        icon: BitmapDescriptor.defaultMarker,
      );

      markers.add(startMarker);
      markers.add(destinationMarker);
      return true;
    } catch (e) {
      debugPrint('Error updating markers: $e');
      return false;
    }
  }

  _reOrderItems() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await apiHelper.reOrder(order!.cartid).then((result) async {
        Navigator.of(context).pop();
        if (result != null && result.status == "1") {
          Get.to(() => CartScreen(
            analytics: widget.analytics,
            observer: widget.observer,
          ));
        } else {
          showToast(AppLocalizations.of(context)!.txt_something_went_wrong);
        }
      });
    } catch (e) {
      debugPrint("Reorder error: $e");
      Navigator.of(context).pop();
    }
  }
}

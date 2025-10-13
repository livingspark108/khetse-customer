import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/controllers/order_controller.dart';
import 'package:user/models/businessLayer/apiHelper.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/orderModel.dart';
import 'package:user/screens/cancel_order_screen.dart';
import 'package:user/screens/cart_screen.dart';
import 'package:user/screens/map_screen.dart';
import 'package:user/screens/order_summary_screen.dart';
import 'package:user/screens/rating_review_screen.dart';
import 'package:user/utils/string_formatter.dart';
import 'package:user/widgets/toastfile.dart';

class OrderHistoryCard extends StatefulWidget {
  final Order? order;
  final dynamic analytics;
  final dynamic observer;
  final int? index;

  OrderHistoryCard({this.order, this.analytics, this.observer, this.index})
      : super();

  @override
  _OrderHistoryCardState createState() => _OrderHistoryCardState(
      order: order, analytics: analytics, observer: observer, index: index);
}

class _OrderHistoryCardState extends State<OrderHistoryCard> {
  Order? order;
  dynamic analytics;
  dynamic observer;
  final OrderController orderController = Get.find();
  int? index;
  APIHelper apiHelper = new APIHelper();
  final CartController cartController = Get.put(CartController());
  List<String?> _productName = [];

  _OrderHistoryCardState(
      {this.order, this.analytics, this.observer, this.index});
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < order!.productList.length; i++) {
      _productName.add(order!.productList[i].productName);
    }
    _productName = _productName.toSet().toList();

    TextTheme textTheme = Theme.of(context).textTheme;

    // ===== Status Badge Colors =====
    Color statusColor = order!.orderStatus == "Delivered"
        ? Colors.green.shade100
        : order!.orderStatus == "Pending"
        ? Colors.orange.shade100
        : Colors.grey.shade200;

    Color textColor = order!.orderStatus == "Delivered"
        ? Colors.green
        : order!.orderStatus == "Pending"
        ? Colors.orange
        : Colors.black87;

    return GetBuilder<OrderController>(
      init: orderController,
      builder: (orderController) => InkWell(
        onTap: () {
          Get.to(() => OrderSummaryScreen(
            analytics: widget.analytics,
            observer: widget.observer,
            order: order,
            orderController: orderController,
          ));
        },
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Color(0xffF4F4F4),
              width: 1.2,
            ),
            borderRadius: BorderRadius.circular(6.0),
          ),
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ===== Top row: Date • Time + Status badge =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${DateFormat('MMM d').format(DateTime.parse(order!.productList[0].orderDate.toString()))} • "
                          "${DateFormat('h:mm a').format(DateTime.parse(order!.productList[0].orderDate.toString()))}",
                      style: textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        order!.orderStatus.toString(),
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xffE0E0E0)),
                const SizedBox(height: 12),

                /// ===== Title + Order ID + Item count =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StringFormatter.convertListItemsToString(_productName)!,
                            style: textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Order ID: ${order!.cartid}",
                            style: textTheme.bodySmall!.copyWith(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${order!.productList.length} items",
                          style: textTheme.bodySmall,
                        ),
                        const Row(
                          children: [
                            Icon(Icons.refresh, size: 14, color: Colors.green),
                            SizedBox(width: 4),
                            Text("Everyday",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black87)),
                            Icon(Icons.keyboard_arrow_up, size: 18),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xffE0E0E0)),

                /// ===== Product List =====
                Column(
                  children: order!.productList.map((product) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              global.appInfo!.imageUrl! + product.varientImage!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported, size: 40),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productName ?? "",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${global.appInfo!.currencySign} ${product.price.toString()}",
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87),
                              ),
                              Text(
                                "${product.qty.toString()} ${product.unit ?? ""}",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const Divider(height: 20, color: Color(0xffE0E0E0)),

                /// ===== Footer: Price + Buttons =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${global.appInfo!.currencySign} ${(order!.remPrice! + order!.paidByWallet!).toStringAsFixed(2)}",
                      style: textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                              Get.to(() => OrderSummaryScreen(
                            analytics: widget.analytics,
                            observer: widget.observer,
                            order: order,
                            orderController: orderController,
                            ));
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            "View detail",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                        const SizedBox(width: 10),

                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }




  Widget _orderStatusNotifier(Order order, TextTheme textTheme) {
    if (order.orderStatus == "Pending" || order.orderStatus == "Confirmed") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [


              Text(
                "${('${order.orderStatus}'.toUpperCase() == 'PENDING' ? 'Order Placed' : order.orderStatus)}",
                style: textTheme.bodyLarge!
                    .copyWith(color: Colors.black, fontSize: 15),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Get.to(() => CancelOrderScreen(
                        analytics: widget.analytics,
                        observer: widget.observer,
                        order: order,
                        orderController: orderController,
                      )),
                  child: Text(
                    "${AppLocalizations.of(context)!.tle_cancel_order}",
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey[600]
                          : Colors.grey[300],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _trackOrder(),
                  child: Text(
                    "${AppLocalizations.of(context)!.tle_track_order}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    } else if (order.orderStatus == "Out_For_Delivery") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 5,
                backgroundColor: Colors.green,
              ),
              SizedBox(width: 8),
              Text(
                "${AppLocalizations.of(context)!.lbl_out_of_delivery}",
                style: textTheme.bodyLarge!.copyWith(
                  color: Colors.green,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => _trackOrder(),
                  child: Text(
                    "${AppLocalizations.of(context)!.tle_track_order}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    } else if (order.orderStatus == "Completed") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 5,
                backgroundColor: Colors.black,
              ),
              SizedBox(width: 8),
              Text(
                "${AppLocalizations.of(context)!.txt_completed}",
                style: textTheme.bodyLarge!.copyWith(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                global.nearStoreModel != null
                    ? TextButton(
                        onPressed: () {
                          _reOrderItems();
                        },
                        child: Text(
                          "${AppLocalizations.of(context)!.btn_reorder_items}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    : SizedBox(),
                TextButton(
                  onPressed: () => _trackOrder(),
                  child: Text(
                    "${AppLocalizations.of(context)!.tle_track_order}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final int? orderId = order.productList.length > 0 ? order.productList[0].storeOrderId : null;
                    Get.to(
                      () => RatingReviewScreen(orderId: orderId!),
                    );
                  },
                  child: Text(
                    "Rating",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (order.orderStatus == "Cancelled") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 5,
                backgroundColor: Colors.grey[600],
              ),
              SizedBox(width: 8),
              Text(
                "${AppLocalizations.of(context)!.lbl_order_cancel}",
                style: textTheme.bodyLarge!.copyWith(
                  color: Colors.grey[600],
                ),
              )
            ],
          ),
          // TextButton(
          //   onPressed: () => _trackOrder(),
          //   child: Text(
          //     "${AppLocalizations.of(context)!.tle_track_order}",
          //     style: TextStyle(
          //       color: Theme.of(context).colorScheme.primary,
          //     ),
          //   ),
          // )
        ],
      );
    } else {
      return SizedBox();
    }
  }

  _reOrderItems() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Center(child: new CircularProgressIndicator()),
          );
        },
      );
      await apiHelper.reOrder(order!.cartid).then((result) async {
        if (result != null) {
          if (result.status == "1") {
            Navigator.of(context).pop();
            Get.to(() => CartScreen(
                  analytics: widget.analytics,
                  observer: widget.observer,
                ));
          } else {
            Navigator.of(context).pop();
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   content: Text(
            //     '${AppLocalizations.of(context).txt_something_went_wrong}.',
            //     textAlign: TextAlign.center,
            //   ),
            //   duration: Duration(seconds: 2),
            // ));
            showToast(AppLocalizations.of(context)!.txt_something_went_wrong);
          }
        }
      });
      setState(() {});
    } catch (e) {
      print("Exception - order_history_card.dart - reOrderItems():" +
          e.toString());
    }
  }

  _trackOrder() async {
    try {
      await apiHelper.trackOrder(order!.cartid).then((result) async {
        if (result != null) {
          if (result.status == "1") {
            Order? _newOrder = new Order();
            _newOrder = result.data;
            Get.to(() => MapScreen(
                  _newOrder,
                  orderController,
                  analytics: widget.analytics,
                  observer: widget.observer,
                ));
          }
        }
      });
    } catch (e) {
      print("Exception - order_history_card.dart - _trackOrder():" +
          e.toString());
    }
  }
}

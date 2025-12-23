import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/categoryProductModel.dart';
import 'package:user/models/orderModel.dart';
import 'package:user/screens/rate_order_screen.dart';
import 'package:user/theme/style.dart';
import '../screens/product_description_screen.dart';

class OrderDetailsCard extends StatefulWidget {
  final Order? order;
  final dynamic analytics;
  final dynamic observer;

  OrderDetailsCard(this.order, {this.analytics, this.observer});

  @override
  _OrderDetailsCardState createState() =>
      _OrderDetailsCardState(order, analytics, observer);
}

class OrderedProductsMenuItem extends StatefulWidget {
  final Product product;

  OrderedProductsMenuItem({
    required this.product,
  });

  @override
  _OrderedProductsMenuItemState createState() =>
      _OrderedProductsMenuItemState(product: product);
}

class _OrderDetailsCardState extends State<OrderDetailsCard> {
  Order? order;
  dynamic analytics;
  dynamic observer;

  _OrderDetailsCardState(this.order, this.analytics, this.observer);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color(0xffF4F4F4),
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${AppLocalizations.of(context)!.lbl_items}",
                style: textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // ITEMS LIST
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: order!.productList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = order!.productList[index];
                  final isCancelled = item.itemStatus == "Cancelled";

                  return Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OrderedProductsMenuItem(product: item),


                        // RIGHT-SIDE DETAILS
                        Column(
                          children: [
                            // Qty | Price Row
                            Row(
                              children: [
                                Text(
                                  isCancelled
                                      ? "${item.qty}"
                                      : "${item.qty}",
                                  style: textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isCancelled
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                ),
                                Text(
                                  ' | ',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                                Text(
                                  "${global.appInfo!.currencySign} ${item.price}",
                                  style: textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isCancelled
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),

                            // RATINGS (only if NOT cancelled)
                            if (order!.orderStatus == "Completed" &&
                                !isCancelled)
                              item.userRating != null &&
                                  item.userRating!.toDouble() > 0.0
                                  ? Column(
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(top: 8),
                                    child: RatingBar.builder(
                                      initialRating:
                                      item.userRating!.toDouble(),
                                      minRating: 0,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      ignoreGestures: true,
                                      itemCount: 5,
                                      itemSize: 15,
                                      itemPadding: EdgeInsets.symmetric(
                                          horizontal: 1.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Theme.of(context)
                                            .primaryColor,
                                      ),
                                      onRatingUpdate: (value) {},
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(top: 5),
                                    child: SizedBox(
                                      height: 25,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.to(() => RateOrderScreen(
                                            order,
                                            index,
                                            analytics:
                                            widget.analytics,
                                            observer:
                                            widget.observer,
                                          ));
                                        },
                                        child: Text(
                                          '${AppLocalizations.of(context)!.btn_edit_review}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .copyWith(
                                              color: Colors.white,
                                              fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                                  : SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),


            _priceRow(
              context,
              AppLocalizations.of(context)!.txt_total_price,
              order!.totalProductsMrp!.toStringAsFixed(2),
            ),
            _priceRow(
              context,
              AppLocalizations.of(context)!.txt_discount_price,
              order!.discountonmrp != null && order!.discountonmrp! > 0
                  ? "- ${order!.discountonmrp!.toStringAsFixed(2)}"
                  : "0",
            ),
            _priceRow(
              context,
              "Discounted Price",
              order!.priceWithoutDelivery!.toStringAsFixed(2),
            ),
            _priceRow(
              context,
              AppLocalizations.of(context)!.txt_coupon_discount,
              order!.couponDiscount != null && order!.couponDiscount! > 0
                  ? "- ${order!.couponDiscount!.toStringAsFixed(2)}"
                  : "0",
            ),
            _priceRow(
              context,
              AppLocalizations.of(context)!.txt_delivery_charges,
              order!.deliveryCharge!.toStringAsFixed(2),
            ),
            _priceRow(
              context,
              AppLocalizations.of(context)!.txt_tax,
              order!.totalTaxPrice!.toStringAsFixed(2),
            ),

            _priceRow(
              context,
              "Order Amount",
              (order!.priceWithoutDelivery! - order!.couponDiscount!)
                  .toStringAsFixed(2),
              isPrimary: true,
            ),

            _priceRow(
              context,
              AppLocalizations.of(context)!.lbl_paid_by_wallet,
              "-${order!.paidByWallet!.toStringAsFixed(2)}",
            ),

            Divider(height: 32),

            _priceRow(
              context,
              "Remaining Amount\n(Paid Online/COD)",
              order!.remPrice!.toStringAsFixed(2),
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(
      BuildContext context,
      String title,
      String value, {
        bool isPrimary = false,
        bool isBold = false,
      }) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textTheme.bodyLarge!.copyWith(
              color: isPrimary ? Theme.of(context).primaryColor : null,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "${global.appInfo!.currencySign} $value",
            style: textTheme.titleSmall!.copyWith(
              color: isPrimary ? Theme.of(context).primaryColor : null,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}

class _OrderedProductsMenuItemState extends State<OrderedProductsMenuItem> {
  Product product;

  _OrderedProductsMenuItemState({required this.product});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 100,
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PRODUCT IMAGE
            InkWell(
              onTap: () {
                Get.to(() => ProductDescriptionScreen(
                  productId: product.productId,
                  screenId: 4,
                ));
              },
              child: CachedNetworkImage(
                imageUrl: global.appInfo!.imageUrl! + product.varientImage!,
                imageBuilder: (context, imageProvider) => Container(
                  padding: EdgeInsets.all(5),
                  child: SizedBox(
                    height: 80,
                    width: 40,
                    child: Image(image: imageProvider, fit: BoxFit.contain),
                  ),
                ),
                placeholder: (_, __) =>
                    SizedBox(height: 80, width: 40, child: Center(child: CircularProgressIndicator())),
                errorWidget: (_, __, ___) =>
                    Icon(Icons.image, size: 40, color: Colors.grey),
              ),
            ),

            SizedBox(width: 12),

            // DETAILS
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CANCELLED BADGE
                if (product.itemStatus == "Cancelled")
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "Cancelled",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),

                SizedBox(height: 4),

                SizedBox(
                  width: 140,
                  child: Text(
                    product.productName!,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 8),

                SizedBox(
                  width: 140,
                  child: Text(
                    product.description != null && product.description != ''
                        ? product.description!
                        : product.type!,
                    overflow: TextOverflow.ellipsis,
                    style: normalCaptionStyle(context),
                  ),
                ),

                Text(
                  "${product.quantity} ${product.unit}",
                  style: normalCaptionStyle(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

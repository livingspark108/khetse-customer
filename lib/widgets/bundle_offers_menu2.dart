import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/models/addtocartmessagestatus.dart';
import 'package:user/models/businessLayer/apiHelper.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/categoryProductModel.dart';
import 'package:user/screens/login_screen.dart';
import 'package:user/screens/product_description_screen.dart';
import 'package:user/theme/style.dart';
import 'package:user/widgets/toastfile.dart';

class BundleOffersMenu extends StatefulWidget {
  final dynamic analytics;
  final dynamic observer;
  final List<Product>? categoryProductList;
  final Function(int)? onSelected;

  BundleOffersMenu(
      {this.onSelected,
      this.categoryProductList,
      this.analytics,
      this.observer})
      : super();

  @override
  _BundleOffersMenuState createState() => _BundleOffersMenuState(
      onSelected: onSelected,
      categoryProductList: categoryProductList,
      analytics: analytics,
      observer: observer);
}

class BundleOffersMenuItem extends StatefulWidget {
  final Product product;

  final dynamic analytics;
  final dynamic observer;
  BundleOffersMenuItem({required this.product, this.analytics, this.observer})
      : super();

  @override
  _BundleOffersMenuItemState createState() => _BundleOffersMenuItemState(
      product: product, analytics: analytics, observer: observer);
}

class _BundleOffersMenuItemState extends State<BundleOffersMenuItem> {
  Product? product;
  dynamic analytics;
  dynamic observer;
  final CartController cartController = Get.put(CartController());

  int? _qty;
  _BundleOffersMenuItemState({this.product, this.analytics, this.observer});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: 180, // adjust per grid layout
      child:
        GetBuilder<CartController>(
        init: cartController,
        builder: (value) =>

        Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Product image + top labels
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child:

                  Image.network(
                 global.appInfo!.imageUrl! +
                        product!.productImage!,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.image, size: 80, color: Colors.grey),
                  ),
                ),
                // Top-left green tag (e.g. ₹47/kg)
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 2),
                  child: Text(
                    "${product!.quantity} ${product!.unit} ",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: normalCaptionStyle(context)
                        .copyWith(fontSize: 11),
                  ),
                ),
                product!.stock! > 0
                    ? InkWell(
                  onTap: () async {
                    if (global.currentUser!.id == null) {
                      Get.to(LoginScreen(
                        analytics: widget.analytics,
                        observer: widget.observer,
                      ));
                    } else {
                      if(product!.varient.length > 1) {
                        _showVarientModalBottomSheet(
                          textTheme, cartController,
                        );
                        return;
                      }
                      _qty = product!.varient[0].cartQty;
                      showOnlyLoaderDialog();
                      ATCMS? isSuccess;
                      isSuccess = await value.addToCart(
                          product, _qty, false,
                          varient: product!.varient[0]);
                      if (isSuccess!.isSuccess != null) {
                        Navigator.of(context).pop();
                      }
                      showToast(isSuccess.message!);
                      setState(() {});
                    }
                  },
                  child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryContainer,
                          borderRadius:
                          BorderRadius.circular(5)),
                      child: Text("Add")),
                )
                    : SizedBox(),
                // Wishlist icon
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ),
              ],
            ),

            // 🔹 Product details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product!.productName!,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product!.type != null && product!.type != ''
                        ? product!.type!
                        : '',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        product!.description != null && product!.description != ''
                            ? product!.description!
                            : '',
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: normalCaptionStyle(context).copyWith(fontSize: 11),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 2),
                    child: Text(
                      "${product!.quantity} ${product!.unit} ",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: normalCaptionStyle(context)
                          .copyWith(fontSize: 11),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "${global.appInfo!.currencySign} ${product!.price}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1f8a20),
                        ),
                      ),
                      SizedBox(width: 6),

                        Text(
                          "${global.appInfo!.currencySign}${product!.mrp}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            Spacer(),

            // 🔹 Add to cart button with GetBuilder
            product!.stock! > 0
                ? InkWell(
              onTap: () async {
                if (global.currentUser!.id == null) {
                  Get.to(LoginScreen(
                    analytics: widget.analytics,
                    observer: widget.observer,
                  ));
                } else {
                  if(product!.varient.length > 1) {
                    _showVarientModalBottomSheet(
                      textTheme, cartController,
                    );
                    return;
                  }
                  _qty = product!.varient[0].cartQty;
                  showOnlyLoaderDialog();
                  ATCMS? isSuccess;
                  isSuccess = await value.addToCart(
                      product, _qty, false,
                      varient: product!.varient[0]);
                  if (isSuccess!.isSuccess != null) {
                    Navigator.of(context).pop();
                  }
                  showToast(isSuccess.message!);
                  setState(() {});
                }
              },
              child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                      horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondaryContainer,
                      borderRadius:
                      BorderRadius.circular(5)),
                  child: Text("Add")),
            )
                : SizedBox()
          ],
        ),
      ),
        ) );
  }


  showOnlyLoaderDialog() {
    return showDialog(
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
  }

  _showVarientModalBottomSheet(TextTheme textTheme, CartController value) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return GetBuilder<CartController>(
            init: cartController,
            builder: (value) => Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product!.productName!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: product!.varient.length,
                      itemBuilder: (BuildContext context, int i) {
                        return ListTile(
                          title: ReadMoreText(
                            '${product!.varient[i].description}',
                            trimLines: 2,
                            trimMode: TrimMode.Line,
                            trimCollapsedText:
                                '${AppLocalizations.of(context)!.txt_show_more}',
                            trimExpandedText:
                                '${AppLocalizations.of(context)!.txt_show_less}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 16),
                            lessStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 16),
                            moreStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 16),
                          ),
                          subtitle: Text(
                              '${product!.varient[i].quantity} ${product!.varient[i].unit} / ${global.appInfo!.currencySign} ${product!.varient[i].price}  ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontSize: 15)),
                          trailing: product!.varient[i].cartQty == null ||
                                  product!.varient[i].cartQty == 0
                              ? InkWell(
                                  onTap: () async {
                                    if (global.currentUser!.id == null) {
                                      Get.to(LoginScreen(
                                        analytics: widget.analytics,
                                        observer: widget.observer,
                                      ));
                                    } else {
                                      _qty = 1;
                                      showOnlyLoaderDialog();
                                      ATCMS? isSuccess;
                                      isSuccess = await value.addToCart(
                                          product, _qty, false,
                                          varient: product!.varient[i]);
                                      if (isSuccess!.isSuccess != null) {
                                        Navigator.of(context).pop();
                                      }
                                      showToast(isSuccess.message!);
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                    height: 23,
                                    width: 23,
                                    alignment: Alignment.center,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    child: Icon(
                                      Icons.add,
                                      size: 17.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          if (product!.varient[i].cartQty !=
                                                  null &&
                                              product!.varient[i].cartQty == 1) {
                                            _qty = 0;
                                          } else {
                                            _qty =
                                                product!.varient[i].cartQty! - 1;
                                          }

                                          showOnlyLoaderDialog();
                                          ATCMS? isSuccess;
                                          isSuccess = await value.addToCart(
                                              product, _qty, true,
                                              varient: product!.varient[i]);

                                          if (isSuccess!.isSuccess != null) {
                                            Navigator.of(context).pop();
                                          }
                                          showToast(isSuccess.message!);
                                          setState(() {});
                                        },
                                        child: Container(
                                            height: 23,
                                            width: 23,
                                            alignment: Alignment.center,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            child:
                                                product!.varient[i].cartQty == 1
                                                    ? Icon(
                                                        Icons.delete,
                                                        size: 17.0,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimaryContainer,
                                                      )
                                                    : Icon(
                                                        MdiIcons.minus,
                                                        size: 17.0,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimaryContainer,
                                                      )),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        height: 23,
                                        width: 23,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  5.0)
                                              ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${product!.varient[i].cartQty}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          _qty = product!.varient[i].cartQty! + 1;

                                          showOnlyLoaderDialog();
                                          ATCMS? isSuccess;
                                          isSuccess = await value.addToCart(
                                              product, _qty, false,
                                              varient: product!.varient[i]);
                                          if (isSuccess!.isSuccess != null) {
                                            Navigator.of(context).pop();
                                          }
                                          showToast(isSuccess.message!);
                                          setState(() {});
                                        },
                                        child: Container(
                                            height: 23,
                                            width: 23,
                                            alignment: Alignment.center,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            child: Icon(
                                              MdiIcons.plus,
                                              size: 17,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int i) {
                        return Divider();
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class _BundleOffersMenuState extends State<BundleOffersMenu> {
  List<Product>? categoryProductList;
  Function(int)? onSelected;
  dynamic analytics;
  dynamic observer;
  APIHelper apiHelper = APIHelper();

  _BundleOffersMenuState(
      {this.onSelected,
      this.categoryProductList,
      this.analytics,
      this.observer});

  Future<bool> addRemoveWishList(int? varientId) async {
    bool _isAddedSuccesFully = false;
    try {
      showOnlyLoaderDialog();
      await apiHelper.addRemoveWishList(varientId).then((result) async {
        if (result != null) {
          if (result.status == "1" || result.status == "2") {
            _isAddedSuccesFully = true;
            Navigator.pop(context);
          } else {
            _isAddedSuccesFully = false;
            Navigator.pop(context);

            showSnackBar(
                snackBarMessage:
                    '${AppLocalizations.of(context)!.txt_please_try_again_after_sometime} ');
          }
        }
      });
      return _isAddedSuccesFully;
    } catch (e) {
      print("Exception - bundle_offers_menu.dart - addRemoveWishList():" +
          e.toString());
      return _isAddedSuccesFully;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 1 / 2 / 1,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoryProductList!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => Get.to(() => ProductDescriptionScreen(
                  analytics: widget.analytics,
                  observer: widget.observer,
                  productId: categoryProductList![index].productId)),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Stack(
                  children: [
                    BundleOffersMenuItem(
                      product: categoryProductList![index],
                      analytics: widget.analytics,
                      observer: widget.observer,
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: categoryProductList![index].discount != null &&
                                categoryProductList![index].discount! > 0
                            ? Container(
                                height: 16,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    bottomRight: Radius.circular(4),
                                  ),
                                ),
                                child: Text(
                                  "${categoryProductList![index].discount} % OFF",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                ),
                              )
                            : SizedBox(
                                height: 16,
                                width: 60,
                              ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: categoryProductList![index].isFavourite
                            ? Icon(
                                MdiIcons.heart,
                                size: 20,
                                color: Colors.red,
                              )
                            : Icon(
                                MdiIcons.heartOutline,
                                size: 20,
                                color: Colors.red,
                              ),
                        onPressed: () async {
                          if (global.currentUser!.id == null) {
                            Future.delayed(Duration.zero, () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen(
                                          analytics: widget.analytics,
                                          observer: widget.observer,
                                        )),
                              );
                            });
                          } else {
                            bool _isAdded = await addRemoveWishList(
                              categoryProductList![index].varientId,
                            );
                            if (_isAdded) {
                              categoryProductList![index].isFavourite =
                                  !categoryProductList![index].isFavourite;
                            }

                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  showOnlyLoaderDialog() {
    return showDialog(
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
  }

  void showSnackBar({required String snackBarMessage}) {
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text(
    //     snackBarMessage,
    //     textAlign: TextAlign.center,
    //   ),
    //   duration: Duration(seconds: 2),
    // ));
    showToast(snackBarMessage);
  }
}
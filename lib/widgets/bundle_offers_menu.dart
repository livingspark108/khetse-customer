import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
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
  final bool showAddToCart;

  BundleOffersMenu(
      {this.onSelected,
      this.categoryProductList,
      this.analytics,
      this.observer,this.showAddToCart = true,})
      : super();

  @override
  _BundleOffersMenuState createState() => _BundleOffersMenuState(
      onSelected: onSelected,
      categoryProductList: categoryProductList,
      analytics: analytics,
      observer: observer,);
}

class BundleOffersMenuItem extends StatefulWidget {
  final Product product;

  final dynamic analytics;
  final dynamic observer;
  final bool showAddToCart;
  BundleOffersMenuItem({required this.product, this.analytics, this.observer,this.showAddToCart=true})
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
    final product = widget.product;
    Future<void> _requestLocationPermission() async {
      var status = await Permission.location.request();
      if (status.isGranted) {
        showToast("Permission granted!");
      } else if (status.isDenied) {
        showToast("Permission denied.");
      } else if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    }
    return SizedBox(
      width: screenWidth * 0.53,
      height: 330, // fixed height for equal grid
      child: GetBuilder<CartController>(
        init: cartController,
        builder: (value) => Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Product Image
              SizedBox(
                height: 100,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                      child: CachedNetworkImage(
                        imageUrl: global.appInfo!.imageUrl! +
                            (product.productImage ?? ""),
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.image,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                    ),



                    // Wishlist icon


                    // Out of stock overlay
                    if (product.stock! <= 0)
                      Positioned.fill(
                        child: Container(
                          color: Colors.white.withOpacity(0.6),
                          alignment: Alignment.center,
                          child: Text(
                            "Out of Stock",
                            style: textTheme.bodyLarge!.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // 🔹 Product details (scrollable inside fixed height)
              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              "${global.appInfo!.currencySign} ${product.price}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1f8a20),
                              ),
                            ),
                            const SizedBox(width: 6),
                            if (product.price != product.mrp)
                              Text(
                                "${global.appInfo!.currencySign}${product.mrp}",
                                style: const TextStyle(
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
                ),
              ),

              // 🔹 Add to Cart Button
              if (product.stock! > 0)
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xff005832),
                    borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(12)),
                  ),
                  child: TextButton(
                    onPressed: () async {
if(widget.showAddToCart){

                      if (global.currentUser!.id == null) {
                        Get.to(LoginScreen(
                            analytics: widget.analytics,
                            observer: widget.observer));
                      } else {
                        if (product.varient.length > 1) {
                          _showVarientModalBottomSheet(
                              textTheme, cartController);
                          return;
                        }
                        _qty = product.varient[0].cartQty;
                        showOnlyLoaderDialog();
                        final isSuccess = await value.addToCart(
                          product,
                          _qty,
                          false,
                          varient: product.varient[0],
                        );
                        if (isSuccess!.isSuccess != null) {
                          Navigator.of(context).pop();
                        }
                        showToast(isSuccess.message!);
                        setState(() {});
                      }
                    }
else{
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        "No Store Found",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text(
        "Please give location permission to explore more details about our services",
        style: TextStyle(fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: ()async { Navigator.pop(context);


            await _requestLocationPermission();
         },
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    ),
  );
}

}


                    ,
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
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
      color: Colors.white,
      height:220,
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
                      showAddToCart: widget.showAddToCart,
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
                      top: 50,
                      child: IconButton(
                        icon: categoryProductList![index].isFavourite
                            ? Image.asset(
                          color: Colors.red,
                          "assets/images/heart.png",  // ✅ your asset
                          width: 20,
                          height: 20,
                        )
                            : Image.asset(
                          color: Colors.white,
                          "assets/images/heart.png",      // ✅ your asset
                          width: 20,
                          height: 20,
                        ),
                        onPressed: () async {
                         if(widget.showAddToCart)
{
                          if (global.currentUser!.id == null) {
                            Future.delayed(Duration.zero, () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(
                                    analytics: widget.analytics,
                                    observer: widget.observer,
                                  ),
                                ),
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
                        }

                         else{



                         }


                         },
                      ),
                    )

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
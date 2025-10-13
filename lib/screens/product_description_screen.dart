import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/constants/color_constants.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:user/models/addtocartmessagestatus.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/productDetailModel.dart';
import 'package:user/screens/cart_screen.dart';
import 'package:user/screens/login_screen.dart';
import 'package:user/screens/productlist_screen.dart';
import 'package:user/screens/ratingListScreen.dart';
import 'package:user/widgets/bottom_button.dart';
import 'package:user/widgets/my_chip.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/widgets/toastfile.dart';

class AppBarActionButton extends StatefulWidget {
  final Function? onPressed;
  final CartController cartController;

  AppBarActionButton(this.cartController, {this.onPressed}) : super();

  @override
  _AppBarActionButtonState createState() => _AppBarActionButtonState(
      onPressed: onPressed, cartController: cartController);
}

class ProductDescriptionScreen extends BaseRoute {
  final int? productId;
  final ProductDetail? productDetail;
  final int? screenId;

  ProductDescriptionScreen(
      {super.analytics,
      super.observer,
      super.routeName = 'ProductDescriptionScreen',
      this.productId,
      this.screenId,
      this.productDetail});

  @override
  _ProductDescriptionScreenState createState() =>
      _ProductDescriptionScreenState(
          productId: productId,
          screenId: screenId,
          productDetail: productDetail);
}

class _AppBarActionButtonState extends State<AppBarActionButton> {
  Function? onPressed;

  CartController? cartController;

  _AppBarActionButtonState({this.onPressed, this.cartController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      init: cartController,
      builder: (value) => Padding(
        padding: const EdgeInsets.all(9.0),
        child: Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.add_shopping_cart_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => onPressed!(),
            ),
            global.cartCount != 0
                ? Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        global.cartCount != 0 ? '${global.cartCount}' : '',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class _ProductDescriptionScreenState extends BaseRouteState {
  int? productId;
  ProductDetail? productDetail;
  int? screenId;
  ProductDetail? _productDetail;
  bool _isDataLoaded = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CartController cartController = Get.put(CartController());
  int _qty = 0;
  int? _selectedIndex;
  int currentImageIndex = 0;

  _ProductDescriptionScreenState(
      {this.productId, this.screenId, this.productDetail});

  // check if add to cart button is pressed once

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          _isDataLoaded
              ? _productDetail!.productDetail!.productName!
              : '${AppLocalizations.of(context)!.tle_product_details}',
          style: textTheme.titleLarge,
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.keyboard_arrow_left)),
        actions: [
          AppBarActionButton(
            cartController,
            onPressed: () async {
              if (global.currentUser!.id == null) {
                await Get.to(() => LoginScreen(
                      analytics: widget.analytics,
                      observer: widget.observer,
                    ));
              } else {
                final result = await Get.to(() => CartScreen(
                      analytics: widget.analytics,
                      observer: widget.observer,
                    ));
                if (result == true) {
                  _getProductDetail();
                }
              }
            },
          ),
        ],
      ),
      body: _isDataLoaded
          ? GetBuilder<CartController>(
              init: cartController,
              builder: (value) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: () async {
                              if (global.currentUser?.id == null) {
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
                                    _productDetail!.productDetail!.varientId);
                                if (_isAdded) {
                                  _productDetail!.productDetail!.isFavourite =
                                      !_productDetail!
                                          .productDetail!.isFavourite;
                                }

                                setState(() {});
                              }
                            },
                            child: _productDetail!.productDetail!.isFavourite
                                ? Icon(
                                    MdiIcons.heart,
                                    size: 20,
                                    color: Colors.red,
                                  )
                                : Icon(
                                    MdiIcons.heartOutline,
                                    size: 20,
                                    color: Colors.red,
                                  )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        dialogToOpenImage(
                          _productDetail!.productDetail!.productName,
                          _productDetail!.productDetail!.images,
                          0,
                        );
                      },
                      child: Container(
                        width: screenWidth,
                        height: 300,
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  children: [
                                    Expanded(
                                      child: _productDetail!.productDetail!.images.isNotEmpty
                                          ? PhotoViewGallery.builder(
                                        scrollDirection: Axis.horizontal,
                                        loadingBuilder: (BuildContext context, _) {
                                          return const Center(
                                              child: CircularProgressIndicator());
                                        },
                                        itemCount:
                                        _productDetail!.productDetail!.images.length,
                                        builder: (BuildContext context, int index) {
                                          return PhotoViewGalleryPageOptions(
                                            imageProvider: CachedNetworkImageProvider(
                                              global.appInfo!.imageUrl! +
                                                  _productDetail!.productDetail!
                                                      .images[index].image!,
                                            ),
                                          );
                                        },
                                        backgroundDecoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(40),
                                            bottomRight: Radius.circular(40),
                                          ),
                                        ),
                                        onPageChanged: (index) {
                                          setState(() {
                                            currentImageIndex = index;
                                          });
                                        },
                                      )
                                          : PhotoView(
                                        imageProvider: _productDetail!
                                            .productDetail!.productImage !=
                                            null
                                            ? CachedNetworkImageProvider(
                                          global.appInfo!.imageUrl! +
                                              _productDetail!
                                                  .productDetail!.productImage!,
                                        )
                                            : const AssetImage('assets/images/icon.png') as ImageProvider<Object>?,
                                        backgroundDecoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(40),
                                            bottomRight: Radius.circular(40),
                                          ),
                                        ),
                                        loadingBuilder: (BuildContext context, _) {
                                          return const Center(
                                              child: CircularProgressIndicator());
                                        },
                                      ),
                                    ),
                                    if (_productDetail!.productDetail!.images.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(
                                            _productDetail!.productDetail!.images.length,
                                                (index) => Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                              width: 7,
                                              height: 7,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: currentImageIndex == index
                                                    ? Colors.green
                                                    : Colors.green.shade200,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    _productNameAndPrice(textTheme),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _productDetail!.productDetail!.varient.length,
                      itemBuilder: (BuildContext context, int i) {
                        print(_productDetail!.productDetail!.varient[i].stock);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _productWeightAndQuantity(
                              textTheme, cartController, i),
                        );
                      },
                    ),



                    /// 🔘 Image Indicator
                    const SizedBox(height: 8),


                    /// 🏷️ Product Name + Discount


                    /// 🧾 Variant List


                    /// 🧾 Product Description


                    _subHeading(textTheme, "Product Description"),
                    _productDescription(textTheme),
                    _productDetail!.productDetail!.rating != null &&
                            _productDetail!.productDetail!.rating! > 0
                        ? Padding(
                            padding: EdgeInsets.only(top: 16, left: 16),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => RatingListScreen(
                                        _productDetail!
                                            .productDetail!.varientId,
                                        analytics: widget.analytics,
                                        observer: widget.observer),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 13,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text:
                                          "${_productDetail!.productDetail!.rating} ",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      children: [
                                        TextSpan(
                                          text: '|',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        TextSpan(
                                          text:
                                              ' ${_productDetail!.productDetail!.ratingCount} ${AppLocalizations.of(context)!.txt_ratings}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                    _subHeading(textTheme, "Related Products"),
                    _relatedProducts(textTheme),
                    _productDetail!.productDetail!.tags.length > 0
                        ? _subHeading(textTheme, "Tags")
                        : SizedBox(),
                    _productDetail!.productDetail!.tags.length > 0
                        ? _tags(textTheme)
                        : SizedBox(),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 32,
                        ),
                        child: BottomButton(
                            key: UniqueKey(),
                            loadingState: false,
                            disabledState: false,
                            onPressed: () {
                              if (global.currentUser!.id == null) {
                                Get.to(LoginScreen(
                                  analytics: widget.analytics,
                                  observer: widget.observer,
                                ));
                              } else {
                                if (_productDetail!.productDetail!.stock! > 0) {
                                  if (_productDetail!.productDetail!.varient
                                          .where((e) => e.cartQty! > 0)
                                          .toList()
                                          .length >
                                      0) {
                                    //go to cart
                                    Get.to(() => CartScreen(
                                          analytics: widget.analytics,
                                          observer: widget.observer,
                                        ));
                                  } else {
                                    // add to cart
                                    _showVarientModalBottomSheet(
                                        textTheme, cartController);
                                  }
                                }
                              }
                            },
                            child: _productDetail!.productDetail!.stock! > 0
                                ? _productDetail!.productDetail!.varient
                                            .where((e) => e.cartQty! > 0)
                                            .toList()
                                            .length >
                                        0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "${AppLocalizations.of(context)!.btn_go_to_cart}"),
                                          CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.shopping_cart_outlined,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        "${AppLocalizations.of(context)!.btn_add_cart}")
                                : Text(
                                    "${AppLocalizations.of(context)!.txt_out_of_stock}")))
                  ],
                ),
              ),
            )
          : _shimmer(),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _getBannerProductDetail() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getBannerProductDetail(productId).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              _productDetail = result.data;
            } else {
              _productDetail = null;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print(
          "Exception -  product_description_screen.dart - _getBannerProductDetail():" +
              e.toString());
    }
  }

  _getProductDetail() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper.getProductDetail(productId).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              _productDetail = result.data;
            } else {
              _productDetail = null;
            }
          }
          setState(() {});
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print(
          "Exception -  product_description_screen.dart - _getProductDetail():" +
              e.toString());
    }
  }

  _init() async {
    try {
      if (screenId == 0) {
        await _getBannerProductDetail();
      } else if (productDetail != null) {
        _productDetail = productDetail;
      } else {
        await _getProductDetail();
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception -  product_description_screen.dart - _init():" +
          e.toString());
    }
  }

  Widget _productDescription(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        _productDetail!.productDetail!.description != null &&
                _productDetail!.productDetail!.description != ''
            ? _productDetail!.productDetail!.description!
            : _productDetail!.productDetail!.type!,
        style: textTheme.bodyLarge!.copyWith(
          height: 1.3,
        ),
      ),
    );
  }

  Widget _productNameAndPrice(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              _productDetail!.productDetail!.productName!,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          if (_productDetail!.productDetail!.discount != null &&
              _productDetail!.productDetail!.discount! > 0)
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE6FBE6), // light green background
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${_productDetail!.productDetail!.discount}% OFF",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _productWeightAndQuantity(TextTheme textTheme, CartController value, int i) {
    final varient = _productDetail!.productDetail!.varient[i];
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Container(

        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color:Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            /// 🧾 Product variant info
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${varient.quantity} ${varient.unit}-',
                    style: textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${global.appInfo!.currencySign} ${varient.price}',
                        style: textTheme.bodyMedium!.copyWith(
                          color: Color(0xff017f01),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${global.appInfo!.currencySign} ${varient.mrp}',
                        style: textTheme.bodySmall!.copyWith(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// 🛒 Stock & Cart Actions
            varient.stock! > 0
                ? (varient.cartQty == null || varient.cartQty == 0)
                ? _addButton(theme, value, i)
                : _qtyControls(theme, value, i)
                : Text(
              AppLocalizations.of(context)!.txt_out_of_stock,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  /// ➕ Add Button
  Widget _addButton(ThemeData theme, CartController value, int i) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        if (global.currentUser!.id == null) {
          Get.to(LoginScreen(
            analytics: widget.analytics,
            observer: widget.observer,
          ));
        } else {
          _qty = 1;
          showOnlyLoaderDialog();
          ATCMS? isSuccess = await value.addToCart(
            _productDetail?.productDetail,
            _qty,
            false,
            varient: _productDetail?.productDetail?.varient[i],
          );
          if (isSuccess?.isSuccess != null) Navigator.of(context).pop();
          showToast(isSuccess?.message ?? 'Error adding to cart');
          setState(() {});
        }
      },
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.add, color: Colors.white, size: 20),
      ),
    );
  }

  /// 🔄 Quantity Controls
  Widget _qtyControls(ThemeData theme, CartController value, int i) {
    final varient = _productDetail!.productDetail!.varient[i];

    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// ➖ Minus Button
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () async {
              if (varient.cartQty != null && varient.cartQty == 1) {
                _qty = 0;
              } else {
                _qty = varient.cartQty! - 1;
              }

              showOnlyLoaderDialog();
              ATCMS? isSuccess = await value.addToCart(
                _productDetail?.productDetail,
                _qty,
                true,
                varient: varient,
              );
              if (isSuccess?.isSuccess != null) Navigator.of(context).pop();
              showToast(isSuccess?.message ??
                  'Something went wrong trying to remove the product.');
              setState(() {});
            },
            child: Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0XFFF1F1F1)  ,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                varient.cartQty == 1 ? Icons.delete : Icons.remove,
                color:Colors.black,
                size: 18,
              ),
            ),
          ),

          /// 🧾 Qty Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '${varient.cartQty}',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          /// ➕ Plus Button
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () async {
              if (varient.stock! > varient.cartQty!) {
                _qty = varient.cartQty! + 1;

                showOnlyLoaderDialog();
                ATCMS? isSuccess = await value.addToCart(
                  _productDetail?.productDetail,
                  _qty,
                  false,
                  varient: varient,
                );
                if (isSuccess?.isSuccess != null) Navigator.of(context).pop();
                showToast(isSuccess?.message ?? 'Error adding more items.');
              } else {
                showToast("No more stock available.");
              }

              setState(() {});
            },
            child: Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xfff1f1f1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.add, color: Colors.black, size: 18),
            ),
          ),
        ],
      ),
    );
  }


  Widget _relatedProducts(TextTheme textTheme) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          height: 100,
          child: ListView.builder(
            itemCount: _productDetail!.similarProductList.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  _isDataLoaded = false;
                  productId =
                      _productDetail!.similarProductList[index].productId;

                  _init();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CachedNetworkImage(
                        imageUrl: global.appInfo!.imageUrl! +
                            _productDetail!
                                .similarProductList[index].productImage!,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(image: imageProvider)),
                        ),
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => SizedBox(
                          child: Icon(
                            Icons.image,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        width: 60,
                        child: Text(
                          _productDetail!
                              .similarProductList[index].productName!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 260,
                    child: Card(
                      elevation: 0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Card(elevation: 0),
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Card(elevation: 0),
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Card(elevation: 0),
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Card(elevation: 0),
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: SizedBox(
                              width: 70,
                              child: Card(
                                elevation: 0,
                              )),
                        );
                      }),
                ),
              ],
            ),
          )),
    );
  }

  _showVarientModalBottomSheet(TextTheme textTheme, CartController value) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return GetBuilder<CartController>(
            init: cartController,
            builder: (value) => Container(
              height: (_productDetail!.productDetail!.varient.length < 2)
                  ? 200
                  : 400,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _productDetail!.productDetail!.productName!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                        itemCount:
                            _productDetail!.productDetail!.varient.length,
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            title: ReadMoreText(
                              '${_productDetail!.productDetail!.varient[i].description}',
                              trimLines: 2,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
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
                                '${_productDetail!.productDetail!.varient[i].quantity} ${_productDetail!.productDetail!.varient[i].unit} / ${global.appInfo!.currencySign} ${_productDetail!.productDetail!.varient[i].price}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontSize: 15)),
                            trailing: _productDetail!
                                        .productDetail!.varient[i].stock! >
                                    0
                                ? _productDetail!.productDetail!.varient[i]
                                                .cartQty ==
                                            null ||
                                        _productDetail!.productDetail!
                                                .varient[i].cartQty ==
                                            0
                                    ? InkWell(
                                        onTap: () async {
                                          if (_productDetail!.productDetail!
                                                  .varient[i].cartQty ==
                                              null) {
                                            _productDetail!.productDetail!
                                                .varient[i].cartQty = 0;
                                          }
                                          if (_productDetail!.productDetail!
                                                  .varient[i].stock! >=
                                              _productDetail!.productDetail!
                                                  .varient[i].cartQty!) {
                                            if (global.currentUser!.id ==
                                                null) {
                                              Get.to(LoginScreen(
                                                analytics: widget.analytics,
                                                observer: widget.observer,
                                              ));
                                            } else {
                                              _qty = 1;
                                              showOnlyLoaderDialog();
                                              ATCMS? isSuccess =
                                                  await value.addToCart(
                                                      _productDetail!
                                                          .productDetail,
                                                      _qty,
                                                      false,
                                                      varient: _productDetail!
                                                          .productDetail!
                                                          .varient[i]);

                                              if (isSuccess?.isSuccess !=
                                                  null) {
                                                Navigator.of(context).pop();
                                              }
                                              showToast(isSuccess?.message ??
                                                  'No Message was provided');
                                              setState(() {});
                                            }
                                          } else {
                                            showToast(
                                                'No more stock available for this variant');
                                          }
                                        },
                                        child: Container(
                                          height: 23,
                                          width: 23,
                                          alignment: Alignment.center,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          child: Icon(
                                            Icons.add,
                                            size: 17.0,
                                            color: ColorConstants.getBackgroundColor(context),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                if (_productDetail!
                                                            .productDetail!
                                                            .varient[i]
                                                            .cartQty !=
                                                        null &&
                                                    _productDetail!
                                                            .productDetail!
                                                            .varient[i]
                                                            .cartQty ==
                                                        1) {
                                                  _qty = 0;
                                                } else {
                                                  _qty = _productDetail!
                                                          .productDetail!
                                                          .varient[i]
                                                          .cartQty! -
                                                      1;
                                                }

                                                showOnlyLoaderDialog();
                                                ATCMS isSuccess =
                                                    await (value.addToCart(
                                                        _productDetail!
                                                            .productDetail,
                                                        _qty,
                                                        true,
                                                        varient: _productDetail!
                                                                .productDetail!
                                                                .varient[
                                                            i]) as FutureOr<
                                                        ATCMS>);
                                                if (isSuccess.isSuccess !=
                                                    null) {
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
                                                      .primary,
                                                  child: _productDetail!
                                                              .productDetail!
                                                              .varient[i]
                                                              .cartQty ==
                                                          1
                                                      ? Icon(
                                                          Icons.delete,
                                                          size: 17.0,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary,
                                                        )
                                                      : Icon(
                                                          MdiIcons.minus,
                                                          size: 17.0,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary,
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
                                                        5.0) //                 <--- border radius here
                                                    ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "${_productDetail!.productDetail!.varient[i].cartQty}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                if (_productDetail!
                                                        .productDetail!
                                                        .varient[i]
                                                        .cartQty ==
                                                    null) {
                                                  _productDetail!.productDetail!
                                                      .varient[i].cartQty = 0;
                                                }
                                                if (_productDetail!
                                                        .productDetail!
                                                        .varient[i]
                                                        .stock! >=
                                                    _productDetail!
                                                        .productDetail!
                                                        .varient[i]
                                                        .cartQty!) {
                                                  _qty = _productDetail!
                                                          .productDetail!
                                                          .varient[i]
                                                          .cartQty! +
                                                      1;

                                                  showOnlyLoaderDialog();
                                                  ATCMS isSuccess =
                                                      await (value.addToCart(
                                                          _productDetail!
                                                              .productDetail,
                                                          _qty,
                                                          false,
                                                          varient: _productDetail!
                                                                  .productDetail!
                                                                  .varient[
                                                              i]) as FutureOr<
                                                          ATCMS>);
                                                  if (isSuccess.isSuccess !=
                                                      null) {
                                                    Navigator.of(context).pop();
                                                  }
                                                  showToast(isSuccess.message!);
                                                } else {
                                                  showToast(
                                                      'No more stock available for this variant');
                                                }

                                                setState(() {});
                                              },
                                              child: Container(
                                                  height: 23,
                                                  width: 23,
                                                  alignment: Alignment.center,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  child: Icon(
                                                    MdiIcons.plus,
                                                    size: 17,
                                                    color: Colors.white,
                                                  )),
                                            )
                                          ],
                                        ),
                                      )
                                : Text(
                                    '${AppLocalizations.of(context)!.txt_out_of_stock}',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _subHeading(TextTheme textTheme, String value) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        value,
        style: textTheme.titleMedium!.copyWith(
          // color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _tags(TextTheme textTheme) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
            height: 100,
            child: Wrap(
              children: _tagsList(),
            )));
  }

  List<Widget> _tagsList() {
    List<Widget> list = [];
    for (int i = 0; i < _productDetail!.productDetail!.tags.length; i++) {
      list.add(Padding(
        padding: const EdgeInsets.only(right: 2),
        child: MyChip(
          isSelected: _productDetail!.productDetail!.tags[i].isSelected,
          onPressed: () {
            setState(() {
              _productDetail!.productDetail!.tags
                  .map((e) => e.isSelected = false)
                  .toList();
              _selectedIndex = i;
              if (_selectedIndex == i) {
                _productDetail!.productDetail!.tags[i].isSelected = true;
              }
            });
            Get.to(() => ProductListScreen(
                  analytics: widget.analytics,
                  observer: widget.observer,
                  screenId: 2,
                  categoryName: _productDetail!.productDetail!.tags[i].tag,
                ));
          },
          label: _productDetail!.productDetail!.tags[i].tag != null
              ? '#${_productDetail!.productDetail!.tags[i].tag}'
              : '',
        ),
      ));
    }
    return list;
  }
}

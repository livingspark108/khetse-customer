import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/categoryProductModel.dart';
import 'package:user/models/productFilterModel.dart';
import 'package:user/models/subCategoryModel.dart';
import 'package:user/widgets/products_menu.dart';

class SubCategoriesScreen extends BaseRoute {
  @required
  final String? screenHeading;
  @required
  final int? categoryId;

  SubCategoriesScreen({
    super.analytics,
    super.observer,
    super.routeName = 'SubCategoriesScreen',
    this.screenHeading,
    this.categoryId,
  });

  @override
  _SubCategoriesScreenState createState() => _SubCategoriesScreenState(
      categoryId: categoryId, screenHeading: screenHeading);
}

class _SubCategoriesScreenState extends BaseRouteState {
  int? categoryId;
  String? screenHeading;
  bool _isDataLoaded = false;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  ScrollController _scrollController = ScrollController();
  int page = 1;
  List<Product> _productsList = [];
  ProductFilter _productFilter = new ProductFilter();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _SubCategoriesScreenState({this.categoryId, this.screenHeading});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          screenHeading!,
          style: textTheme.titleLarge,
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.keyboard_arrow_left)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _onRefresh();
        },
        child: _isDataLoaded
            ? _productsList.length > 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          ProductsMenu(
                            analytics: widget.analytics,
                            observer: widget.observer,
                            categoryProductList: _productsList,
                          ),
                          _isMoreDataLoaded
                              ? Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                        '${AppLocalizations.of(context)!.txt_nothing_to_show}'),
                  )
            : _shimmer(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    try {
      await _getAllCategoryProducts();
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            !_isMoreDataLoaded) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          await _getAllCategoryProducts();
          setState(() {
            _isMoreDataLoaded = false;
          });
        }
      });
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - sub_categories_screen.dart - _init():" + e.toString());
    }
  }

  _getAllCategoryProducts() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          if (_productsList.isEmpty) {
            page = 1;
          } else {
            page++;
          }
          try {
            await apiHelper
                .getSubCategory(page, categoryId)
                .then((subCatResult) async {
              if (subCatResult != null && subCatResult.status == "1") {
                List<SubCategory> subCategories = subCatResult.data;

                if (subCategories.isNotEmpty) {
                  for (var subCategory in subCategories) {
                    await apiHelper
                        .getCategoryProducts(
                            subCategory.catId, 1, _productFilter)
                        .then((result) {
                      if (result != null && result.status == "1") {
                        List<Product> subCatProducts = result.data;
                        _productsList.addAll(subCatProducts);
                      }
                    });
                  }

                  if (_productsList.isEmpty) {
                    _isRecordPending = false;
                  }

                  setState(() {
                    _isMoreDataLoaded = false;
                  });
                } else {
                  _getCategoryProductsDirect();
                }
              } else {
                _getCategoryProductsDirect();
              }
            });
          } catch (e) {
            print("Error fetching subcategories: $e");
            _getCategoryProductsDirect();
          }
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print(
          "Exception - sub_categories_screen.dart - _getAllCategoryProducts():" +
              e.toString());
      setState(() {
        _isMoreDataLoaded = false;
      });
    }
  }

  _getCategoryProductsDirect() async {
    try {
      await apiHelper
          .getCategoryProducts(categoryId, page, _productFilter)
          .then((result) async {
        if (result != null) {
          if (result.status == "1") {
            List<Product> _tList = result.data;
            if (_tList.isEmpty) {
              _isRecordPending = false;
            }
            _productsList.addAll(_tList);
          } else {
            _isRecordPending = false;
          }
        } else {
          _isRecordPending = false;
        }
        setState(() {
          _isMoreDataLoaded = false;
        });
      });
    } catch (e) {
      print("Exception - direct product fetch: " + e.toString());
      setState(() {
        _isMoreDataLoaded = false;
        _isRecordPending = false;
      });
    }
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      _isRecordPending = true;
      _productsList.clear();
      setState(() {});
      await _init();
    } catch (e) {
      print("Exception - sub_categories_screen.dart - _onRefresh():" +
          e.toString());
    }
  }

  _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    height: 100 * MediaQuery.of(context).size.height / 830,
                    width: MediaQuery.of(context).size.width,
                    child: Card());
              })),
    );
  }
}

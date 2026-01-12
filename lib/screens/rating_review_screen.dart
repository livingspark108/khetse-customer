import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:user/l10n/app_localizations.dart';

import '/models/review_model.dart';
import '/widgets/toastfile.dart';
import '/constants/color_constants.dart';
import '/models/businessLayer/apiHelper.dart';
import '/widgets/loader.dart';
import '/widgets/rate_widget.dart';
import '/widgets/screen_header.dart';

class RatingReviewScreen extends StatefulWidget {
  final int orderId;
  const RatingReviewScreen({super.key, required this.orderId});

  @override
  State<RatingReviewScreen> createState() => _RatingReviewScreenState();
}

class _RatingReviewScreenState extends State<RatingReviewScreen> {
  late APIHelper apiHelper;
  bool loading = false;
  bool submitWaiting = false;

  ReviewModel? ratingData;

  int vegetable = 0;
  int delivery = 0;
  int packaging = 0;
  int hygiene = 0;

  void getRatings() async {
    setState(() {
      loading = true;
    });
    ratingData = await apiHelper.getOrderRatings(orderId: widget.orderId);
    if(ratingData != null) {
      vegetable = ratingData!.vegetablesFruitsQuality;
      delivery = ratingData!.deliveryExperience;
      packaging = ratingData!.packagingQuality;
      hygiene = ratingData!.hygiene;
    }
    setState(() {
      loading = false;
    });
  }

  void submitRatings() async {
    try {
      setState(() {
        submitWaiting = true;
      });

      final bool success = await apiHelper.postOrderRating(
        orderId: widget.orderId,
        vegetable: vegetable,
        delivery: delivery,
        packaging: packaging,
        hygiene: hygiene,
      );

      success ? showToast("Review is submitted successfully") : null;

      setState(() {
        submitWaiting = false;
      });
    } catch(e, stacktrace) {
      showToast("Some error occurred");
      setState(() {
        submitWaiting = false;
      });
    }
  }

  @override
  void initState() {
    apiHelper = APIHelper();
    getRatings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: ColorConstants.getForegroundColor(context),
        ),
      ),
      body: loading
          ? Loader()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScreenHeader(title: AppLocalizations.of(context)!.subscribed),
                Divider(
                  color: ColorConstants.getForegroundColor(context)
                      .withOpacity(0.3),
                ),
                _buildRating(
                  AppLocalizations.of(context)!.rateVegetablesQuality,
                  rating: vegetable,
                  onRatingChanged: (value) {
                    setState(() {
                      vegetable = value;
                    });
                  },
                ),
                _buildRating(
                  AppLocalizations.of(context)!.rateDeliveryExperience,
                  rating: delivery,
                  onRatingChanged: (value) {
                    setState(() {
                      delivery = value;
                    });
                  },
                ),
                _buildRating(
                  AppLocalizations.of(context)!.ratePackagingQuality,
                  rating: packaging,
                  onRatingChanged: (value) {
                    setState(() {
                      packaging = value;
                    });
                  },
                ),
                _buildRating(
                  AppLocalizations.of(context)!.rateHygieneLevel,
                  rating: hygiene,
                  onRatingChanged: (value) {
                    setState(() {
                      hygiene = value;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10,
                  ),
                  child: InkWell(
                    onTap: submitRatings,
                    child: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                      ),
                      alignment: Alignment.center,
                      child: submitWaiting
                          ? Loader(color: Colors.white)
                          : Text(
                              AppLocalizations.of(context)!.submit,
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Widget _buildRating(
    String title, {
    required Function(int)? onRatingChanged,
    required int rating,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
        ),
        RateWidget(onRatingChanged: onRatingChanged, rating: rating),
        SizedBox(height: 20),
      ],
    );
  }
}

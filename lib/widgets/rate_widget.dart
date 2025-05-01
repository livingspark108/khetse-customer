import 'package:flutter/material.dart';
import 'package:user/constants/color_constants.dart';

class RateWidget extends StatefulWidget {
  final Function(int)? onRatingChanged;
  int rating;

  RateWidget({Key? key, this.onRatingChanged, this.rating = 0}) : super(key: key);

  @override
  State<RateWidget> createState() => _RateWidgetState();
}


class _RateWidgetState extends State<RateWidget> {
  void onRatingChangedInternal(int index) {
    setState(() {
      widget.rating = index;
    });
    if (widget.onRatingChanged != null) {
      widget.onRatingChanged!(index);
    }
  }

  Widget buildStar(int index, BuildContext context) {
    IconData iconData = index < widget.rating ? Icons.star : Icons.star_border;

    return GestureDetector(
        onTap: () => onRatingChangedInternal(index + 1),
      child: Icon(iconData, color: ColorConstants.getForegroundColor(context), size: 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) => buildStar(index, context)),
      ),
    );
  }
}

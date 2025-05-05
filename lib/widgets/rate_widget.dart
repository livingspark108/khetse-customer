import 'package:flutter/material.dart';
import 'package:user/constants/color_constants.dart';

class RateWidget extends StatefulWidget {
  final Function(int)? onRatingChanged;
  int rating;
  int size;
  bool editable;
  EdgeInsetsGeometry padding;

  RateWidget(
      {Key? key,
      this.onRatingChanged,
      this.rating = 0,
      this.size = 50,
      this.padding = const EdgeInsets.symmetric(horizontal: 20.0),
      this.editable = true})
      : super(key: key);

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
      onTap: widget.editable ? () => onRatingChangedInternal(index + 1) : null,
      child: Icon(iconData,
          color: ColorConstants.getForegroundColor(context),
          size: widget.size.toDouble()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) => buildStar(index, context)),
      ),
    );
  }
}

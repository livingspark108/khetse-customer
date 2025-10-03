import 'package:flutter/material.dart';

class BottomButton extends StatefulWidget {
  final Widget? child;
  final Function()? onPressed;
  @required
  final bool? loadingState;
  final bool? disabledState;
  final Key? key;

  BottomButton({this.child, this.loadingState, this.disabledState, this.onPressed, this.key}) : super();
  @override
  _BottomButtonState createState() => _BottomButtonState(child: child, onPressed: onPressed, loadingState: loadingState, disabledState: disabledState, key: key);
}

class _BottomButtonState extends State<BottomButton> {
  Widget? child;
  Function()? onPressed;
  bool? loadingState;
  bool? disabledState;
  var key;

  _BottomButtonState({this.child, this.loadingState, this.disabledState, this.onPressed, this.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25), // shadow color
              blurRadius: 12,  // how soft the shadow looks
              spreadRadius: 2, // how far it spreads
              offset: const Offset(0, 6), // x, y position of shadow
            ),
          ],
        ),
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Color(0Xff005832),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: !loadingState!
              ? child
              : const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          onPressed: loadingState! || disabledState! ? null : onPressed,
        ),
      ),
    );
  }



}

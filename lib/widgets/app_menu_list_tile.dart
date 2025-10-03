import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AppMenuListTile extends StatefulWidget {
  @required
  final Function? onPressed;
  @required
  final String? label;
  final String? leadingIconUrl;
  final IconData? icon;

  AppMenuListTile({this.label, this.leadingIconUrl, this.onPressed, this.icon}) : super();

  @override
  _AppMenuListTileState createState() => _AppMenuListTileState(label: label, leadingIconUrl: leadingIconUrl, onPressed: onPressed, icon: icon);
}

class _AppMenuListTileState extends State<AppMenuListTile> {
  Function? onPressed;
  String? label;
  String? leadingIconUrl;
  IconData? icon;

  _AppMenuListTileState({this.label, this.leadingIconUrl, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Colors.white),
      onPressed: () => onPressed!(),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon != null
                ? Icon(
                    icon,
                    size: 20,
                    color:Colors.green,
                  )
                : Image.asset(
                    leadingIconUrl!,
                    height: 20,
                    color: Colors.green,
                  ),
            SizedBox(width: 16),
            Text(
              label!,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.normal
              ),
            )
          ],
        ),
      ),
    );
  }
}

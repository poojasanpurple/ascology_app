import 'package:flutter/material.dart';
import 'package:ascology_app/global/configFile.dart' as cf;


class InfoCard extends StatelessWidget {
  // the values we need
  final String text;
  final IconData icon;
  Function onPressed;

  InfoCard(
      {@required this.text, @required this.icon, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    cf.Size.init(context);
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Colors.black26,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.white,
          ),
          title: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: cf.Size.blockSizeHorizontal * 3,
                fontFamily: "Poppins"),
          ),
        ),
      ),
    );
  }
}
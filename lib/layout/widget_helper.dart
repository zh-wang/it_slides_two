import 'package:flutter/material.dart';

const Color mainColor = const Color(0xFFFAC011);

class WidgetHelper {

  static Widget normalBtn(
      VoidCallback onPressed,
      String text, {
        Color textColor = Colors.black,
        Color bgColor = mainColor,
        double borderRadiusSize = -1,
        double fontSize = -1,
      }) {
    if (borderRadiusSize == -1) {
      borderRadiusSize = 24;
    }
    if (fontSize == -1) {
      fontSize = 20;
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.all(16.0)),
          backgroundColor: MaterialStateProperty.all(bgColor),
          foregroundColor: MaterialStateProperty.all(textColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadiusSize),
            ),
          ),
          minimumSize: MaterialStateProperty.all(const Size(160, 0)),
          elevation: MaterialStateProperty.all(1)),
      child: Text(
        text,
        maxLines: 1,
        textAlign: TextAlign.center,
        textScaleFactor: 1.0,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: fontSize,
        ),
      ),
    );
  }

  static Widget imgButton(
      VoidCallback onPressed,
      String imageName,
      Size size,
      ) {
    return GestureDetector(
        child: Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    image: AssetImage("images/cloth_light.png"),
                    fit:BoxFit.cover
                ),
            )
        ),
        onTap:() => onPressed()
    );
  }
}
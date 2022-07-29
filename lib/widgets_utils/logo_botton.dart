import 'package:flutter/material.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/main.dart';
import 'package:ubik/widgets_utils/view_image.dart';

Widget logoButton(){
  return SizedBox(
    width: sizeW,
    height: sizeH * 0.891,
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: sizeW,
        height: sizeH * 0.08,
        color: UbicaColors.white.withOpacity(0.8),
        child: Center(
          child: Container(
            width: sizeW * 0.25,
            height: sizeH * 0.065,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ViewImage().assetsImage('assets/image/logo_orange.png').image,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget logoButton2(){
  return Container(
    height: sizeH * 0.06,
    margin: EdgeInsets.only(top: sizeH * 0.01,bottom: sizeH * 0.01),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: ViewImage().assetsImage('assets/image/logo_orange.png').image,
        fit: BoxFit.contain,
      ),
    ),
  );
}
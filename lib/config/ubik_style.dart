import 'package:flutter/material.dart';
import 'package:ubik/config/ubik_colors.dart';

enum EnumStyle {
  primary,medium,semiBold,regular,light
}

class UbicaStyles {
  TextStyle stylePrimary({
    double size = 20,
    Color? color,
    FontWeight? fontWeight,
    EnumStyle enumStyle = EnumStyle.regular
  }) {
    TextStyle style = TextStyle(
        color: color ?? Colors.black,
        fontSize: size,
        fontWeight: fontWeight,
    );
    if(enumStyle == EnumStyle.medium){
      style = TextStyle(
          color: color ?? UbicaColors.black,
          fontFamily: 'Montserrat-Medium',
          fontSize: size,
          fontWeight: fontWeight ?? FontWeight.normal
      );
    }
    if(enumStyle == EnumStyle.regular){
      style = TextStyle(
          color: color ?? UbicaColors.black,
          fontFamily: 'Montserrat-Regular',
          fontSize: size,
          fontWeight: fontWeight ?? FontWeight.normal
      );
    }
    if(enumStyle == EnumStyle.semiBold){
      style = TextStyle(
          color: color ?? UbicaColors.black,
          fontFamily: 'Montserrat-SemiBold',
          fontSize: size,
      );
    }
    if(enumStyle == EnumStyle.light){
      style = TextStyle(
          color: color ?? UbicaColors.black,
          fontFamily: 'Montserrat-Light',
          fontSize: size,
          fontWeight: fontWeight ?? FontWeight.normal
      );
    }

    return style;
  }
}

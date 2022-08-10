import 'package:flutter/material.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/widgets_utils/view_image.dart';

AppBar appBarWidget({
  double sizeH = 10,
  void Function()? onTap,
  String title = '',
  Color colorIcon = Colors.white,
  TextStyle? styleTitle,
  TextAlign alignTitle = TextAlign.center,
  Color backgroundColor = UbicaColors.primary,
  double elevation = 5,
  IconData icon = Icons.arrow_back_ios,
  bool centerTitle = true,
  List<Widget> actions = const [],
  bool elevationActive = true,
  Widget? leadingW,
}){

  styleTitle = styleTitle ?? UbicaStyles().stylePrimary(size: sizeH * 0.023,color: Colors.white,fontWeight: FontWeight.bold);

  Widget leadingW2 = leadingW ?? InkWell(
    child: Icon(icon,size: sizeH * 0.03,color: colorIcon,),
    onTap: onTap,
  );

  return AppBar(
    backgroundColor: backgroundColor,
    elevation: elevation,
    leading: elevationActive ?  leadingW2 : Container(),
    centerTitle: centerTitle,
    title: Text(title,style: styleTitle,textAlign: alignTitle,),
    actions: actions,
  );
}

AppBar appBarIcon({
  double sizeH = 10,
  void Function()? onTap,
  String title = '',
  Color colorIcon = Colors.white,
  TextStyle? styleTitle,
  TextAlign alignTitle = TextAlign.center,
  Color backgroundColor = UbicaColors.primary,
  double elevation = 5,
  IconData icon = Icons.arrow_back_ios,
  bool centerTitle = false,
  List<Widget> actions = const [],
  bool elevationActive = true,
  Widget? leadingW,
  required BuildContext context,
}){

  styleTitle = styleTitle ?? UbicaStyles().stylePrimary(size: sizeH * 0.023,color: Colors.white,fontWeight: FontWeight.bold);

  return AppBar(
    backgroundColor: backgroundColor,
    elevation: elevation,
    leading: InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ViewImage().assetsImage('assets/image/icon_back_app-orange.png').image,
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
    centerTitle: centerTitle,
    title: Text(title,style: styleTitle,textAlign: alignTitle,),
    actions: actions,
  );
}
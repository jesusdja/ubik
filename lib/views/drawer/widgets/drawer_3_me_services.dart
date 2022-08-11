import 'package:flutter/material.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/widgets_utils/appbar_widgets.dart';
import 'package:ubik/widgets_utils/logo_botton.dart';

class DrawerMeServices extends StatefulWidget {
  const DrawerMeServices({Key? key}) : super(key: key);

  @override
  State<DrawerMeServices> createState() => _DrawerMeServicesState();
}

class _DrawerMeServicesState extends State<DrawerMeServices> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(sizeH * 0.07),
        child: appBar(),
      ),
      bottomNavigationBar: logoButton2(),
    );
  }

  Widget appBar(){
    return appBarIcon(
        backgroundColor: UbicaColors.white,
        styleTitle: UbicaStyles().stylePrimary(size: sizeH * 0.025, color: UbicaColors.primary,enumStyle: EnumStyle.regular),
        title: 'Mis servicios',
        elevation: 10.0,
        context: context
    );
  }
}

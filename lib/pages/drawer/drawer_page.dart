import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/initial_page.dart';
import 'package:ubik/main.dart';
import 'package:ubik/pages/drawer/widgets/drawer_1_about.dart';
import 'package:ubik/pages/drawer/widgets/drawer_2_update_profile.dart';
import 'package:ubik/providers/user_provider.dart';
import 'package:ubik/services/finish_app.dart';
import 'package:ubik/widgets_utils/appbar_widgets.dart';
import 'package:ubik/widgets_utils/circular_progress_colors.dart';
import 'package:ubik/widgets_utils/dialog_alert.dart';
import 'package:ubik/widgets_utils/view_image.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {

  late UserProvider userProvider;

  @override
  Widget build(BuildContext context) {

    userProvider = Provider.of<UserProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: UbicaColors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(sizeH * 0.07),
          child: appBar(),
        ),
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: sizeW,
                height: sizeH * 0.6,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ViewImage().assetsImage('assets/image/bg_mi_usuario.png').image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            userProvider.loadDataUser ? Center(child: circularProgressColors(colorCircular: UbicaColors.primary,widthContainer1: sizeW,widthContainer2: sizeW * 0.06)) :
            Align(
              alignment: Alignment.topCenter,
              child: _widgetsMenu(),
            )
          ],
        ),
      ),
    );
  }

  Widget _widgetsMenu(){

    String name = '';
    String correo = '';
    if(userProvider.userFirebase != null){
      name = userProvider.userFirebase!.displayName ?? '';
      correo = userProvider.userFirebase!.email ?? '';
    }

    Widget space = Divider(
      height: sizeH * 0.03,
      endIndent: sizeW * 0.03,
      indent: sizeW * 0.03,
      color: UbicaColors.colorBEBDBD,
      thickness: sizeH * 0.0008,
    );

    return Container(
      margin: EdgeInsets.only(top: sizeH * 0.02),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _rowButton(iconName:'icon_mis_datos_de_usuario.png',textTop: name,
              onTap: null,
              textBottom: correo),
          space,
          _rowButton(iconName: 'icon_acerca_de.png',textTop: 'Acerca de "Ubi-K"',onTap: (){
            showUbicaDialog(
              context: context,
              child: showMenuAbout(context: context),
            );
          }),
          space,
          _rowButton(iconName: 'icon_mi_cuenta.png',textTop: 'Mi Cuenta',onTap: () async {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context2) => const DrawerUpdateProfile()));
          }),
          space,
          _rowButton(iconName: 'icon_mis_servicios.png',textTop: 'Mis Servicios', onTap: (){
            //router.Router.navigator.pushNamed(router.Router.menuMeServices);
          }),
          space,
          _rowButton(iconName: 'icon_salir_app.png',textTop: 'Salir',onTap: () async {
            // AuthBloc(AuthRepository()).add(AuthEvent.signedOut());
            // router.Router.navigator.pushReplacementNamed(router.Router.login);

            bool? res = await alertClosetSession(context);
            if(res != null && res){
              await finishApp();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context2) => const InitialPage()));
            }
          }),
          space,
        ],
      ),
    );
  }

  Widget _rowButton({required String iconName, required String textTop, required Function()? onTap, String textBottom = ''}){
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: sizeW,
        child: Row(
          children: <Widget>[
            Container(
              width: sizeW * 0.07,
              height: sizeW * 0.07,
              margin: EdgeInsets.only(left: sizeW * 0.04, right: sizeW * 0.04),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ViewImage().assetsImage('assets/image/$iconName').image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(textTop,style: UbicaStyles().stylePrimary(size: sizeH * 0.02,enumStyle: EnumStyle.semiBold),),
                  textBottom.isEmpty ? Container() : Text(textBottom, style: UbicaStyles().stylePrimary(size: sizeH * 0.017,fontWeight: FontWeight.bold,enumStyle: EnumStyle.light),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget appBar(){
    return appBarIcon(
        backgroundColor: UbicaColors.white,
        styleTitle: UbicaStyles().stylePrimary(size: sizeH * 0.025, color: UbicaColors.primary,enumStyle: EnumStyle.regular),
        title: 'Usuario',
        elevation: 10.0,
        context: context
    );
  }
}

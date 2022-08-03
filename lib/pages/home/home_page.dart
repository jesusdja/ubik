import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/pages/afiliate/affiliate_page.dart';
import 'package:ubik/pages/drawer/drawer_page.dart';
import 'package:ubik/providers/affiliate_user_provider.dart';
import 'package:ubik/providers/home_provider.dart';
import 'package:ubik/widgets_utils/view_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late HomeProvider homeProvider;

  @override
  Widget build(BuildContext context) {

    homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: UbicaColors.primary,
      endDrawer: const DrawerPage(),
      body: Stack(
        children: [
          topContainer(),
          homeProvider.isPageAffiliate ?
          const AffiliatePage() : _pageHome(),
          Align(
            alignment: Alignment.bottomCenter,
            child: bottomNavigationBar(),
          )
        ],
      ),
    );
  }

  Widget _pageHome(){
    return Container(
      margin: EdgeInsets.only(top: sizeH * 0.2),
      height: sizeH,
      width: sizeW,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(35.0),topRight: Radius.circular(35.0),),
        image: DecorationImage(
          image: ViewImage().assetsImage('assets/image/mapHome.png').image,
          fit: BoxFit.fill,
        ),
        color: UbicaColors.white,
        border: Border.all(
          color: UbicaColors.white,
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: sizeH * 0.03,),
            Container(
              height: sizeH * 0.1,
              width: sizeW * 0.8,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(35.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Comencemos',style: UbicaStyles().stylePrimary(size:sizeH * 0.022,enumStyle: EnumStyle.regular),),
                  Text('¿Qué necesitas?',style: UbicaStyles().stylePrimary(size:sizeH * 0.028,enumStyle: EnumStyle.semiBold),),
                ],
              ),
            ),
            SizedBox(height: sizeH * 0.05,),
            _containerServices(1),
            SizedBox(height: sizeH * 0.02,),
            _containerServices(2)
          ],
        ),
      ),
    );
  }

  Widget _containerServices(int type){
    String title = 'Servicios';
    Image imageCardBack = ViewImage().assetsImage('assets/image/Imagen-home-services.png');
    if(type == 1){}
    if(type == 2){
      title = 'Comercios';
      imageCardBack = ViewImage().assetsImage('assets/image/Imagen-comercios.png');
    }
    if(type == 3){
      title = 'Emprendedores';
      imageCardBack = ViewImage().assetsImage('assets/image/homescreen_bg_emprendedores.png');
    }

    double h = sizeH * 0.22;

    return InkWell(
      onTap: (){},// => router.Router.navigator.pushNamed(router.Router.servicesPage,arguments: type),
      child: SizedBox(
        height: h,
        width: sizeW,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: sizeH * 0.014, top: sizeH * 0.005) ,
              width: sizeW * 0.4,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  bottomLeft: Radius.circular(35.0),
                ),
                color: Colors.white,
                image: DecorationImage(
                  image: imageCardBack.image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: sizeH * 0.014, top: sizeH * 0.005),
              width: sizeW * 0.45,
              height: h,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(35.0),
                  bottomRight: Radius.circular(35.0),
                ),
                gradient: LinearGradient(
                    colors: [UbicaColors.colorFBB104,UbicaColors.primary],
                    stops: [0.0, 0.9],
                    begin: FractionalOffset.centerRight,
                    end: FractionalOffset.centerLeft
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left: sizeW * 0.03),
                  child: Text(title, style: UbicaStyles().stylePrimary(size:sizeH * 0.03, color: UbicaColors.white,enumStyle: EnumStyle.semiBold),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topContainer(){
    return Container(
      height: sizeH * 0.25,
      width: sizeW,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ViewImage().assetsImage('assets/image/home_top.png').image,
          fit: BoxFit.fitWidth,
        ),
      ),
      child: SizedBox(
        width: sizeW,
        child: Column(
          children: [
            SizedBox(height: sizeH * 0.035,),
            SizedBox(
              width: sizeW,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('BIENVENIDOS A ', style: UbicaStyles().stylePrimary(size:sizeH * 0.025, color: UbicaColors.white,enumStyle: EnumStyle.semiBold),),
                  Container(
                    height: sizeH * 0.06,
                    width: sizeW * 0.22,
                    margin: EdgeInsets.only(bottom: sizeH * 0.023, left: sizeW * 0.01),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: ViewImage().assetsImage('assets/image/logo_homescreen.png').image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: sizeW,
              child: Text('¡ Encuentra lo que necesites\nal alcance de tus manos !',
                style: UbicaStyles().stylePrimary(size:sizeH * 0.02, color: UbicaColors.white, fontWeight: FontWeight.bold,enumStyle: EnumStyle.regular),
                textAlign: TextAlign.center,),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomNavigationBar(){
    return Container(
      height: sizeH * 0.08,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35.0),
          topRight: Radius.circular(35.0),
        ),
        color: UbicaColors.white,
        border: Border.all(
          color: UbicaColors.white,
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          onTapContainer(url: homeProvider.isPageAffiliate ? 'cart-orange.png' : 'iconshopping.png', title: 'Afíliate', select: homeProvider.isPageAffiliate,
            onTap: (){
              if(!homeProvider.isPageAffiliate){
                final affiliateUserProvider = Provider.of<AffiliateUserProvider>(context, listen: false);
                affiliateUserProvider.dataInitial();
                homeProvider.changePageAffiliate(value: true);
              }
            },
          ),
          onTapContainer(url: homeProvider.isPageAffiliate ? 'u-grey.png' : 'iconHome.png', title: 'Inicio', select: !homeProvider.isPageAffiliate,
            onTap: (){
              homeProvider.changePageAffiliate(value: false);
            }
          ),
          onTapContainer(url: 'iconperson.png', title: 'Usuario', select: false,
            onTap: (){
              _scaffoldKey.currentState!.openEndDrawer();
            },
          ),
        ],
      ),
    );
  }

  Widget onTapContainer({required String url, required String title, required bool select, required Function() onTap}){
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: select ? sizeH * 0.038 : sizeH * 0.028,
                width: sizeW * 0.05,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ViewImage().assetsImage('assets/image/$url').image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Text(title, style: UbicaStyles().stylePrimary(
                  size: sizeH * 0.017,
                  color: select ? UbicaColors.primary : UbicaColors.color535353
              ),)
            ],
          ),
        ),
      ),
    );
  }
}

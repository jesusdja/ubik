import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/providers/home_provider.dart';
import 'package:ubik/widgets_utils/view_image.dart';

class AffiliatePage extends StatefulWidget {
  const AffiliatePage({Key? key}) : super(key: key);

  @override
  State<AffiliatePage> createState() => _AffiliatePageState();
}

class _AffiliatePageState extends State<AffiliatePage> {

  bool isLoad = false;
  bool isCheck = false;
  int face = 0;
  late HomeProvider homeProvider;

  @override
  Widget build(BuildContext context) {

    homeProvider = Provider.of<HomeProvider>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: UbicaColors.white,
        body: Stack(
          children: [
            topContainer(),
            Container(
              margin: EdgeInsets.only(top: sizeH * 0.18),
              child: _pageHome(),
            ),
          ],
        ),
      ),
    );
  }

  Widget topContainer(){
    return Container(
      height: sizeH * 0.44,
      width: sizeW,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ViewImage().assetsImage('assets/image/home_top.png').image,
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: sizeW,
            margin: EdgeInsets.only(top: sizeH * 0.025),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    if(face == 0 || face == 3){
                      homeProvider.changePageAffiliate(value: false);
                    }else{
                      face--;
                      setState(() {});
                    }
                  },
                  child: Container(
                    height: sizeH * 0.06,
                    width: sizeH * 0.06,
                    margin: EdgeInsets.all(sizeH * 0.01),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ViewImage().assetsImage('assets/image/icon_back_homescreen.png').image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: sizeW * 0.15),
                    child: Text('AFILIATE',style: UbicaStyles().stylePrimary(size: sizeH * 0.025, color: UbicaColors.white,fontWeight: FontWeight.bold,enumStyle: EnumStyle.medium),textAlign: TextAlign.center,),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: sizeW,
            margin: EdgeInsets.only(left: sizeW * 0.05),
            child: Text('Ingresa cuidadosamente tus',style: UbicaStyles().stylePrimary(size: sizeH * 0.018, color: UbicaColors.white,enumStyle: EnumStyle.medium),textAlign: TextAlign.left,),
          ),
          Container(
            width: sizeW,
            margin: EdgeInsets.only(left: sizeW * 0.05),
            child: Text('Datos comerciales',style: UbicaStyles().stylePrimary(size: sizeH * 0.025, color: UbicaColors.white,fontWeight: FontWeight.bold, enumStyle: EnumStyle.medium),textAlign: TextAlign.left,),
          )
        ],
      ),
    );
  }

  Widget _pageHome(){
    return Container(
      height: sizeH,
      width: sizeW,
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
      child: isLoad ?
      Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: sizeH * 0.01,),
            Text(face == 2 ? 'Afiliando usuario' : 'Verificando usuario',style: UbicaStyles().stylePrimary(size:sizeH * 0.025,enumStyle: EnumStyle.semiBold)),
            SizedBox(height: sizeH * 0.5,)
          ],
        ),
      ) :
      isCheck ? Container() : affiliateUser(),
    );
  }

  Widget affiliateUser(){
    Widget element = Container();

    if(face == 0){
      // element = DataUserAffiliate(
      //   photos: state.photos,
      //   name: state.name,
      //   prePhone: state.prefPhone,
      //   phone: state.phone,
      // );
    }
    if(face == 1){
      //element = DialogShowMap();
    }
    if(face == 2 || face == 3){
      //element = SendData();
    }

    return Container(
      width: sizeW,
      margin: EdgeInsets.symmetric(horizontal: sizeW * 0.05),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: sizeH * 0.05,),
            SizedBox(
              width: sizeW,
              child: element,
            ),
          ],
        ),
      ),
    );
  }

  void alertFinish(BuildContext context){
    Size size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ( context ) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              content: SizedBox(
                width: size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('¡GRACIAS!', style: UbicaStyles().stylePrimary(size: size.height * 0.04, color: UbicaColors.primary,fontWeight: FontWeight.bold,enumStyle: EnumStyle.medium),),
                    SizedBox(height: size.height * 0.025,),
                    Text('Tu proceso de afiliación ha sido exitoso. En breve un ejecutivo se comunicará contigo',
                    style: UbicaStyles().stylePrimary(size: size.height * 0.02, enumStyle: EnumStyle.medium),textAlign: TextAlign.center,),
                  ],
                ),
              ),
              actions: <Widget>[
                InkWell(
                  child: Container(
                    width: size.width,
                    height: size.height * 0.05,
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.2,vertical: size.height * 0.015),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: UbicaColors.primary,
                      border: Border.all(
                        color: UbicaColors.primary,
                        width: 1.5,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: Text('ACEPTAR',style: UbicaStyles().stylePrimary(size: size.height * 0.018, color: UbicaColors.white, enumStyle: EnumStyle.medium)),
                    ),
                  ),
                  onTap: (){
                    homeProvider.changePageAffiliate(value: false);
                  },
                )
              ],
            ),
          );
        }
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/views/drawer/widgets/drawer_4_policies_privacy.dart';
import 'package:ubik/views/drawer/widgets/drawer_5_terms_conditions.dart';
import 'package:ubik/widgets_utils/logo_botton.dart';
import 'package:ubik/widgets_utils/view_image.dart';


Widget showMenuAbout({required BuildContext context}) {

  Widget space = Divider(height: sizeH * 0.025,color: UbicaColors.colorBEBDBD,);

  return SizedBox(
    width: sizeW, height: sizeH,
    child: Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            width: sizeW,
            height: sizeH * 0.35,
            child: Scaffold(
              bottomNavigationBar: logoButton2(),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: sizeW,
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: sizeH * 0.05,
                            height: sizeH * 0.05,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: ViewImage().assetsImage('assets/image/icon_close_app_orange.png').image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: sizeW,
                            margin: EdgeInsets.all(sizeH * 0.015),
                            child: Text(
                              'Acerca de “Ubica”',
                              style: UbicaStyles().stylePrimary(size: sizeW * 0.045,  color: UbicaColors.black,fontWeight: FontWeight.bold,enumStyle: EnumStyle.light),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  space,
                  Container(
                    width: sizeW,
                    margin: EdgeInsets.only(left: sizeW * 0.02),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: sizeH * 0.035,
                            height: sizeH * 0.035,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: ViewImage().assetsImage('assets/image/icon_salir_app.png').image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context2) => const PoliciesPrivacy()));
                            },
                            child: Container(
                              width: sizeW,
                              margin: EdgeInsets.all(sizeH * 0.015),
                              child: Text(
                                'Políticas de privacidad',
                                style: UbicaStyles().stylePrimary(size: sizeW * 0.035,  color: UbicaColors.black,enumStyle: EnumStyle.semiBold),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  space,
                  Container(
                    width: sizeW,
                    margin: EdgeInsets.only(left: sizeW * 0.02),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: sizeH * 0.035,
                            height: sizeH * 0.035,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: ViewImage().assetsImage('assets/image/icon_terminos_condiciones.png').image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context2) => const TermsConditions()));
                            },
                            child: Container(
                              width: sizeW,
                              margin: EdgeInsets.all(sizeH * 0.015),
                              child: Text(
                                'Términos y condiciones',
                                style: UbicaStyles().stylePrimary(size: sizeW * 0.035,  color: UbicaColors.black,enumStyle: EnumStyle.semiBold),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  space,
                ],
              ),
            ),
          ),
        )
      ],
    ),
  );
}
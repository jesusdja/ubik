import 'package:flutter/material.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/services/authenticate_firebase.dart';
import 'package:ubik/widgets_utils/button_general.dart';
import 'package:ubik/widgets_utils/circular_progress_colors.dart';
import 'package:ubik/widgets_utils/textfield_general.dart';
import 'package:ubik/widgets_utils/toast_widget.dart';
import 'package:ubik/widgets_utils/view_image.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key, required this.emailLogin}) : super(key: key);
  final String emailLogin;
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerCode = TextEditingController();

  bool loadLogin = false;
  bool sendEmailCode = false;

  @override
  void initState() {
    super.initState();
    controllerEmail.text = widget.emailLogin;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: UbicaColors.white,
        body: SizedBox(
          height: sizeH,
          width: sizeW,
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: _headerRegister(),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: _buttonReturn(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _bottonRegister(),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(left: sizeW * 0.1,right: sizeW * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if(sendEmailCode)...[
                        Text(
                          'Correo enviado',
                          style: UbicaStyles().stylePrimary(size:sizeH * 0.030,  color: UbicaColors.primary,enumStyle: EnumStyle.medium),
                        ),
                        SizedBox(height: sizeH * 0.01),
                        Text(
                          'Te hemos enviado un correo electronico para que puedas restablecer tu contraseña,si no encuentras el correo puedes revisar la carpeta de "correo no deseado" o "Spam."',
                          style: UbicaStyles().stylePrimary(size:sizeH * 0.018,enumStyle: EnumStyle.regular),
                        ),
                        SizedBox(height: sizeH * 0.05),
                        Padding(
                          padding: EdgeInsets.only(
                              right: sizeW * 0.05,
                              left: sizeW * 0.05),
                          child: ButtonGeneral(
                            title: 'Continuar',
                            onPressed: () => Navigator.of(context).pop(),
                            backgroundColor: UbicaColors.primary,
                            borderColor: UbicaColors.primary,
                            textStyle: UbicaStyles().stylePrimary(size:sizeH * 0.017,color: UbicaColors.white,enumStyle: EnumStyle.semiBold),
                            height: sizeH * 0.05,
                          ),
                        ),
                      ]else...[
                        Text(
                          'Recuperar Contraseña',
                          style: UbicaStyles().stylePrimary(size:sizeH * 0.030,  color: UbicaColors.primary,enumStyle: EnumStyle.medium),
                        ),
                        SizedBox(height: sizeH * 0.01),
                        Text(
                          'Para recuperar tu contraseña solo proporciona el E-mail con el que te registraste, en un par de minutos recibirás en correo con tu contraseña.',
                          style: UbicaStyles().stylePrimary(size:sizeH * 0.018,enumStyle: EnumStyle.regular),
                        ),
                        SizedBox(height: sizeH * 0.05,),
                        Padding(
                          padding: EdgeInsets.only(
                              left: sizeW * 0.05, right: sizeW * 0.05),
                          child: TextFieldGeneral(
                            textEditingController: controllerEmail,
                            textInputType: TextInputType.emailAddress,
                            sizeHeight: sizeH * 0.05,
                            hintText: 'E-mail',
                            labelStyle: UbicaStyles().stylePrimary(color: UbicaColors.black,size: sizeH * 0.02),
                          ),
                        ),
                        SizedBox(height: sizeH * 0.015,),
                        loadLogin ? Center(child: circularProgressColors(colorCircular: UbicaColors.primary,widthContainer1: sizeW,widthContainer2: sizeW * 0.06))
                            :
                        Padding(
                          padding: EdgeInsets.only(
                              right: sizeW * 0.05,
                              left: sizeW * 0.05),
                          child: ButtonGeneral(
                            title: 'ENVIAR CORREO',
                            onPressed: () => sendEmail(),
                            backgroundColor: UbicaColors.primary,
                            borderColor: UbicaColors.primary,
                            textStyle: UbicaStyles().stylePrimary(size:sizeH * 0.017,color: UbicaColors.white,enumStyle: EnumStyle.semiBold),
                            height: sizeH * 0.05,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonReturn() {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        height: sizeH * 0.07,
        width: sizeH * 0.07,
        margin: EdgeInsets.only(left: sizeW * 0.005, top: sizeH * 0.05),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ViewImage()
                .assetsImage('assets/image/icon_back_homescreen.png')
                .image,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget _headerRegister() {
    return Stack(
      children: <Widget>[
        Container(
          height: sizeH * 0.35,
          width: sizeW,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ViewImage()
                  .assetsImage('assets/image/bg_top_registro.png')
                  .image,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(
          height: sizeH * 0.22,
          width: sizeW,
          child: Center(
            child: Container(
              height: sizeH * 0.12,
              width: sizeW * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ViewImage().assetsImage("assets/image/logo_homescreen.png").image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottonRegister() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: sizeH * 0.45,
          width: sizeW,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ViewImage()
                  .assetsImage('assets/image/bg_bottom_registro.png')
                  .image,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }

  Future sendEmail() async{
    loadLogin = true;
    setState(() {});

    FocusScope.of(context).requestFocus(FocusNode());

    String errorText = '';
    if(errorText.isEmpty && controllerEmail.text.isEmpty){
      errorText = 'Correo no puede estar vacio';
    }

    if(errorText.isEmpty){
      try{
        Map<String,dynamic> data = await AuthenticateFirebaseUser().sendPasswordResetEmailFirebase(email: controllerEmail.text);
        if(!data.containsKey('error')){
          showAlert(text: 'Enviado');
          sendEmailCode = true;
          setState(() {});
        }else{
          String error = data.containsKey('error') ? data['error'] : 'Problmas de conexión con el servidor';
          showAlert(text: error,isError: true);
        }
      }catch(e){
        showAlert(text: 'Error: ${e.toString()}',isError: true);
      }
    }else{
      showAlert(text: errorText,isError: true);
    }
    loadLogin = false;
    setState(() {});
  }
}

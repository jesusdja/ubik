import 'package:flutter/material.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/pages/register/register_page.dart';
import 'package:ubik/widgets_utils/button_general.dart';
import 'package:ubik/widgets_utils/textfield_general.dart';
import 'package:ubik/widgets_utils/view_image.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UbicaColors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: sizeH * 0.3,
                width: sizeW,
                child: _header(),
              ),
              SizedBox(
                height: sizeH * 0.3,
                width: sizeW,
                child: _signForm(),
              ),
              SizedBox(
                height: sizeH * 0.4,
                width: sizeW,
                child: _containerBottom(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Stack(
      children: <Widget>[
        Container(
          height: sizeH * 0.3,
          width: sizeW,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ViewImage()
                  .assetsImage("assets/image/bg_top_inicio_sesion.png")
                  .image,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(
          height: sizeH * 0.3,
          width: sizeW,
          margin: EdgeInsets.only(bottom: sizeH * 0.08),
          child: Center(
            child: Container(
              height: sizeH * 0.12,
              width: sizeW * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ViewImage()
                      .assetsImage("assets/image/logo_homescreen.png")
                      .image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _containerBottom() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: sizeH * 0.4,
          width: sizeW,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ViewImage()
                  .assetsImage("assets/image/bg_bottom_inicio_sesion.png")
                  .image,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: sizeH * 0.07),
          child: Container(
            height: sizeH * 0.3,
            width: sizeW * 0.8,
            margin: EdgeInsets.only(left: sizeW * 0.15, right: sizeW * 0.15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '¿No tienes cuenta?',
                  style: UbicaStyles().stylePrimary(size:sizeH * 0.023, color: UbicaColors.white,enumStyle: EnumStyle.semiBold),
                ),
                SizedBox(
                  height: sizeH * 0.03,
                ),
                ButtonGeneral(
                  title: 'Registrarme',
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context2) => const RegisterPage()));
                  },
                  backgroundColor: UbicaColors.white,
                  textStyle: UbicaStyles().stylePrimary(size: sizeH * 0.018,enumStyle: EnumStyle.regular),
                  height: sizeH * 0.05,
                  width: sizeW * 0.5,
                ),
                SizedBox(
                  height: sizeH * 0.05,
                ),
                ButtonGeneral(
                  width: sizeW * 0.5,
                  title: 'Olvidé mi contraseña',
                  backgroundColor: UbicaColors.white.withOpacity(0.2),
                  onPressed: (){
                    //router.Router.navigator.pushNamed(router.Router.forgetPassword)
                  },
                  textStyle: UbicaStyles().stylePrimary(size: sizeH * 0.018,enumStyle: EnumStyle.regular),
                  height: sizeH * 0.05,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _signForm() {
    return Container(
      height: sizeH * 0.267,
      width: sizeW,
      margin: EdgeInsets.only(left: sizeW * 0.15, right: sizeW * 0.15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Iniciar Sesión',
            style: UbicaStyles().stylePrimary(size: sizeH * 0.023, color: UbicaColors.primary,enumStyle: EnumStyle.semiBold),
          ),
          SizedBox( height: sizeH * 0.03),
          TextFieldGeneral(
            sizeHeight: sizeH * 0.05,
            hintText: 'Correo',
            labelStyle: UbicaStyles().stylePrimary(color: UbicaColors.black, size: sizeH * 0.018),
            textInputType: TextInputType.emailAddress,
            onChanged: (email){
              //context.bloc<LoginBloc>()..add(LoginEvent.emailChanged(email))
            },
          ),
          SizedBox(
            height: sizeH * 0.022,
          ),
          TextFieldGeneral(
            sizeHeight: sizeH * 0.05,
            hintText: 'Contraseña',
            labelStyle: UbicaStyles().stylePrimary(color: UbicaColors.black, size: sizeH * 0.018),
            obscure: true,
            textInputType: TextInputType.visiblePassword,
            onChanged: (pass){
              //context.bloc<LoginBloc>()..add(LoginEvent.passwordChanged(pass))
            },
          ),
          SizedBox(
            height: sizeH * 0.022,
          ),
          // state.isSubmitting
          //     ? Center(
          //         child: Container(
          //           width: sizeH * 0.05,
          //           height: sizeH * 0.05,
          //           child: CircularProgressIndicator(
          //             backgroundColor: UbicaColors.primary,
          //           ),
          //         ),
          //       )
          //     :
          ButtonGeneral(
            title: 'Entrar',
            onPressed: (){
              // FocusScope.of(context).requestFocus(new FocusNode());
              // context.bloc<LoginBloc>()..add(LoginEvent.loginWithCredentialsPressed());
            },
            backgroundColor: UbicaColors.primary,
            borderColor: UbicaColors.primary,
            textStyle: UbicaStyles().stylePrimary(size: sizeH * 0.018, color: UbicaColors.white,enumStyle: EnumStyle.semiBold),
            height: sizeH * 0.05,
            width: sizeW * 0.8,
          ),
        ],
      ),
    );
  }
}

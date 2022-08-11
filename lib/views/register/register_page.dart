import 'package:flutter/material.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/main.dart';
import 'package:ubik/views/register/widget/register_form.dart';
import 'package:ubik/widgets_utils/view_image.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UbicaColors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: SizedBox(
            height: sizeH,
            width: sizeW,
            child: Stack(
              fit: StackFit.loose,
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: _headerRegister(sizeH, sizeW),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: _buttonReturn(sizeH, sizeW),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _bottomRegister(context, sizeH, sizeW),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: sizeH * 0.25),
                    child: const RegisterForm(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonReturn(double sizeH, double sizeW) {
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

  Widget _headerRegister(double sizeH, double sizeW) {
    return Stack(
      children: <Widget>[
        Container(
          height: sizeH * 0.32,
          width: sizeW,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ViewImage().assetsImage('assets/image/bg_top_registro.png').image,
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

  Widget _bottomRegister(BuildContext context, double sizeH, double sizeW) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: sizeH * 0.45,
          width: sizeW,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ViewImage().assetsImage('assets/image/bg_bottom_registro.png').image,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}

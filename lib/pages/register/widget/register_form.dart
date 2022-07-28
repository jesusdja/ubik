import 'package:flutter/material.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/config/value_validators.dart';
import 'package:ubik/main.dart';
import 'package:ubik/services/authenticate_firebase.dart';
import 'package:ubik/widgets_utils/button_general.dart';
import 'package:ubik/widgets_utils/circular_progress_colors.dart';
import 'package:ubik/widgets_utils/textfield_general.dart';
import 'package:ubik/widgets_utils/toast_widget.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  FocusNode focusNodeUser = FocusNode();
  FocusNode focusNodeName = FocusNode();
  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodePass = FocusNode();
  FocusNode focusNodePass2 = FocusNode();
  bool showError = false;
  bool isLoad = false;

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmailAddress = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerPassword2 = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    focusNodeUser.dispose();
    focusNodeName.dispose();
    focusNodeEmail.dispose();
    focusNodePass.dispose();
    focusNodePass2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget space = SizedBox(height: sizeH * 0.02,);
    return Container(
      width: sizeW,
      margin: EdgeInsets.only(left: sizeW * 0.1, right: sizeW * 0.1),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: sizeW,
              child: Text('Registro',textAlign: TextAlign.center,
                style: UbicaStyles().stylePrimary(size: sizeH * 0.03, color: UbicaColors.primary,enumStyle: EnumStyle.medium),),
            ),
            SizedBox(height: sizeH * 0.03,),
            SizedBox(
              width: sizeW,
              child: TextFieldGeneral(
                textEditingController: controllerName,
                focusNode: focusNodeName,
                sizeHeight: sizeH * 0.05,
                hintText: 'Nombre y apellido',
                labelStyle: TextStyle(color: UbicaColors.black, fontSize: sizeH * 0.02),
              ),
            ),
            controllerName.text.isEmpty && showError ? _error('Nombre y apellido requerido.') : Container(),
            space,
            SizedBox(
              width: sizeW,
              child: TextFieldGeneral(
                focusNode: focusNodeEmail,
                textEditingController: controllerEmailAddress,
                sizeHeight: sizeH * 0.05,
                hintText: 'Correo',
                labelStyle: TextStyle(color: UbicaColors.black, fontSize: sizeH * 0.02),
                textInputType: TextInputType.emailAddress,
              ),
            ),
            showError && !validateEmailAddress(email: controllerEmailAddress.text)['valid'] ? _error(validateEmailAddress(email: controllerEmailAddress.text)['sms']) : Container(),
            space,
            SizedBox(
              width: sizeW,
              child: TextFieldGeneral(
                focusNode: focusNodePass,
                textEditingController: controllerPassword,
                sizeHeight: sizeH * 0.05,
                hintText: 'Contraseña',
                labelStyle: TextStyle(color: UbicaColors.black, fontSize: sizeH * 0.02),
                obscure: true,
                textInputType: TextInputType.visiblePassword,
              ),
            ),
            showError && !validatePassword(input: controllerPassword.text)['valid'] ? _error(validatePassword(input: controllerPassword.text)['sms']) : Container(),
            space,
            SizedBox(
              width: sizeW,
              child: TextFieldGeneral(
                focusNode: focusNodePass2,
                textEditingController: controllerPassword2,
                sizeHeight: sizeH * 0.05,
                hintText: 'Confirmar contraseña',
                labelStyle: TextStyle(color: UbicaColors.black, fontSize: sizeH * 0.02),
                obscure: true,
                textInputType: TextInputType.visiblePassword,
              ),
            ),
            showError && controllerPassword.text != controllerPassword2.text ? _error('Las contraseñas deben ser iguales.') : Container(),
            space,space,space,space,
            isLoad ?
            Center(child: circularProgressColors(colorCircular: UbicaColors.primary,widthContainer1: sizeW,widthContainer2: sizeW * 0.08))
                :
            SizedBox(
              width: sizeW,
              child: ButtonGeneral(
                title: 'REGISTRARSE',
                backgroundColor: UbicaColors.primary,
                borderColor: UbicaColors.primary,
                textStyle: UbicaStyles().stylePrimary(size: sizeH * 0.017, color: UbicaColors.white,enumStyle: EnumStyle.semiBold),
                height: sizeH * 0.06,
                onPressed: () => saveUser(),
              ),
            ),
            space,
          ],
        ),
      ),
    );
  }

  Future saveUser() async{

    isLoad = true;
    setState(() {});

    FocusScope.of(context).requestFocus(FocusNode());
    showError = validateForm();

    if(!showError){
      try{
        Map<String,dynamic> data = await AuthenticateFirebaseUser().registerFirebase(
            email: controllerEmailAddress.text, password: controllerPassword.text,alias: controllerName.text);
        if(data.containsKey('user')){
          showAlert(text: 'Bienvenido');
          Navigator.of(context).pop(true);
        }else{
          String error = data.containsKey('error') ? data['error'] : 'Problemas de conexión con el servidor';
          showAlert(text: error,isError: true);
        }

      }catch(e){
        showError = true;
        showAlert(text: 'Error de conexión con el servidor',isError: true);
      }
    }

    isLoad = false;
    setState(() {});
  }

  bool validateForm(){
    Map<String, FocusNode> mapError = {};
    bool error = false;

    if (controllerName.text.isEmpty && mapError.isEmpty) {
      mapError['error'] = focusNodeName;
    }
    if (!validateEmailAddress(email: controllerEmailAddress.text)['valid'] && mapError.isEmpty) {
      mapError['error'] = focusNodeEmail;
    }
    if (!validatePassword(input: controllerPassword.text)['valid'] && mapError.isEmpty) {
      mapError['error'] = focusNodePass;
    }
    if (controllerPassword.text != controllerPassword2.text && mapError.isEmpty) {
      mapError['error'] = focusNodePass2;
    }
    if (mapError.isNotEmpty) {
      mapError['error']!.requestFocus();
      mapError.remove('error');
      error = true;
    }
    return error;
  }

  Widget _error(String text) {
    return SizedBox(
      width: sizeW,
      child: Text(text,
        textAlign: TextAlign.left,
        style: UbicaStyles().stylePrimary(
            size:sizeH * 0.015,
            color: UbicaColors.colorError,
            enumStyle: EnumStyle.medium
        ),
      ),
    );
  }
}

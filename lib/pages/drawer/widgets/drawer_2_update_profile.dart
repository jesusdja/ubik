import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/providers/user_provider.dart';
import 'package:ubik/services/authenticate_firebase.dart';
import 'package:ubik/widgets_utils/appbar_widgets.dart';
import 'package:ubik/widgets_utils/button_general.dart';
import 'package:ubik/widgets_utils/circular_progress_colors.dart';
import 'package:ubik/widgets_utils/textfield_general.dart';
import 'package:ubik/widgets_utils/toast_widget.dart';
import 'package:ubik/widgets_utils/view_image.dart';

class DrawerUpdateProfile extends StatefulWidget {
  const DrawerUpdateProfile({Key? key}) : super(key: key);

  @override
  State<DrawerUpdateProfile> createState() => _DrawerUpdateProfileState();
}

class _DrawerUpdateProfileState extends State<DrawerUpdateProfile> {

  late UserProvider userProvider;
  bool load = false;
  bool loadDataInitial = true;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPass = TextEditingController(text: '12345678');
  TextEditingController controllerPass2 = TextEditingController(text: '12345678');
  bool editPass = false;
  bool editPass2 = false;
  bool editName = false;

  @override
  void initState() {
    super.initState();
    initialData();
  }

  Future initialData() async{
    await Future.delayed(const Duration(seconds: 1));

    if(userProvider.userFirebase != null){
      controllerName.text = userProvider.userFirebase!.displayName ?? '';
      loadDataInitial = false;
      setState(() {});
    }else{
      initialData();
    }
  }

  @override
  Widget build(BuildContext context) {

    userProvider = Provider.of<UserProvider>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(sizeH * 0.07),
            child: appBar(),
          ),
          body: Container(
            height: sizeH,
            width: sizeW,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ViewImage().assetsImage('assets/image/bg_mi_cuenta.png').image,
                fit: BoxFit.fill,
              ),
            ),
            child:
            loadDataInitial ? Center(child: circularProgressColors(colorCircular: UbicaColors.primary,widthContainer1: sizeW,widthContainer2: sizeW * 0.06)) :
            form(),
          ),
        ),
      ),
    );
  }

  Widget form(){

    Widget lockedTextField = Container(
      height: sizeH * 0.01,width: sizeH * 0.01,
      margin: EdgeInsets.only(right: sizeW * 0.03),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ViewImage().assetsImage('assets/image/input_locked_app.png').image,
          fit: BoxFit.fitHeight,
        ),
      ),
    );

    BoxConstraints boxIcon = BoxConstraints.expand(width: sizeW * 0.065, height: sizeH * 0.022);

    return Container(
      margin: EdgeInsets.only(left: sizeW * 0.14, right: sizeW * 0.14),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: sizeH * 0.05,),
            textTitle('Datos personales', sizeH),
            SizedBox(height: sizeH * 0.03,),
            SizedBox(
              width: sizeW,
              child: TextFieldGeneral(
                textEditingController: controllerName,
                sizeHeight: sizeH * 0.05,
                hintText: 'Nombre',
                labelStyle: TextStyle(color: UbicaColors.black, fontSize: sizeH * 0.02),
                suffixIcon: lockedTextField,
                onChanged: (value){
                  setState(() {
                    editName = true;
                  });
                },
                suffixIconConstraints: boxIcon,
              ),
            ),
            SizedBox(height: sizeH * 0.03,),
            textTitle('Actualizar contraseña', sizeH),
            SizedBox(height: sizeH * 0.03,),
            SizedBox(
              width: sizeW,
              child: TextFieldGeneral(
                textEditingController: controllerPass,
                sizeHeight: sizeH * 0.05,
                hintText: 'Contraseña actual',
                labelStyle: TextStyle(color: UbicaColors.black, fontSize: sizeH * 0.02),
                suffixIcon: lockedTextField,
                obscure: true,
                onChanged: (value){
                  setState(() {
                    editPass = true;
                  });
                },
                suffixIconConstraints: boxIcon,
              ),
            ),
            SizedBox(height: sizeH * 0.015,),
            SizedBox(
              width: sizeW,
              child: TextFieldGeneral(
                textEditingController: controllerPass2,
                sizeHeight: sizeH * 0.05,
                hintText: 'Nueva contraseña',
                labelStyle: TextStyle(color: UbicaColors.black, fontSize: sizeH * 0.02),
                suffixIcon: lockedTextField,
                obscure: true,
                onChanged: (value){
                  setState(() {
                    editPass2 = true;
                  });
                },
                suffixIconConstraints: boxIcon,
              ),
            ),
            SizedBox(height: sizeH * 0.02,),
            SizedBox(
              width: sizeW,
              child: load ? Center(child: circularProgressColors(colorCircular: UbicaColors.primary,widthContainer1: sizeW,widthContainer2: sizeW * 0.06)) :
              ButtonGeneral(
                title: 'ACTUALIZAR',
                backgroundColor: UbicaColors.primary,
                borderColor: UbicaColors.primary,
                textStyle: UbicaStyles().stylePrimary(size: sizeH * 0.017, color: UbicaColors.white,enumStyle: EnumStyle.semiBold),
                height: sizeH * 0.05,
                onPressed: () => saveData(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> saveData() async {
    load = true;
    setState(() {});

    FocusScope.of(context).requestFocus(FocusNode());

    String errorText = '';
    if(errorText.isEmpty && controllerName.text.isEmpty){
      errorText = 'Nombre no puede estar vacio';
    }

    if(errorText.isEmpty && controllerPass.text.isEmpty){
      errorText = 'Contraseña actual no puede estar vacio';
    }

    if(errorText.isEmpty && controllerPass2.text.isEmpty){
      errorText = 'Contraseña nueva no puede estar vacio';
    }

    if(errorText.isEmpty && (editName || (editPass && editPass2))){
      try{
        String pass = '';
        String pass2 = '';
        String name = '';
        if(editPass && editPass2){
          pass = controllerPass.text;
          pass2 = controllerPass2.text;
        }
        if(editName){
          name = controllerName.text;
        }

        Map<String,dynamic> data = await AuthenticateFirebaseUser()
            .editFirebaseUser(
          userCredential: userProvider.userFirebase!,
          name: name,
          pass: pass,pass2: pass2
        );
        if(data.isEmpty){
          showAlert(text: '¡ Edición correcta !');
          userProvider.refreshUser();
          Navigator.of(context).pop();
        }else{
          String error = data.containsKey('error') ? data['error'] : 'Problmas de conexión con el servidor';
          showAlert(text: error, isError: true);
        }
      }catch(e){
        showAlert(text: 'Error: ${e.toString()}', isError: true);
      }
    }else{
      showAlert(text: errorText, isError: true);
    }

    load = false;
    setState(() {});
  }

  Widget textTitle(String title, double sizeH,{ TextAlign alinear: TextAlign.left} ){
    return Text(title,textAlign: alinear,
      style: UbicaStyles().stylePrimary(size: sizeH * 0.025, color: UbicaColors.black,fontWeight: FontWeight.bold,enumStyle: EnumStyle.light),
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

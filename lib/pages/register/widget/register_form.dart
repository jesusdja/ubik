import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/config/value_validators.dart';
import 'package:ubik/main.dart';
import 'package:ubik/services/authenticate_firebase.dart';
import 'package:ubik/widgets_utils/button_general.dart';
import 'package:ubik/widgets_utils/circular_progress_colors.dart';
import 'package:ubik/widgets_utils/gallery_camera_dialog.dart';
import 'package:ubik/widgets_utils/textfield_general.dart';
import 'package:ubik/widgets_utils/toast_widget.dart';
import 'package:ubik/widgets_utils/view_image.dart';

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
  bool isObscure = true;

  int pageRegister = 0;
  File? photoUser;
  UploadTask? uploadTask;

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
    return pageRegister == 0 ? pageOne() : pageTwo();
  }

  Widget pageOne(){
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
                obscure: isObscure,
                suffixIcon: IconButton(
                  icon: Icon(isObscure ? Icons.remove_red_eye : Icons.remove_red_eye_outlined, size: sizeH * 0.03),
                  onPressed: () => setState(() {isObscure = !isObscure; }),
                ),
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
                obscure: isObscure,
                suffixIcon: IconButton(
                  icon: Icon(isObscure ? Icons.remove_red_eye : Icons.remove_red_eye_outlined, size: sizeH * 0.03),
                  onPressed: () => setState(() {isObscure = !isObscure; }),
                ),
                textInputType: TextInputType.visiblePassword,
              ),
            ),
            showError && controllerPassword.text != controllerPassword2.text ? _error('Las contraseñas deben ser iguales.') : Container(),
            space,space,space,space,
            SizedBox(
              width: sizeW,
              child: ButtonGeneral(
                title: 'CONTINUAR',
                backgroundColor: UbicaColors.primary,
                borderColor: UbicaColors.primary,
                textStyle: UbicaStyles().stylePrimary(size: sizeH * 0.017, color: UbicaColors.white,enumStyle: EnumStyle.semiBold),
                height: sizeH * 0.06,
                onPressed: (){
                  FocusScope.of(context).requestFocus(FocusNode());
                  showError = validateForm();
                  if(!showError){
                    pageRegister = 1;
                    setState(() {});
                  }
                },
              ),
            ),
            space,
          ],
        ),
      ),
    );
  }

  Widget pageTwo(){
    Widget space = SizedBox(height: sizeH * 0.02,);
    return Container(
      width: sizeW,
      margin: EdgeInsets.only(left: sizeW * 0.1, right: sizeW * 0.1),
      child: Column(
        children: <Widget>[
          addPhoto(),
          space,space,space,
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
          uploadTask == null ?
          SizedBox(
            width: sizeW,
            child: ButtonGeneral(
              title: 'ATRAS',
              backgroundColor: UbicaColors.primary,
              borderColor: UbicaColors.primary,
              textStyle: UbicaStyles().stylePrimary(size: sizeH * 0.017, color: UbicaColors.white,enumStyle: EnumStyle.semiBold),
              height: sizeH * 0.06,
              onPressed: () => setState(() {
                pageRegister = 0;
              }),
            ),
          ) : progressUploadTask(),
          space,
        ],
      ),
    );
  }

  Widget addPhoto(){
    return InkWell(
      child: SizedBox(
        width: sizeW,
        child: Center(
          child: SizedBox(
            width: sizeH * 0.3,
            height: sizeH * 0.3,
            child: CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.3),
              child: photoUser != null ?
              ClipOval(
                child: Image(
                  image: ViewImage().fileImage(photoUser!).image ,
                  fit: BoxFit.contain,
                ),
              ) : SizedBox(
                child: Center(
                  child: Icon(Icons.image,size: sizeH * 0.1,color: Colors.grey,),
                ),
              ),
            ),
          ),
        ),
      ),
      onTap: () async {
        XFile? media = await Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => const GalleryCameraDialog(
              isVideo: false,
            ))
        );
        if(media != null) {
          try{
            File? croppedImage = await ViewImage().croppedImageView(cropStyle: CropStyle.circle, imageFilepath: media.path);
            if(croppedImage != null){
              photoUser = croppedImage;
              setState(() {});
            }
          }catch(e){
            debugPrint(e.toString());
          }
        }
      },
    );
  }

  Future saveUser() async{

    isLoad = true;
    setState(() {});

    String errorText = '';
    if(photoUser == null){
      errorText = 'Debe agregar una foto de perfil';
    }

    if(errorText.isEmpty){
      try{

        String pathPhoto = photoUser!.path;
        String name = pathPhoto.split('/').last;
        final pathUpload = 'files/$name';
        final file = File(pathPhoto);
        final ref = FirebaseStorage.instance.ref().child(pathUpload);
        uploadTask = ref.putFile(file);
        setState(() {});
        final snapshot = await uploadTask!;
        final urlUpload = await snapshot.ref.getDownloadURL();

        Map<String,dynamic> data = await AuthenticateFirebaseUser().registerFirebase(
            email: controllerEmailAddress.text, password: controllerPassword.text,alias: controllerName.text, urlPhoto: urlUpload);
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
    }else{
      showAlert(text: errorText,isError: true);
    }

    isLoad = false;
    uploadTask = null;
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
      pageRegister = 0;
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

  Widget progressUploadTask(){
    return uploadTask == null ? Container() :
    StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context,snapshot){
        if(snapshot.hasData){
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return Container(
            height: sizeH * 0.025,
            margin: EdgeInsets.symmetric(horizontal: sizeW * 0.1),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: UbicaColors.primary,
                  ),
                ),
                Center(
                  child: Text('${(100 * progress).roundToDouble()}%',
                      style: UbicaStyles().stylePrimary(size: sizeH * 0.02, color: Colors.white,enumStyle: EnumStyle.semiBold)),
                )
              ],
            ),
          );
        }
        return Container();
      },
    );

  }
}

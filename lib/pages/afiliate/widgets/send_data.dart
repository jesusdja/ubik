import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/providers/affiliate_user_provider.dart';
import 'package:ubik/providers/home_provider.dart';
import 'package:ubik/providers/user_provider.dart';
import 'package:ubik/services/firebase/firebase_connection_affiliates.dart';
import 'package:ubik/utils/get_data.dart';
import 'package:ubik/widgets_utils/circular_progress_colors.dart';
import 'package:ubik/widgets_utils/toast_widget.dart';

class SendData extends StatefulWidget {
  const SendData({Key? key}) : super(key: key);

  @override
  State<SendData> createState() => _SendDataState();
}

class _SendDataState extends State<SendData> {

  late AffiliateUserProvider affiliateUserProvider;
  bool isLoad = false;
  UploadTask? uploadTask;
  @override
  Widget build(BuildContext context) {

    affiliateUserProvider = Provider.of<AffiliateUserProvider>(context);
    TextStyle style = UbicaStyles().stylePrimary(size: sizeH * 0.02, color: UbicaColors.black, enumStyle: EnumStyle.medium);
    TextStyle style2 = UbicaStyles().stylePrimary(size: sizeH * 0.023, color: UbicaColors.black, enumStyle: EnumStyle.medium);

    return SizedBox(
      width: sizeW,
      height: sizeH * 0.71,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  SizedBox(height: sizeH * 0.02,),
                  SizedBox(
                    width: sizeW,
                    child: Text('Revisar datos',style: style2 ,textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: sizeH * 0.05,),
                  containerColumnData(title: 'Nombre',subTitle: affiliateUserProvider.name,style: style),
                  SizedBox(height: sizeH * 0.02,),
                  containerColumnData(title: 'Teléfono',subTitle: '${getDataCountries()[affiliateUserProvider.prePhone]![1]}${affiliateUserProvider.phone}',style: style),
                  SizedBox(height: sizeH * 0.02,),
                  containerColumnData(title: 'Descripción',subTitle: affiliateUserProvider.description,style: style),
                  SizedBox(height: sizeH * 0.02,),
                  containerColumnData(title: 'Categoría',subTitle: '${affiliateUserProvider.categorySelected['isService'] ? 'Servicio' : 'Comercio'} - ${affiliateUserProvider.categorySelected['name']}',style: style),
                  SizedBox(height: sizeH * 0.02,),
                  containerColumnData(title: 'Dirección',subTitle: '${affiliateUserProvider.placeSelect['name']}',style: style),
                  SizedBox(height: sizeH * 0.02,),
                  containerColumnData(title: 'País',subTitle: '${affiliateUserProvider.placeSelect['country']}',style: style),
                  SizedBox(height: sizeH * 0.02,),
                  containerColumnData(title: 'Estado ',subTitle: '${affiliateUserProvider.placeSelect['state']}',style: style),
                  SizedBox(height: sizeH * 0.02,),
                  containerColumnData(title: 'Ciudad',subTitle: '${affiliateUserProvider.placeSelect['city']}',style: style),
                  SizedBox(height: sizeH * 0.02,),
                  SizedBox(
                    width: sizeW,
                    child: Text('Fotos ',style: style ,textAlign: TextAlign.left,),
                  ),
                  SizedBox(height: sizeH * 0.02,),
                  addPhotos(),
                  SizedBox(height: sizeH * 0.03,),
                ],
              ),
            ),
          ),
          SizedBox(height: sizeH * 0.03,),
          saveButton(),
          SizedBox(height: sizeH * 0.05,),
        ],
      ),
    );
  }

  Widget containerColumnData({required String title, required String subTitle, required TextStyle style}){
    return SizedBox(
      width: sizeW,
      child: Row(
        children: [
          SizedBox(
            width: sizeW * 0.3,
            child: Text(title,style: style,),
          ),
          Expanded(
            child: Text(subTitle, textAlign: TextAlign.left,),
          )
        ],
      ),
    );
  }

  Widget addPhotos(){
    return SizedBox(
      width: sizeW,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          containerAddPhoto(url: affiliateUserProvider.photos[0]),
          SizedBox(width: sizeW * 0.01,),
          affiliateUserProvider.photos[1].isEmpty ? SizedBox(height: sizeH * 0.11,width: sizeH * 0.1) : containerAddPhoto(url: affiliateUserProvider.photos[1]),
          SizedBox(width: sizeW * 0.01,),
          affiliateUserProvider.photos[2].isEmpty ? SizedBox(height: sizeH * 0.11,width: sizeH * 0.1) : containerAddPhoto(url: affiliateUserProvider.photos[2]),
          SizedBox(width: sizeW * 0.01,),
          affiliateUserProvider.photos[3].isEmpty ? SizedBox(height: sizeH * 0.11,width: sizeH * 0.1) : containerAddPhoto(url: affiliateUserProvider.photos[3]),
        ],
      ),
    );
  }

  Widget containerAddPhoto({required String url}){
    return Container(
      height: sizeH * 0.11,
      width: sizeH * 0.11,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        border: Border.all(
          width: 1.5,
          color: UbicaColors.grey,
        ),
        image: DecorationImage(
          image: Image.file(File(url)).image,//ViewImage().assetsImage(url).image,
          fit: BoxFit.fill,
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

  Widget saveButton() {
    return isLoad ?
    SizedBox(
      width: sizeW,
      child: Column(
        children: [
          progressUploadTask(),
          SizedBox(height: sizeH * 0.01,),
          circularProgressColors(widthContainer1: sizeW, colorCircular: UbicaColors.primary, widthContainer2: sizeH * 0.03),
        ],
      ),
    ) :
    InkWell(
      child: Container(
        width: sizeW * 0.3,
        height: sizeH * 0.05,
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
          child: Text('AFILIAR',style: UbicaStyles().stylePrimary(size: sizeH * 0.018, color: UbicaColors.white, enumStyle: EnumStyle.medium)),
        ),
      ),
      onTap: () => saveButtonPress(),
    );
  }

  Future saveButtonPress()async{
    isLoad = true;
    setState(() {});
    try{
      Map<String,dynamic> data = affiliateUserProvider.toMap();
      //SUBIR LISTA DE FOTOS
      List<String> newPhotos = [];
      for(int x = 0; x < affiliateUserProvider.photos.length; x++){
        String pathPhoto = affiliateUserProvider.photos[x];
        if(pathPhoto.isNotEmpty){
          String name = pathPhoto.split('/').last;
          final pathUpload = 'files/$name';
          final file = File(pathPhoto);
          final ref = FirebaseStorage.instance.ref().child(pathUpload);
          uploadTask = ref.putFile(file);
          setState(() {});
          final snapshot = await uploadTask!;
          final urlUpload = await snapshot.ref.getDownloadURL();
          newPhotos.add(urlUpload);
        }
      }
      data['photos'] = newPhotos;
      data['status'] = mapStAffiliateStatus[affiliateStatus.wait];
      data['categoryId'] = affiliateUserProvider.categorySelected['idC'];

      data['uid'] = Provider.of<UserProvider>(context,listen: false).userFirebase!.uid;
      data['profile'] = {
        'name' : Provider.of<UserProvider>(context,listen: false).userFirebase!.displayName,
        'email' : Provider.of<UserProvider>(context,listen: false).userFirebase!.email,
        'photoURL' : Provider.of<UserProvider>(context,listen: false).userFirebase!.photoURL,
      };

      bool res = await FirebaseConnectionAffiliates().createAffiliate(data);
      if(res){
        await alertFinish();
        Provider.of<HomeProvider>(context,listen: false).changePageAffiliate(value: false);
      }else{
        showAlert(text: 'Error de conexión con el servidor', isError: true);
      }
    }catch(e){
      showAlert(text: 'Error de conexión con el servidor', isError: true);
      debugPrint('Error: ${e.toString()}');
    }
    isLoad = false;
    setState(() {});
  }

  Future alertFinish() async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: ( context ) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              content: Container(
                width: sizeW * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('¡GRACIAS!', style: UbicaStyles().stylePrimary(size: sizeH * 0.04, color: UbicaColors.primary,fontWeight: FontWeight.bold, enumStyle: EnumStyle.medium),),
                    SizedBox(height: sizeH * 0.025,),
                    Text('Tu proceso de afiliación ha sido exitoso. En breve un ejecutivo se comunicará contigo',
                      style: UbicaStyles().stylePrimary(size: sizeH * 0.02, enumStyle: EnumStyle.regular),textAlign: TextAlign.center,),
                  ],
                ),
              ),
              actions: <Widget>[
                InkWell(
                  child: Container(
                    width: sizeW,
                    height: sizeH * 0.05,
                    margin: EdgeInsets.symmetric(horizontal: sizeW * 0.2,vertical: sizeH * 0.015),
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
                      child: Text('ACEPTAR',style: UbicaStyles().stylePrimary(size: sizeH * 0.018, color: UbicaColors.white, enumStyle: EnumStyle.medium)),
                    ),
                  ),
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        }
    );
  }
}


import 'dart:io';
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

  @override
  Widget build(BuildContext context) {

    affiliateUserProvider = Provider.of<AffiliateUserProvider>(context);
    TextStyle style = UbicaStyles().stylePrimary(size: sizeH * 0.02, color: UbicaColors.black, enumStyle: EnumStyle.medium);
    TextStyle style2 = UbicaStyles().stylePrimary(size: sizeH * 0.023, color: UbicaColors.black, enumStyle: EnumStyle.medium);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: sizeH * 0.02,),
          SizedBox(
            width: sizeW,
            child: Text('Revisar datos',style: style2 ,textAlign: TextAlign.center,),
          ),
          SizedBox(height: sizeH * 0.05,),
          containerColumnData(title: 'Nombre:',subTitle: affiliateUserProvider.name,style: style),
          SizedBox(height: sizeH * 0.02,),
          containerColumnData(title: 'Teléfono:',subTitle: '${getDataCountries()[affiliateUserProvider.prePhone]![1]}${affiliateUserProvider.phone}',style: style),
          SizedBox(height: sizeH * 0.02,),
          containerColumnData(title: 'Dirección:',subTitle: '${affiliateUserProvider.placeSelect['name']}',style: style),
          SizedBox(height: sizeH * 0.02,),
          containerColumnData(title: 'País:',subTitle: '${affiliateUserProvider.placeSelect['country']}',style: style),
          SizedBox(height: sizeH * 0.02,),
          containerColumnData(title: 'Estado: ',subTitle: '${affiliateUserProvider.placeSelect['state']}',style: style),
          SizedBox(height: sizeH * 0.02,),
          containerColumnData(title: 'Ciudad:',subTitle: '${affiliateUserProvider.placeSelect['city']}',style: style),
          SizedBox(height: sizeH * 0.02,),
          SizedBox(
            width: sizeW,
            child: Text('Fotos: ',style: style ,textAlign: TextAlign.left,),
          ),
          SizedBox(height: sizeH * 0.02,),
          addPhotos(),
          SizedBox(height: sizeH * 0.06,),
          saveButton(),
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
            width: sizeW * 0.22,
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

  Widget saveButton() {
    return isLoad ?
    circularProgressColors(widthContainer1: sizeW, colorCircular: UbicaColors.primary, widthContainer2: sizeH * 0.03)
    :
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
      onTap: () async {
        isLoad = true;
        setState(() {});
        try{
          Map<String,dynamic> data = affiliateUserProvider.toMap();
          data['uid'] = Provider.of<UserProvider>(context,listen: false).userFirebase!.uid;
          data['status'] = mapStAffiliateStatus[affiliateStatus.wait];
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
      },
    );
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


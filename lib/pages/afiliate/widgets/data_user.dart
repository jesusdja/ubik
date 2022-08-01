import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/providers/affiliate_user_provider.dart';
import 'package:ubik/utils/get_data.dart';
import 'package:ubik/widgets_utils/dropdown_button_generic.dart';
import 'package:ubik/widgets_utils/gallery_camera_dialog.dart';
import 'package:ubik/widgets_utils/textfield_general.dart';
import 'package:ubik/widgets_utils/view_image.dart';

class DataUserAffiliate extends StatefulWidget {
  const DataUserAffiliate({Key? key}) : super(key: key);

  @override
  _DialogShowMapState createState() => _DialogShowMapState();
}

class _DialogShowMapState extends State<DataUserAffiliate> {

  Map<String,List<String>> mapCountries = {};
  List<String> bands = [];

  late AffiliateUserProvider affiliateUserProvider;

  @override
  void initState() {
    super.initState();
    mapCountries = getDataCountries();
    mapCountries.forEach((key, value) { bands.add(key); });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    affiliateUserProvider = Provider.of<AffiliateUserProvider>(context);

    TextStyle style1 = UbicaStyles().stylePrimary(size: sizeH * 0.02, color: UbicaColors.black, enumStyle: EnumStyle.medium);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: sizeH * 0.02,),
          SizedBox(
            width: sizeW,
            child: Text('Nombre de servicio u comercio',style: style1,textAlign: TextAlign.left,)
          ),
          SizedBox(height: sizeH * 0.03,),
          TextFieldGeneral(
            sizeHeight: sizeH * 0.05,
            hintText: 'Nombre',
            labelStyle: TextStyle(color: UbicaColors.black, fontSize: sizeH * 0.02),
            textInputType: TextInputType.emailAddress,
            initialValue: affiliateUserProvider.name,
            onChanged: (name){
              affiliateUserProvider.changeName(value: name);
            },
          ),
          SizedBox(height: sizeH * 0.06,),
          SizedBox(
            width: sizeW,
            child: Text('Teléfono',style:style1,textAlign: TextAlign.left,),
          ),
          SizedBox(height: sizeH * 0.02,),
          _selectedCountries(),
          SizedBox(height: sizeH * 0.06,),
          SizedBox(
            width: sizeW,
            child: Text('Se debe agregar al menos una(1) foto. Para tu perfil de servicio o comercio.',style: style1,textAlign: TextAlign.left,),
          ),
          SizedBox(height: sizeH * 0.02,),
          addPhotos(),
          SizedBox(height: sizeH * 0.06,),
          saveButton(),
        ],
      ),
    );
  }

  Widget _selectedCountries(){
    return SizedBox(
      width: sizeW,
      child: Row(
        children: [
          SizedBox(
            height: sizeH * 0.065,
            width: sizeW * 0.33,
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownGeneric(
                sizeH: sizeH,
                value: affiliateUserProvider.prePhone,
                hint: Text('País',style: UbicaStyles().stylePrimary(size: sizeH * 0.018,fontWeight: FontWeight.bold, enumStyle: EnumStyle.light)),
                onChanged: (String? value) {
                  if(value != null){
                    affiliateUserProvider.changePrePhone(value: value);
                  }
                },
                items: bands.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        value.isEmpty ?
                        Container(width: sizeH * 0.03,)
                            :
                        Container(
                          height: sizeH * 0.03,
                          width: sizeH * 0.03,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: ViewImage()
                                  .assetsImage("assets/image/bands/$value.png")
                                  .image,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(width: sizeW * 0.01,),
                        Text(mapCountries[value]![1]),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(width: sizeW * 0.01,),
          Expanded(
            child: TextFieldGeneral(
              sizeHeight: sizeH * 0.05,
              hintText: 'Teléfono',
              enable: affiliateUserProvider.prePhone.isNotEmpty,
              labelStyle:
              TextStyle(color: UbicaColors.black, fontSize: sizeH * 0.02),
              textInputType: TextInputType.phone,
              onTap: (){},
              initialValue: affiliateUserProvider.phone,
              onChanged: (phone){
                affiliateUserProvider.changePhone(value: phone);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget addPhotos(){
    return SizedBox(
      width: sizeW,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          containerAddPhoto(0),
          SizedBox(width: sizeW * 0.01,),
          affiliateUserProvider.photos[0].isEmpty ? SizedBox(height: sizeH * 0.1,width: sizeH * 0.1) : containerAddPhoto(1),
          SizedBox(width: sizeW * 0.01,),
          affiliateUserProvider.photos[1].isEmpty ? SizedBox(height: sizeH * 0.1,width: sizeH * 0.1) : containerAddPhoto(2),
          SizedBox(width: sizeW * 0.01,),
          affiliateUserProvider.photos[2].isEmpty ? SizedBox(height: sizeH * 0.1,width: sizeH * 0.1) : containerAddPhoto(3),
        ],
      ),
    );
  }

  Widget containerAddPhoto(int index){

    double heightWidth = sizeH * 0.1;

    return InkWell(
      onTap: () => _onTapPhoto(index),
      child: affiliateUserProvider.photos[index].isEmpty ? Container(
        height: heightWidth,
        width: heightWidth,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          border: Border.all(
            width: 2.0,
            color: UbicaColors.grey,
          ),
        ),
        child: Center(child: Icon(Icons.add, size: sizeH * 0.05,color: UbicaColors.primary,),),
      ) :
      SizedBox(
        height: heightWidth,
        width: heightWidth,
        child: Stack(
          children: [
            Container(
              height: heightWidth,
              width: heightWidth,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                border: Border.all(
                  width: 1.5,
                  color: UbicaColors.grey,
                ),
                image: DecorationImage(
                  image: Image.file(File(affiliateUserProvider.photos[index])).image,// ViewImage().assetsImage(photos[index]).image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                child: Icon(Icons.cancel, color: Colors.red,size: sizeH * 0.03,),
                onTap: (){
                  affiliateUserProvider.photos[index] = '';
                  List<String> aux = affiliateUserProvider.photos.map((e) => e).toList();
                  List<String> photos = ['','','',''];
                  int pos = 0;
                  for (var element in aux) {
                    if(element.isNotEmpty){
                      photos[pos] = element;
                      pos++;
                    }
                  }
                  affiliateUserProvider.changePhotos(value: photos);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _onTapPhoto(int index) async {
    XFile? media = await Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) => const GalleryCameraDialog(
          isVideo: false,
        ))
    );
    if(media != null) {
      try{
        File? croppedImage = await ViewImage().croppedImageView(cropStyle: CropStyle.rectangle, imageFilepath: media.path);

        if(croppedImage != null){
          List<String> photos =  affiliateUserProvider.photos;
          photos[index] = croppedImage.path;
          affiliateUserProvider.changePhotos(value: photos);
        }
      }catch(e){
        debugPrint(e.toString());
      }
    }
  }

  Widget saveButton() {
    return InkWell(
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
          child: Text('CONTINUAR',style: UbicaStyles().stylePrimary(size:sizeH * 0.018, color: UbicaColors.white, enumStyle: EnumStyle.medium)),
        ),
      ),
      onTap: (){
        // if(context.bloc<AffiliateBloc>().state.name.isNotEmpty){
        //   if(context.bloc<AffiliateBloc>().state.prefPhone.isNotEmpty && context.bloc<AffiliateBloc>().state.phone.isNotEmpty){
        //     if(photos[0].isNotEmpty){
        //       context.bloc<AffiliateBloc>()..add(AffiliateEvent.updatePhoto(photos));
        //       context.bloc<AffiliateBloc>()..add(AffiliateEvent.updateFace(1));
        //     }else{
        //       showError(context, 'Debe agregar al menos una foto.');
        //     }
        //   }else{
        //     showError(context, 'Debe agregar un número de teléfono.');
        //   }
        // }else{
        //   showError(context, 'Debe agregar un nombre.');
        // }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/providers/services_provider.dart';
import 'package:ubik/widgets_utils/view_image.dart';

class ClassDetailsAffiliate extends StatefulWidget {
  const ClassDetailsAffiliate({Key? key, required this.affiliateAd}) : super(key: key);
  final Map<String,dynamic> affiliateAd;
  @override
  _ClassDetailsAffiliateState createState() => _ClassDetailsAffiliateState();
}

class _ClassDetailsAffiliateState extends State<ClassDetailsAffiliate> {
  late Map<String,dynamic> affiliateAd;

  @override
  void initState() {
    super.initState();
    affiliateAd = widget.affiliateAd;
  }

  @override
  Widget build(BuildContext context) {

    TextStyle style = UbicaStyles().stylePrimary(size: sizeH * 0.02, color: UbicaColors.black, enumStyle: EnumStyle.medium);

    ServicesProvider servicesProvider = Provider.of<ServicesProvider>(context);
    Map<String,dynamic> category = {};
    for (var element in servicesProvider.dataServices) {
      if(element['idC'] == affiliateAd['categoryId']){
        category = element;
      }
    }
    for (var element in servicesProvider.dataBusiness) {
      if(element['idC'] == affiliateAd['categoryId']){
        category = element;
      }
    }

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: sizeW * 0.9,
            color: UbicaColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: sizeH * 0.02),
                  Container(
                    width: sizeW,
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: ()=>Navigator.of(context).pop(),
                      child: containerImageAssets(sizeH * 0.05, sizeH * 0.09,'icon_close_app_orange.png'),
                    ),
                  ),
                  SizedBox(height: sizeH * 0.02),
                  containerColumnData(title: 'Descripción',subTitle: affiliateAd['description'],style: style),
                  SizedBox(height: sizeH * 0.02,),
                  containerColumnData(title: 'Categoría',subTitle: category.isEmpty ? '' : '${category['isService'] ? 'Servicio' : 'Comercio'} - ${category['name']}',style: style),
                  SizedBox(height: sizeH * 0.02,),
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
        ),
      ),
    );
  }

  Widget containerColumnData({required String title, required String subTitle, required TextStyle style}){
    return SizedBox(
      width: sizeW,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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

    List photos = affiliateAd['photos'];

    return SizedBox(
      width: sizeW,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: containerAddPhoto(url: photos[0]),
          ),
          SizedBox(width: sizeW * 0.01,),
          Expanded(
            child: photos.length < 2 ? SizedBox(height: sizeH * 0.11,width: sizeH * 0.1) : containerAddPhoto(url: photos[1]),
          ),
          SizedBox(width: sizeW * 0.01,),
          Expanded(
            child: photos.length < 3 ? SizedBox(height: sizeH * 0.11,width: sizeH * 0.1) : containerAddPhoto(url: photos[2]),
          ),
          SizedBox(width: sizeW * 0.01,),
          Expanded(
            child: photos.length < 4 ? SizedBox(height: sizeH * 0.11,width: sizeH * 0.1) : containerAddPhoto(url: photos[3]),
          ),
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
          image: Image.network(url).image,//ViewImage().assetsImage(url).image,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
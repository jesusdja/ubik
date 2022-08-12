import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/services/firebase/firebase_connection_affiliates.dart';
import 'package:ubik/services/firebase/firebase_connection_invoices.dart';
import 'package:ubik/services/sharedprefereces.dart';
import 'package:ubik/widgets_utils/button_general.dart';
import 'package:ubik/widgets_utils/textfield_general.dart';
import 'package:ubik/widgets_utils/toast_widget.dart';
import 'package:ubik/widgets_utils/view_image.dart';

class ClassQualifyAffiliate extends StatefulWidget {
  const ClassQualifyAffiliate({Key? key, required this.invoiceAd, required this.type, required this.listAllInvoices}) : super(key: key);
  final Map<String,dynamic> invoiceAd;
  final int type;
  final List<QueryDocumentSnapshot> listAllInvoices;
  @override
  _ClassQualifyAffiliateState createState() => _ClassQualifyAffiliateState();
}

class _ClassQualifyAffiliateState extends State<ClassQualifyAffiliate> {
  late Map<String,dynamic> invoiceAd;
  Map<int,int> mapStartIndex = {};
  bool upLoad = false;
  TextEditingController controllerComment = TextEditingController();
  String uidFirebase = '';

  @override
  void initState() {
    super.initState();
    uidFirebase = SharedPrefs.prefs.getString('userFirebaseUbik') ?? '';
    invoiceAd = widget.invoiceAd;
  }

  @override
  Widget build(BuildContext context) {
    if(mapStartIndex.isEmpty){
      mapStartIndex[1] = 1;
      mapStartIndex[2] = 0;
      mapStartIndex[3] = 0;
      mapStartIndex[4] = 0;
      mapStartIndex[5] = 0;
    }

    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: sizeW * 0.9,
            color: UbicaColors.white,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: sizeW,
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: sizeW * 0.015,),
                        InkWell(
                          onTap: ()=>Navigator.of(context).pop(),
                          child: containerImageAssets (sizeH * 0.05, sizeH * 0.09,'icon_close_app_orange.png'),
                        ),
                        SizedBox(width: sizeW * 0.015,),
                        Text('Calificar Servicio',style: UbicaStyles().stylePrimary(size: sizeH * 0.022,fontWeight: FontWeight.bold,enumStyle: EnumStyle.light),),
                      ],
                    ),
                  ),
                  const Divider(color: UbicaColors.colorBEBDBD,height: 2,),
                  Container(
                    width: sizeW,
                    margin: EdgeInsets.only(left: sizeW * 0.04,right: sizeW * 0.04, top: sizeH * 0.02, bottom: sizeH * 0.02),
                    child: Text('Califica el servicio prestado por este profesional.',style: UbicaStyles().stylePrimary(size: sizeH * 0.018,enumStyle: EnumStyle.light),textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: sizeH * 0.01,),
                  Container(
                    margin: EdgeInsets.only(left: sizeW * 0.1, right: sizeW * 0.1),
                    child: _cardPresentation(),
                  ),
                  SizedBox(height: sizeH * 0.01,),
                  SizedBox(
                    width: sizeW,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () => updateStart(1, mapStartIndex[1]!),
                          child: startContainer(mapStartIndex[1]!),
                        ),
                        InkWell(
                          onTap: () => updateStart(2, mapStartIndex[2]!),
                          child: startContainer(mapStartIndex[2]!),
                        ),
                        InkWell(
                          onTap: () => updateStart(3, mapStartIndex[3]!),
                          child: startContainer(mapStartIndex[3]!),
                        ),
                        InkWell(
                          onTap: () => updateStart(4, mapStartIndex[4]!),
                          child: startContainer(mapStartIndex[4]!),
                        ),
                        InkWell(
                          onTap: () => updateStart(5, mapStartIndex[5]!),
                          child: startContainer(mapStartIndex[5]!),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: sizeH * 0.01,),
                  SizedBox(
                    width: sizeW * 0.7,
                    child: Center(
                      child: TextFieldGeneral(
                        textEditingController: controllerComment,
                        sizeHeight: sizeH * 0.05,
                        hintText: 'Comentario',
                        labelStyle: TextStyle(color: UbicaColors.black, fontSize: sizeH * 0.02),
                      ),
                    ),
                  ),
                  SizedBox(height: sizeH * 0.02,),
                  Container(
                    margin: EdgeInsets.only(left: sizeW * 0.1,right: sizeW * 0.1, bottom: sizeH * 0.02),
                    child: upLoad ?
                    Center(
                      child: SizedBox(
                        width: sizeH * 0.03,
                        height: sizeH * 0.03,
                        child: const CircularProgressIndicator(
                          backgroundColor:
                          UbicaColors.primary,
                        ),
                      ),
                    )
                        :
                    ButtonGeneral(
                      title: 'CALIFICAR',
                      onPressed: () => saveQualify(),
                      backgroundColor: UbicaColors.primary,
                      borderColor: UbicaColors.primary,
                      textStyle: UbicaStyles().stylePrimary(size: sizeH * 0.017,color: UbicaColors.white,enumStyle: EnumStyle.semiBold),
                      height: sizeH * 0.045,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateStart(int index, int old){
    mapStartIndex[1] = 0;
    mapStartIndex[2] = 0;
    mapStartIndex[3] = 0;
    mapStartIndex[4] = 0;
    mapStartIndex[5] = 0;

    if(index == 2){
      mapStartIndex[1] = 2;
    }
    if(index == 3){
      mapStartIndex[1] = 2;
      mapStartIndex[2] = 2;
    }
    if(index == 4){
      mapStartIndex[1] = 2;
      mapStartIndex[2] = 2;
      mapStartIndex[3] = 2;
    }
    if(index == 5){
      mapStartIndex[1] = 2;
      mapStartIndex[2] = 2;
      mapStartIndex[3] = 2;
      mapStartIndex[4] = 2;
    }

    if(old == 0){
      mapStartIndex[index] = 1;
    }
    if(old == 1){
      mapStartIndex[index] = 2;
    }
    if(old == 2){
      mapStartIndex[index] = 2;
    }
    setState(() {});
  }

  Widget _cardPresentation(){

    Image imageProfile = ViewImage().assetsImage('assets/image/Rectangle_38.png');
    if(invoiceAd['profile']['photoURL'] != null){
      imageProfile = ViewImage().netWork(invoiceAd['profile']['photoURL']);
    }

    String affiliateRate = '0.0';
    if(invoiceAd['rate'] != null && (invoiceAd['rate'] as List).isNotEmpty){
      //Calcular rango
      List rateAll = invoiceAd['rate'];
      if(rateAll.isNotEmpty){
        double points = 0.0;
        for (var element in rateAll) {
          try{
            points = points + element['point'];
          }catch(_){}
        }
        double pointRate = points / rateAll.length;
        affiliateRate = pointRate.toStringAsFixed(1);
      }
    }

    String reference = invoiceAd['affiliate_code'] ?? '';

    return SizedBox(
      width: sizeW,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: sizeW * 0.22,
            height: sizeH * 0.15,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: imageProfile.image,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: sizeH * 0.01,left: sizeW * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: sizeW,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: '${invoiceAd['name']}',
                        style: UbicaStyles().stylePrimary(size: sizeH * 0.02,enumStyle: EnumStyle.semiBold),
                        children: [
                          WidgetSpan(
                            child: Container(
                              width: sizeH * 0.02,
                              height: sizeH * 0.02,
                              margin: EdgeInsets.only(left: sizeW * 0.02,bottom: sizeH * 0.002),
                              decoration: BoxDecoration(

                                image: DecorationImage(
                                  image: ViewImage().assetsImage('assets/image/icon_full_star_small.png').image,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                          WidgetSpan(
                            child: Container(
                              margin: EdgeInsets.only(left: sizeW * 0.005),
                              child: Text(double.parse(affiliateRate).toStringAsFixed(1),style: UbicaStyles().stylePrimary(enumStyle: EnumStyle.light, size: sizeH * 0.018),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: sizeH * 0.005,),
                  Text(reference,style: UbicaStyles().stylePrimary(size: sizeH * 0.018, enumStyle: EnumStyle.light),),
                  SizedBox(height: sizeH * 0.005,),
                  SizedBox(
                    child: Text(invoiceAd['description'],
                      maxLines: 8,
                      style: UbicaStyles().stylePrimary(size: sizeH * 0.018,enumStyle: EnumStyle.light),),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget startContainer(int type){

    String name = 'icon_empty_star_medium.png';
    if(type == 1){
      name = 'icon_half_star_medium.png';
    }
    if(type == 2){
      name = 'icon_full_star_small.png';
    }

    return Container(
      height: sizeH * 0.04,
      width: sizeH * 0.04,
      margin: EdgeInsets.all(sizeH * 0.005),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ViewImage().assetsImage('assets/image/$name').image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Future saveQualify()async{
    upLoad = true;
    setState(() {});

    try{
      double sum = 0;
      mapStartIndex.forEach((key, value) {
        if(value == 1){sum += 0.5;}
        if(value == 2){sum += 1;}
      });

      Map<String,dynamic> invoice = {};
      for (var element in widget.listAllInvoices) {
        if(element.id == invoiceAd['affiliate_code']){
          invoice = element.data() as Map<String,dynamic>;
        }
      }

      invoice['comment'] = controllerComment.text;
      invoice['rate'] = sum;
      invoice['isFinish'] = widget.type != 0;

      bool result = await FirebaseConnectionInvoices().editInvoices(data: invoice,id: invoiceAd['affiliate_code']);
      if(result){
        Map<String,dynamic> dataAffiliate = await FirebaseConnectionAffiliates().getAffiliateDoc(id: invoice['id_affiliate']);
        List rateAll = dataAffiliate['rate'] ?? [];
        rateAll.add({'point' : sum, 'uid' : uidFirebase});
        dataAffiliate['rate'] = rateAll;
        await FirebaseConnectionAffiliates().editAffiliate(data: dataAffiliate, id: invoice['id_affiliate']);
        showAlert(text: '¡Calificado con exito!');
        Navigator.of(context).pop(true);
      }else{
        showAlert(text: 'No se pudo claificar, intentelo mas tarde.', isError: true);
      }
    }catch(_){
      showAlert(text: 'Error de conexion con el servidor', isError: true);
    }

    if(mounted){
      upLoad = false;
      setState(() {});
    }
  }

}
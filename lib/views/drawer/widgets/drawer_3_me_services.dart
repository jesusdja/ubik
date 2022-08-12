import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/services/firebase/firebase_connection_affiliates.dart';
import 'package:ubik/services/firebase/firebase_connection_invoices.dart';
import 'package:ubik/services/sharedprefereces.dart';
import 'package:ubik/views/drawer/widgets/drawer_3_me_services_widget_1.dart';
import 'package:ubik/views/drawer/widgets/drawer_3_me_services_widget_2.dart';
import 'package:ubik/widgets_utils/appbar_widgets.dart';
import 'package:ubik/widgets_utils/button_general.dart';
import 'package:ubik/widgets_utils/circular_progress_colors.dart';
import 'package:ubik/widgets_utils/logo_botton.dart';
import 'package:ubik/widgets_utils/view_image.dart';

class DrawerMeServices extends StatefulWidget {
  const DrawerMeServices({Key? key}) : super(key: key);

  @override
  State<DrawerMeServices> createState() => _DrawerMeServicesState();
}

class _DrawerMeServicesState extends State<DrawerMeServices> {

  bool isLoadAffiliate = true;
  bool isLoadInvoices = true;
  List<Map<String,dynamic>> adAffiliate = [];
  List<Map<String,dynamic>> adInvoices = [];

  List<QueryDocumentSnapshot> listAllInvoices = [];

  String uidFirebase = '';
  int page = 0;

  @override
  void initState() {
    super.initState();
    uidFirebase = SharedPrefs.prefs.getString('userFirebaseUbik') ?? '';
    initialDataInvoices();
    initialDataAffiliate();
  }

  Future initialDataInvoices() async{
    try{
      listAllInvoices = await FirebaseConnectionInvoices().getInvoicesForUid(uid: uidFirebase);
      adInvoices = [];
      for (var element in listAllInvoices) {
        Map<String,dynamic> dataAffiliate = await FirebaseConnectionAffiliates().getAffiliateDoc(id: (element.data() as Map<String,dynamic>)['id_affiliate']);
        if(dataAffiliate.isNotEmpty){
          dataAffiliate['affiliate_code'] = element.id;
          Map<String,dynamic> dataElemente = element.data() as Map<String,dynamic>;
          if(dataElemente.containsKey('isFinish')){
            dataAffiliate['finish'] = dataElemente['isFinish'];
          }
          adInvoices.add(dataAffiliate);
        }
      }
    }catch(_){}

    isLoadInvoices = false;
    setState(() {});
  }

  Future initialDataAffiliate() async{
    try{
      List<QueryDocumentSnapshot> listAllInvoices = await FirebaseConnectionAffiliates().getAffiliate(id: uidFirebase);
      for (var element in listAllInvoices) {
        adAffiliate.add(element.data() as Map<String,dynamic>);
      }
    }catch(_){}

    isLoadAffiliate = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(sizeH * 0.07),
        child: appBar(),
      ),
      bottomNavigationBar: logoButton2(),
      body: pageBody(),
    );
  }

  Widget pageBody(){
    return SizedBox(
      width: sizeW,
      child: Column(
        children: [
          SizedBox(height: sizeH * 0.02),
          buttonHeader(),
          SizedBox(height: sizeH * 0.02),
          Expanded(
            child: pageBodyList(),
          ),
        ],
      ),
    );
  }

  Widget pageBodyList(){

    return Container(
      width: sizeW,
      margin: EdgeInsets.symmetric(horizontal: sizeW * 0.02),
      child: (page == 0 ? isLoadAffiliate : isLoadInvoices) ?
      Center(
        child: circularProgressColors(),
      ) :
      (page == 0 ? adAffiliate.isEmpty : adInvoices.isEmpty) ?
      SizedBox(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: sizeW * 0.1),
            child: Text(page == 0 ? 'No existen anuncios creados' : 'No has contactado ningun servicio o comercio',
              style: UbicaStyles().stylePrimary(size: sizeH * 0.04, color: UbicaColors.color535353, enumStyle: EnumStyle.regular)
              ,textAlign: TextAlign.center,),
          ),
        ),
      )
          :
      ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: page == 0 ? adAffiliate.length : adInvoices.length,
        itemBuilder: (context,i){



          return page == 0 ? containerAffiliate(adAffiliate[i]) : containerInvoice(adInvoices[i]);
        },
      ),
    );
  }

  Widget containerAffiliate(Map<String,dynamic> affiliateAd){

    DateTime date = DateTime.parse(affiliateAd['create_at']);
    String dateSt = '${date.day.toString().padRight(2,'0')} / ${date.month.toString().padLeft(2,'0')} / ${date.year}';
    if(DateTime.now().difference(date).inDays <= 0){
      dateSt = '${date.hour.toString().padRight(2,'0')} : ${date.minute.toString().padRight(2,'0')}';
    }

    return Card(
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Row(
          children: [
            SizedBox(width: sizeW * 0.02),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(affiliateAd['name'],
                      style: UbicaStyles().stylePrimary(size: sizeH * 0.02, enumStyle: EnumStyle.regular)),
                  Text(dateSt,
                      style: UbicaStyles().stylePrimary(size: sizeH * 0.018, enumStyle: EnumStyle.regular)),
                ],
              ),
            ),
            SizedBox(width: sizeW * 0.02),
            Container(
              padding: const EdgeInsets.all(5),
              child: ButtonGeneral(
                title: 'Ver detalles',
                titlePadding: const EdgeInsets.all(5),
                radius: 10,
                onPressed: () async {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) {
                      return ClassDetailsAffiliate(affiliateAd: affiliateAd,);
                    },
                  );
                },
                backgroundColor: UbicaColors.primary,
                borderColor: UbicaColors.primary,
                textStyle: UbicaStyles().stylePrimary(size: sizeH * 0.018, enumStyle: EnumStyle.regular,color: Colors.white),
                height: sizeH * 0.05,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget containerInvoice(Map<String,dynamic> invoiceAd){
    return Container(
      margin: EdgeInsets.only(top: sizeH * 0.01, bottom: sizeH * 0.01, left: sizeW * 0.01, right: sizeW * 0.025),
      child: _cardPresentation(dataUser: invoiceAd),
    );
  }

  Widget _cardPresentation({required Map<String, dynamic> dataUser}){
    Widget imageProfile = ViewImage().netWorkCache(dataUser['profile']['photoURL']);

    String _description = dataUser['description'] ?? '';
    String nameUser =  dataUser['name'] ?? '';

    String affiliateRate = '0.0';
    if(dataUser['rate'] != null && (dataUser['rate'] as List).isNotEmpty){
      //Calcular rango
      List rateAll = dataUser['rate'];
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

    return Container(
      width: sizeW,
      margin: EdgeInsets.only(bottom: sizeH * 0.01, top: sizeH * 0.01),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: dataUser['uid'],
                child: SizedBox(
                  width: sizeW * 0.3,
                  height: sizeW * 0.3,
                  child: imageProfile,
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: sizeH * 0.001,left: sizeW * 0.04),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: sizeW,
                        child: Text(nameUser.replaceAll('|', ''), style: UbicaStyles().stylePrimary(size: sizeH * 0.025,fontWeight: FontWeight.bold, enumStyle: EnumStyle.regular),maxLines: 1,),
                      ),
                      SizedBox(height: sizeH * 0.005,),
                      SizedBox(
                        width: sizeW,
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            text: '',
                            style: UbicaStyles().stylePrimary(size: sizeH * 0.02, enumStyle: EnumStyle.semiBold),
                            children: [
                              WidgetSpan(
                                child: Container(
                                  width: sizeH * 0.02,
                                  height: sizeH * 0.02,
                                  margin: EdgeInsets.only(bottom: sizeH * 0.002),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: ViewImage().assetsImage('assets/image/icon_full_star_small.png').image,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              WidgetSpan(
                                child: Container(
                                  margin: EdgeInsets.only(left: sizeW * 0.01),
                                  child: Text(double.parse(affiliateRate).toStringAsFixed(1),style: UbicaStyles().stylePrimary(size: sizeH * 0.02, fontWeight: FontWeight.bold, enumStyle: EnumStyle.light),
                                  ),
                                ),
                              ),
                              WidgetSpan(
                                child: Container(
                                  margin: EdgeInsets.only(left: sizeW * 0.04),
                                  child: containerImageAssets(sizeH * 0.02, sizeH * 0.02,'icon_direccion_profiles.png'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: sizeH * 0.005,),
                      SizedBox(
                        child: Text(_description,
                          style: UbicaStyles().stylePrimary(size: sizeH * 0.018,enumStyle: EnumStyle.regular),
                          textAlign: TextAlign.justify,
                          maxLines: 3,),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: sizeH * 0.01,),

          dataUser.containsKey('finish') ?
          Container() :
          buttonAd(dataUser: dataUser),
        ],
      ),
    );
  }

  Widget buttonAd({required Map<String, dynamic> dataUser}){
    return SizedBox(
      width: sizeW,
      child: Row(
        children: [
          SizedBox(width: sizeW * 0.04,),
          Expanded(
            child: buttonAdContainer(dataUser: dataUser,type: 0),
          ),
          SizedBox(width: sizeW * 0.02,),
          Expanded(
            child: buttonAdContainer(dataUser: dataUser, type: 1),
          ),
          SizedBox(width: sizeW * 0.04,),
        ],
      ),
    );
  }

  Widget buttonAdContainer({required Map<String, dynamic> dataUser, required int type}){
    return ButtonGeneral(
      title: type == 0 ? 'NO REALIZADO' : 'REALIZADO',
      radius: 10,
      onPressed: () async {
        bool? res = await showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return ClassQualifyAffiliate(invoiceAd: dataUser,type: type,listAllInvoices: listAllInvoices,);
          },
        );
        if(res != null && res){
          initialDataInvoices();
        }
      },
      backgroundColor: type == 0 ? UbicaColors.primary : UbicaColors.color6FCF97,
      borderColor: type == 0 ? UbicaColors.primary : UbicaColors.color6FCF97,
      textStyle: UbicaStyles().stylePrimary(size: sizeH * 0.02, enumStyle: EnumStyle.regular, color: type == 0 ? Colors.white : Colors.black),
      height: sizeH * 0.05,
      icon: Container(
        width: sizeH * 0.02,
        height: sizeH * 0.02,
        margin: EdgeInsets.only(right: sizeW * 0.02),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ViewImage().assetsImage(type == 0 ? 'assets/image/icon_thumb_down.png' : 'assets/image/icon_thumb_up.png').image,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget buttonHeader(){
    return SizedBox(
      width: sizeW,
      child: Row(
        children: [
          SizedBox(width: sizeW * 0.04,),
          Expanded(
            child: buttonHeaderContainer(type: 0),
          ),
          SizedBox(width: sizeW * 0.02,),
          Expanded(
            child: buttonHeaderContainer(type: 1),
          ),
          SizedBox(width: sizeW * 0.04,),
        ],
      ),
    );
  }

  Widget buttonHeaderContainer({required int type}){

    bool isSelected = type == page;

    return ButtonGeneral(
      title: type == 0 ? 'Afiliados' : 'Contactados',
      radius: 10,
      onPressed: () async {
        setState(() {
          page = type;
        });
      },
      backgroundColor: isSelected ? UbicaColors.color6FCF97 : Colors.white,
      borderColor: UbicaColors.color6FCF97,
      textStyle: UbicaStyles().stylePrimary(size: sizeH * 0.02, enumStyle: EnumStyle.regular, color: isSelected ? Colors.white : UbicaColors.primary),
      height: sizeH * 0.05,
    );
  }

  Widget appBar(){
    return appBarIcon(
        backgroundColor: UbicaColors.white,
        styleTitle: UbicaStyles().stylePrimary(size: sizeH * 0.025, color: UbicaColors.primary,enumStyle: EnumStyle.regular),
        title: 'Mis servicios',
        elevation: 10.0,
        context: context
    );
  }
}





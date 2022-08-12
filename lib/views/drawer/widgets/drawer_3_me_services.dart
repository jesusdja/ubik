import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/services/firebase/firebase_connection_affiliates.dart';
import 'package:ubik/services/firebase/firebase_connection_invoices.dart';
import 'package:ubik/services/sharedprefereces.dart';
import 'package:ubik/widgets_utils/appbar_widgets.dart';
import 'package:ubik/widgets_utils/button_general.dart';
import 'package:ubik/widgets_utils/circular_progress_colors.dart';
import 'package:ubik/widgets_utils/logo_botton.dart';

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
      List<QueryDocumentSnapshot> listAllInvoices = await FirebaseConnectionInvoices().getInvoicesForUid(uid: uidFirebase);
      print('');

    }catch(_){}

    isLoadInvoices = false;
    setState(() {});
  }

  Future initialDataAffiliate() async{
    try{
      List<QueryDocumentSnapshot> listAllInvoices = await FirebaseConnectionAffiliates().getAffiliate(id: uidFirebase);
      print('');

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
            child: page == 0 ? pageAffiliate() : pageInvoices(),
          ),
        ],
      ),
    );
  }


  Widget pageAffiliate(){
    return Container(
      width: sizeW,
      margin: EdgeInsets.symmetric(horizontal: sizeW * 0.02),
      child: isLoadAffiliate ?
      Center(
        child: circularProgressColors(),
      ) :
      ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: adAffiliate.length,
        itemBuilder: (context,i){
          return Container();
        },
      ),
    );
  }

  Widget pageInvoices(){
    return Container(
      width: sizeW,
      margin: EdgeInsets.symmetric(horizontal: sizeW * 0.02),
      child: isLoadInvoices ?
      Center(
        child: circularProgressColors(),
      ) :
      ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: adInvoices.length,
        itemBuilder: (context,i){
          return Container();
        },
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
      title: type == 0 ? 'Afiliados' : 'Contratados',
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

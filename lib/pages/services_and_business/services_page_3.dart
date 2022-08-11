import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/pages/services_and_business/widgets/map_view_details.dart';
import 'package:ubik/providers/category_provider.dart';
import 'package:ubik/utils/get_data.dart';
import 'package:ubik/widgets_utils/button_general.dart';
import 'package:ubik/widgets_utils/circular_progress_colors.dart';
import 'package:ubik/widgets_utils/view_image.dart';

class ServicesDetails extends StatefulWidget {
  const ServicesDetails({Key? key}) : super(key: key);
  @override
  _ServicesDetailsState createState() => _ServicesDetailsState();
}

class _ServicesDetailsState extends State<ServicesDetails> {
  int pageGallery = 0;
  final _controller = PageController(initialPage: 0);
  bool isLoadUser = false;
  bool isContract = false;
  late CategoryProvider categoryProvider;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      bottomNavigationBar: logoButtonContact(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Stack(
          children: [
            topContainer(),
            Container(
              margin: EdgeInsets.only(top: sizeH * 0.15),
              child: _pageHome(),
            ),
          ],
        ),
      ),
    );
  }

  Widget topContainer(){
    return Container(
      height: sizeH * 0.2,
      width: sizeW,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ViewImage().assetsImage('assets/image/home_top.png').image,
          fit: BoxFit.fitWidth,
        ),
      ),
      child: SizedBox(
        width: sizeW,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: sizeH * 0.06,
                width: sizeH * 0.06,
                margin: EdgeInsets.all(sizeH * 0.01),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ViewImage().assetsImage('assets/image/icon_back_homescreen.png').image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text('Detalles', style: UbicaStyles().stylePrimary(size: sizeH * 0.03, color: UbicaColors.white,enumStyle: EnumStyle.semiBold),),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageHome(){
    return Container(
      height: sizeH,
      width: sizeW,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35.0),
          topRight: Radius.circular(35.0),
        ),
        color: UbicaColors.white,
        border: Border.all(
          color: UbicaColors.white,
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      child: isLoadUser ?
      Center(child: circularProgressColors(
          colorCircular: UbicaColors.primary,widthContainer1: sizeW, widthContainer2: sizeW * 0.03
      ),) :
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(35.0),
            topRight: Radius.circular(35.0),
          ),
          child: columnContainer()
        ),
      ),
    );
  }

  Widget columnContainer(){
    String description = categoryProvider.userSelectedDetails['description'] ?? ''; //'Profesional de cerrajería con más de 10 años de experiencia.\nEnim malesuada erat lectus magna gravida cras ultricies ac lacus aliquet velit et sapien hac pulvinar felis massa pellentesque feugiat tempus pulvinar et metus mauris vel nulla auctor nunc, quis elementum proin lectus sed fermentum vitae purus in fermentum fusce dui quam quis varius in est sit vivamus quis integer vel vitae ut ac non felis sagittis, amet pharetra, pellentesque risus, et lobortis sed mus sit cras a sed aliquam massa id eros, nec duis in vestibulum in turpis sapien at mi nunc dictum posuere magna diam massa arcu accumsan, ac dictum adipiscing faucibus aliquam lacus, ipsum leo.';
    List<Widget> listStar = [star(2),star(2),star(2),star(2),star(2),];
    if(categoryProvider.userSelectedDetails['pointRate'] != null && categoryProvider.userSelectedDetails['pointRate'] != 0.0){
      double affiliateRate = categoryProvider.userSelectedDetails['pointRate'];
      if(affiliateRate <= 0.5){ listStar = [star(2),star(2),star(2),star(2),star(2),];}
      if(affiliateRate > 0.5 && affiliateRate < 1){ listStar = [star(1),star(2),star(2),star(2),star(2),];}
      if(affiliateRate >= 1 && affiliateRate < 1.5){listStar = [star(0),star(2),star(2),star(2),star(2),];}
      if(affiliateRate >= 1.5 && affiliateRate < 2){listStar = [star(0),star(1),star(2),star(2),star(2),];}
      if(affiliateRate >= 2 && affiliateRate < 2.5){listStar = [star(0),star(0),star(2),star(2),star(2),];}
      if(affiliateRate >= 2.5 && affiliateRate < 3){listStar = [star(0),star(0),star(1),star(2),star(2),];}
      if(affiliateRate >= 3 && affiliateRate < 3.5){listStar = [star(0),star(0),star(0),star(2),star(2),];}
      if(affiliateRate >= 3.5 && affiliateRate < 4){listStar = [star(0),star(0),star(0),star(1),star(2),];}
      if(affiliateRate >= 4 && affiliateRate < 4.5){listStar = [star(0),star(0),star(0),star(0),star(2),];}
      if(affiliateRate >= 4.5 && affiliateRate < 5){listStar = [star(0),star(0),star(0),star(0),star(1),];}
      if(affiliateRate >= 5){listStar = [star(0),star(0),star(0),star(0),star(0),];}
    }

    String phone = '${getDataCountries()[categoryProvider.userSelectedDetails['prePhone']]![1]}${categoryProvider.userSelectedDetails['phone']}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _galleryPhoto(),
        SizedBox(height: sizeH * 0.003,),
        _galleryPhotoCircular(),
        Container(
          width: sizeW,
          margin: EdgeInsets.only(top: sizeH * 0.05, left: sizeW * 0.06),
          child: Text(categoryProvider.userSelectedDetails['name'],style: UbicaStyles().stylePrimary(size: sizeH * 0.03,fontWeight: FontWeight.bold, enumStyle: EnumStyle.light),textAlign: TextAlign.left,),
        ),
        Container(
          width: sizeW,
          margin: EdgeInsets.only(top: sizeH * 0.01, left: sizeW * 0.06),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: listStar,
          ),
        ),
        Container(
          width: sizeW,
          margin: EdgeInsets.only(top: sizeH * 0.01, left: sizeW * 0.06),
          child: Row(
            children: <Widget>[
              containerImageAssets(sizeH * 0.02, sizeH * 0.02,'icon_direccion_profiles.png'),
              SizedBox(width: sizeW * 0.01,),
              Text('A ${categoryProvider.userSelectedDetails['distance']} km, ${categoryProvider.userSelectedDetails['placeSelect']['city']}',style: UbicaStyles().stylePrimary(size: sizeH * 0.018,fontWeight: FontWeight.bold, enumStyle: EnumStyle.light),),
            ],
          ),
        ),
        SizedBox(height: sizeH * 0.03,),
        Padding(
          padding: EdgeInsets.only(right: sizeW * 0.02, left: sizeW * 0.02,),
          child: Divider(
            height: sizeH * 0.002,
            color: Colors.black,
          ),
        ),
        SizedBox(height: sizeH * 0.03,),
        Container(
          width: sizeW,
          margin: EdgeInsets.only(top: sizeH * 0.01, left: sizeW * 0.06, right: sizeW * 0.06),
          child: Text(description,style: UbicaStyles().stylePrimary(size: sizeH * 0.018,fontWeight: FontWeight.bold, enumStyle: EnumStyle.light),textAlign: TextAlign.justify,),
        ),
        SizedBox(height: sizeH * 0.03,),
        Padding(
          padding: EdgeInsets.only(right: sizeW * 0.02, left: sizeW * 0.02,),
          child: Divider(
            height: sizeH * 0.002,
            color: Colors.black,
          ),
        ),
        Container(
          width: sizeW,
          margin: EdgeInsets.only(top: sizeH * 0.03, left: sizeW * 0.06),
          child: Text('Contacto:',style: UbicaStyles().stylePrimary(size: sizeH * 0.025,fontWeight: FontWeight.bold, enumStyle: EnumStyle.light),textAlign: TextAlign.left,),
        ),
        SizedBox(height: sizeH * 0.02,),
        SizedBox(
          width: sizeW,
          child: Column(
            children: <Widget>[
              SizedBox(
                width: sizeW,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: sizeW * 0.04,),
                    Expanded(
                      child: buttonContact(type: 1,data: phone),
                    ),
                    SizedBox(width: sizeW * 0.04,),
                    Expanded(
                      child: buttonContact(type: 0,data: phone),
                    ),
                    SizedBox(width: sizeW * 0.04,),
                  ],
                ),
              ),
              Container(
                width: sizeW,
                padding: EdgeInsets.all(sizeW * 0.04,),
                child: buttonContact(type: 2,data: categoryProvider.userSelectedDetails['profile']['email']),
              ),
            ],
          ),
        ),
        SizedBox(height: sizeH * 0.05,),
        const MapView(),
        SizedBox(
          width: sizeW,
          child: Center(
            child: Container(
              width: sizeW * 0.25,
              height: sizeH * 0.10,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ViewImage().assetsImage('assets/image/logo_orange.png').image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: sizeH * 0.05,),
      ],
    );
  }

  Widget buttonContact({required int type, required String data}){
    Color colorBg = UbicaColors.color6FCF97;
    Color colorFont = UbicaColors.black;
    String imageStr = 'icon_whatsapp_profiles.png';
    if(type == 1){
      imageStr = 'icon_phone_number_profiles.png';
      colorBg = UbicaColors.colorBEBDBD;
    }
    if(type == 2){
      colorBg = UbicaColors.color706864;
      imageStr = 'icon_email_profiles.png';
      colorFont = UbicaColors.white;
    }
    return InkWell(
      onTap: (){
        if(type == 0){
          String phone = '${getDataCountries()[categoryProvider.userSelectedDetails['prePhone']]![1]}${categoryProvider.userSelectedDetails['phone']}';
          phone = phone.replaceAll(' ','').replaceAll('+','');
          Helpers.launchURL('https://wa.me/$num');
        }
        if(type == 1){
          Helpers.launchURL('tel://$data');
        }
        if(type == 2){
          Helpers.launchURL('mailto:$data?subject=Contacto Ubi-k&body=%20Saludos, le escribo desde la app Ubi-k');
        }
      },
      child: Container(
        padding: EdgeInsets.all(sizeH * 0.01),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: colorBg,
          border: Border.all(
            color: colorBg,
            width: 1.5,
            style: BorderStyle.solid,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(4.0, 4.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            SizedBox(width: sizeW * 0.03,),
            Container(
              width: sizeH * 0.02,
              height: sizeH * 0.02,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ViewImage().assetsImage('assets/image/$imageStr').image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: sizeW * 0.02,),
            type == 2 ?
            Expanded(child: Text(data,style: UbicaStyles().stylePrimary(size: sizeH * 0.018,color: colorFont, enumStyle: EnumStyle.light),))
              :
            Expanded(child: FittedBox(
              fit:BoxFit.contain,
              child: Text(data,style: UbicaStyles().stylePrimary(size: sizeH * 0.018,color: colorFont, enumStyle: EnumStyle.light),)),
            ),
            SizedBox(width: sizeW * 0.02,),
          ],
        ),
      ),
    );
  }

  Widget star(int type){
    String starSelect = 'icon_full_star_small.png';
    if(type == 1){
      starSelect = 'icon_half_star_medium.png';
    }
    if(type == 2){
      starSelect = 'icon_empty_star_medium.png';
    }

    return Container(
      width: sizeH * 0.03,
      height: sizeH * 0.03,
      margin: EdgeInsets.only(right: sizeW * 0.008),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ViewImage().assetsImage('assets/image/$starSelect').image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Map<String,dynamic> _galleryMap(){
    bool _l = false;
    bool _r = false;
    String _image = categoryProvider.userSelectedDetails['profile']['photoURL'];
    List photos = categoryProvider.userSelectedDetails['photos'] as List;

    if(pageGallery == 0){
      _l = false;_r = false;
      if(photos.length == 1){
        _r = true;
      }
    }
    if(pageGallery == 1){
      _l = true;_r = false;
      if(photos.length > 1){
        _r = true;
      }
    }
    if(pageGallery == 2){
      _l = true;_r = false;
      if(photos.length > 2){
        _r = true;
      }
    }
    if(pageGallery == 3){
      _l = true;_r = false;
      if(photos.length > 3){
        _r = true;
      }
    }
    if(pageGallery == 4){
      _l = true;_r = false;
    }
    Map<String,dynamic> gale = { 'image' : _image, 'L': _l, 'R': _r };
    return gale;
  }

  Widget _galleryPhoto(){
    Map<String,dynamic> galleryMap = _galleryMap();

    if(galleryMap.isNotEmpty){
      List<Widget> _pages = [
        Hero(
          tag: categoryProvider.userSelectedDetails['uid'],
          child: Container(
            width: sizeW,
            height: sizeH * 0.4,
            margin: EdgeInsets.symmetric(horizontal: sizeW * 0.06),
            child: ViewImage().netWorkCache(galleryMap['image'],boxFit: BoxFit.fitWidth),
          ),
        ),
      ];
      List photos = categoryProvider.userSelectedDetails['photos'] as List;
      for(int x = 0; x < photos.length; x++){
        _pages.add(Container(
          width: sizeW,
          height: sizeH * 0.4,
          margin: EdgeInsets.symmetric(horizontal: sizeW * 0.06),
          child: ViewImage().netWorkCache(photos[x],boxFit: BoxFit.fitWidth),
        ));
      }

      return SizedBox(
        width: sizeW,
        height: sizeH * 0.4,
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: sizeW,
              height: sizeH * 0.4,
              child: PageView(
                controller: _controller,
                children: _pages,
                onPageChanged: (int page) {
                  setState(() {
                    pageGallery = page;
                  });
                },
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: sizeW * 0.1,
                height: sizeH * 0.05,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: galleryMap['L'] ? ViewImage().assetsImage('assets/image/icon_profile_left_on.png').image :
                    ViewImage().assetsImage('assets/image/icon_profile_left_off.png').image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: sizeW * 0.1,
                height: sizeH * 0.05,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: galleryMap['R'] ? ViewImage().assetsImage('assets/image/icon_profile_rigth_on.png').image :
                    ViewImage().assetsImage('assets/image/icon_profile_rigth_off.png').image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    return Container();
  }

  Widget _galleryPhotoCircular(){
    List photos = categoryProvider.userSelectedDetails['photos'] as List;
    bool image1 = photos.isNotEmpty;
    bool image2 = photos.length > 1;
    bool image3 = photos.length > 2;
    bool image4 = photos.length > 3;
    return SizedBox(
      width: sizeW,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.brightness_1,size: sizeH * 0.025, color: pageGallery == 0 ? UbicaColors.primary : UbicaColors.grey,),
          !image1 ? Container() : SizedBox(width: sizeH * 0.005,),
          !image1 ? Container() : Icon(Icons.brightness_1,size: sizeH * 0.025, color: pageGallery == 1 ? UbicaColors.primary : UbicaColors.grey,),
          !image2 ? Container() : SizedBox(width: sizeH * 0.005,),
          !image2 ? Container() : Icon(Icons.brightness_1,size: sizeH * 0.025, color: pageGallery == 2 ? UbicaColors.primary : UbicaColors.grey,),
          !image3 ? Container() : SizedBox(width: sizeH * 0.005,),
          !image3 ? Container() : Icon(Icons.brightness_1,size: sizeH * 0.025, color: pageGallery == 3 ? UbicaColors.primary : UbicaColors.grey,),
          !image4 ? Container() : SizedBox(width: sizeH * 0.005,),
          !image4 ? Container() : Icon(Icons.brightness_1,size: sizeH * 0.025, color: pageGallery == 4 ? UbicaColors.primary : UbicaColors.grey,),
        ],
      ),
    );
  }

  Widget logoButtonContact(){

    Widget space = SizedBox(width: sizeW * 0.035,);
    String phone = '${getDataCountries()[categoryProvider.userSelectedDetails['prePhone']]![1]}${categoryProvider.userSelectedDetails['phone']}';

    return Container(
      margin: EdgeInsets.only(top: sizeH * 0.01,bottom: sizeH * 0.01),
      child: isContract ?
      SizedBox(
        width: sizeW,
        height: sizeH * 0.05,
        child: Center(
          child: SizedBox(
            width: sizeH * 0.04,
            height: sizeH * 0.04,
            child: const CircularProgressIndicator(
              backgroundColor:
              UbicaColors.primary,
            ),
          ),
        ),
      )
          :
      Row(
        children: <Widget>[
          space,
          Expanded(
            child: ButtonGeneral(
              title: 'SMS',
              onPressed: () => Helpers.launchURL('sms: $phone'),
              backgroundColor: UbicaColors.primary,
              borderColor: UbicaColors.primary,
              textStyle: UbicaStyles().stylePrimary(size: sizeH * 0.018,color: UbicaColors.white,fontWeight: FontWeight.bold, enumStyle: EnumStyle.light),
              height: sizeH * 0.05,
              icon: Container(
                width: sizeH * 0.018,
                height: sizeH * 0.018,
                margin: EdgeInsets.only(right: sizeW * 0.02),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ViewImage().assetsImage('assets/image/icon_email_profiles.png').image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          space,
          Expanded(
            child: ButtonGeneral(
              title: 'CONTACTAR',
              //TODO CHANGE
              onPressed: (){}, // => contextGene.bloc<ServicesBloc>()..add(ServicesEvent.contractServices(widget.affiliate['id'])),
              backgroundColor: UbicaColors.color6FCF97,
              borderColor: UbicaColors.color6FCF97,
              textStyle: UbicaStyles().stylePrimary(size: sizeH * 0.018,fontWeight: FontWeight.bold, enumStyle: EnumStyle.light),
              height: sizeH * 0.05,
              icon: Container(
                width: sizeH * 0.018,
                height: sizeH * 0.018,
                margin: EdgeInsets.only(right: sizeW * 0.02),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ViewImage().assetsImage('assets/image/icon_call_user_profiles.png').image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          space
        ],
      ),
    );
  }

  Widget appBar(BuildContext context, double sizeH, double sizeW){
    return AppBar(
      backgroundColor: UbicaColors.white,
      title: Text('Detalles',style: UbicaStyles().stylePrimary(size: sizeH * 0.025, color: UbicaColors.primary, enumStyle: EnumStyle.medium),),
      elevation: 10.0,
      leading: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: EdgeInsets.all(sizeH * 0.01),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ViewImage().assetsImage('assets/image/icon_back_app-orange.png').image,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}

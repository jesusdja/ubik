import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/providers/category_provider.dart';
import 'package:ubik/utils/get_data.dart';
import 'package:ubik/widgets_utils/button_general.dart';
import 'package:ubik/widgets_utils/circular_progress_colors.dart';
import 'package:ubik/widgets_utils/dropdown_button_generic.dart';
import 'package:ubik/widgets_utils/textfield_general.dart';
import 'package:ubik/widgets_utils/view_image.dart';


class ServicesView extends StatefulWidget {
  const ServicesView({
    Key? key,
    required this.typeCategory,
    required this.category,
  }) : super(key: key);

  final int typeCategory;
  final Map<String,dynamic> category;

  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {

  final List<String> filterKm = ['Normal (200 metros)','400 metros','600 metros'];
  TextEditingController tbs = TextEditingController();
  String idSelected = "0";
  final PageController _controller = PageController( initialPage: 0,);
  Map<int, String> mapFilter = {
    1: 'Normal (200 metros)' ,2: '400 metros' ,3: '600 metros',0: 'Todos',
  };

  late CategoryProvider categoryProvider;

  @override
  void initState() {
    super.initState();
    initialData();
  }

  Future initialData() async{
    await Future.delayed(const Duration(seconds: 1));
    categoryProvider.changeCategory = widget.category;
  }

  @override
  void dispose() {
    categoryProvider.changeLoad = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    categoryProvider = Provider.of<CategoryProvider>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: UbicaColors.white,
        body: Stack(
          children: [
            topContainer(),
            Container(
              margin: EdgeInsets.only(top: sizeH * 0.28),
              child: _pageHome(),
            ),
          ],
        ),
      ),
    );
  }

  Widget topContainer(){
    return Container(
      height: sizeH * 0.44,
      width: sizeW,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ViewImage().assetsImage('assets/image/home_top.png').image,
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
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
                  child: Text(widget.category['name'], style: UbicaStyles().stylePrimary(size: sizeH * 0.03, color: UbicaColors.white, enumStyle: EnumStyle.semiBold),),
                ),
              ],
            ),
          ),
          SizedBox(
            width: sizeW,
            child: categoryProvider.indexPage == 0 ? _buttonSearch() : _listMapUsers(),
          ),
          SizedBox(
            width: sizeW,
            child: Row(
              children: [
                SizedBox(width: sizeW * 0.1,),
                Expanded(
                  child: containerButtonPage('Lista', categoryProvider.indexPage == 0, 0),
                ),
                SizedBox(width: sizeW * 0.05,),
                Expanded(
                  child: containerButtonPage('Mapa', categoryProvider.indexPage == 1, 1),
                ),
                SizedBox(width: sizeW * 0.1,),
              ],
            ),
          ),
          SizedBox(height: sizeH * 0.17,),
        ],
      ),
    );
  }

  Widget containerButtonPage(String title, bool selected, int index){
    return InkWell(
      onTap: (){
        if(index != categoryProvider.indexPage){
          _controller.jumpToPage(index);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: sizeH * 0.005),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(35.0)),
          color: selected ? UbicaColors.white : Colors.transparent,
          border: Border.all(
            color: UbicaColors.white,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Text(title, textAlign: TextAlign.center,style: UbicaStyles().stylePrimary(size: sizeH * 0.02
        ,color: selected ? UbicaColors.primary : UbicaColors.white, enumStyle: EnumStyle.medium),),
      ),
    );
  }

  Widget _buttonSearch(){
    return Container(
      margin: EdgeInsets.all(sizeH * 0.017),
      child: TextFieldGeneral(
        textEditingController: tbs,
        sizeBorder: 1.0,
        radius: 35.0,
        suffixIcon: buttonFilterTap(),
        hintText: '¿Qué necesitas?',
        labelStyle: UbicaStyles().stylePrimary(size: sizeH * 0.02, color: UbicaColors.color706864, enumStyle: EnumStyle.light),
        prefixIconConstraints: BoxConstraints.expand(width: sizeH * 0.05, height: sizeH * 0.05),
        suffixIconConstraints: BoxConstraints.expand(width: sizeH * 0.05, height: sizeH * 0.04),
        onChanged: (String value){
          setState(() {});
        },
      ),
    );
  }

  Widget _listMapUsers(){
    return Container(
      width: sizeW,
      height: sizeH * 0.1,
      margin: EdgeInsets.only(left: sizeW * 0.05),
      child: ListView.builder(
        itemCount: categoryProvider.listUsers.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i){
          return InkWell(
            onTap: (){
              //TODO CHANGE
              // idSelectd = state.usersAffiliate[i]['id'].toString();
              // setState(() {});
            },
            child: SizedBox(
              width: sizeW * 0.15,
              child: Center(
                child: Container(
                  width: sizeH * 0.06,
                  height: sizeH * 0.06,
                  decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      //TODO CHANGE
                      // image: DecorationImage(
                      //   image: ViewImage().netWork(state.usersAffiliate[i]['user']['avatar'], '').image,
                      //   fit: BoxFit.fill,
                      // )
                  ),
                ),
              ),
            ),
          );
        },
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
      child: categoryProvider.loadDataInitial ?
      Center(child: circularProgressColors(
        colorCircular: UbicaColors.primary,widthContainer1: sizeW, widthContainer2: sizeW * 0.03
      ),) :
      SizedBox(
        width: sizeW,
        child: PageView(
          controller: _controller,
          onPageChanged: (index){
            if(index == 0){
              categoryProvider.changeUserSelectedMap = '0';
            }
            categoryProvider.indexPage = index;
            setState(() {});
          },
          children: [
            _listContainer(),
            //TODO CHANGE
            Container()//MapViewServices(typeCategory: widget.typeCategory),
          ],
        ),
      ),
    );
  }

  Widget _listContainer(){
    List<Map<String,dynamic>> listConta = categoryProvider.listUsers;
    for(int x = 0; x < listConta.length; x++){
      String distanciaKm = '0';
      try{
        if(listConta[x]['placeSelect']['latitude'] != 0 && listConta[x]['placeSelect']['longitude'] != 0){
          distanciaKm = getDistanceTwoPoints(LatLng(listConta[x]['placeSelect']['latitude'],listConta[x]['placeSelect']['latitude']) , categoryProvider.positionNow);
        }
        listConta[x]['distance'] = double.parse(distanciaKm);
      }catch(e){
        debugPrint(e.toString());
      }
    }
    listConta.sort((a, b) => a['distance'].compareTo(b['distance']));
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: listConta.length,
            itemBuilder: (context, index) {
              double distanciaKm = listConta[index]['distance'] as double;
              bool see = true;
              if(categoryProvider.filterDistance != 0 && distanciaKm != 0){
                if(categoryProvider.filterDistance == 1 && distanciaKm > 0.2){ see = false;}
                if(categoryProvider.filterDistance == 2 && distanciaKm > 0.4){ see = false;}
                if(categoryProvider.filterDistance == 3 && distanciaKm > 0.6){ see = false;}
              }

              String nameAffiliate = listConta[index]['name'] ?? '';
              if((!see) || (tbs.text.isNotEmpty && !(nameAffiliate.toLowerCase().contains(tbs.text.toLowerCase())))){
                return Container();
              }

              return Container(
                margin: EdgeInsets.only(top: sizeH * 0.01, bottom: sizeH * 0.01, left: sizeW * 0.01, right: sizeW * 0.025),
                child: _cardPresentation(dataUser: listConta[index]),
              );
            },
            separatorBuilder: (context, index) {
              //TODO CHANGE
              // String distanciaKm = '0';
              // if(state.position.latitude != 0 && state.position.longitude != 0){
              //   distanciaKm = getDistanceTwoPoints(LatLng(double.parse(listConta[index]['user']['latitude']),double.parse(listConta[index]['user']['longitude'])) , state.position);
              // }
              // bool see = true;
              // if(state.filterDistance != 0 && distanciaKm != '0'){
              //   if(state.filterDistance == 1 && double.parse(distanciaKm) > 0.2){ see = false;}
              //   if(state.filterDistance == 2 && double.parse(distanciaKm) > 0.4){ see = false;}
              //   if(state.filterDistance == 3 && double.parse(distanciaKm) > 0.6){ see = false;}
              // }
              //
              // String nameAffiliate = '${listConta[index]['user']['name']} ${listConta[index]['user']['surname']}';
              // if(!see || state.filterAffiliate.isNotEmpty && !(nameAffiliate.toLowerCase().contains(state.filterAffiliate.toLowerCase()))){
              //   return Container();
              // }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: sizeW * 0.05),
                child: Divider(
                  height: sizeH * 0.002,
                  color: UbicaColors.colorD6D6D6,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _cardPresentation({required Map<String, dynamic> dataUser}){
    String distanciaKm = (dataUser['distance'] as double).toStringAsFixed(0);
    Image imageProfile = ViewImage().assetsImage('assets/image/Rectangle_38.png');
    if(dataUser['profile']['photo'] != null){
      imageProfile = ViewImage().netWork(dataUser['profile']['photo'],'');
    }

    String _description = dataUser['description'] ?? '';
    String nameUser =  dataUser['name'] ?? '';

    String affiliateRate = '0';
    // if(dataUser['affiliate_rate'] != null && dataUser['affiliate_rate'] != ''){
    //   affiliateRate = '${dataUser['affiliate_rate']}';
    // }

    return InkWell(
      onTap: (){
        //TODO CHANGE
        // router.Router.navigator.pushNamed(router.Router.servicesDetails,
        //     arguments: router.ServicesDetailsArguments(
        //       typeCategory: widget.typeCategory,
        //       affiliate: dataUser['user'],
        //       distance: distanciaKm,
        //       servicesAffiliate: dataUser,
        //     ));
        // contextPage.bloc<ServicesBloc>()..add(ServicesEvent.filterChangedAffiliate(''));
        // FocusScope.of(context).requestFocus(new FocusNode());
        // setState(() {
        //   tbs.text = '';
        // });
      },
      child: Container(
        width: sizeW,
        margin: EdgeInsets.only(bottom: sizeH * 0.01, top: sizeH * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: dataUser['uid'],
              child: Container(
                width: sizeW * 0.3,
                height: sizeW * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProfile.image,
                    fit: BoxFit.fitHeight,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 1.0,
                    ),
                  ],
                ),
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
                            WidgetSpan(
                              child: Container(
                                margin: EdgeInsets.only(left: sizeW * 0.02),
                                child: Text('A $distanciaKm km, ${dataUser['placeSelect']['city']}',style: UbicaStyles().stylePrimary(size: sizeH * 0.018, fontWeight: FontWeight.bold, enumStyle: EnumStyle.light),),
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
            Container(
              margin: EdgeInsets.only(left: sizeW * 0.02),
              child: CircleAvatar(
                radius: sizeH * 0.02,
                backgroundColor: UbicaColors.primary,
                child: Center(
                  child: Icon(Icons.arrow_forward_ios, color: UbicaColors.white,size: sizeH * 0.02,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonFilterTap(){
    return InkWell(
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return ClassDropdownGeneric(valueRes: mapFilter[categoryProvider.filterDistance]!,);
          },
        );
      },
      child: containerImageAssets (sizeH * 0.02, sizeW * 0.02,'icon_filter.png'),
    );
  }
}

class ClassDropdownGeneric extends StatefulWidget {
  const ClassDropdownGeneric({Key? key, required this.valueRes}) : super(key: key);
  final String valueRes;
  @override
  _ClassDropdownGenericState createState() => _ClassDropdownGenericState();
}

class _ClassDropdownGenericState extends State<ClassDropdownGeneric> {
  String valueS = 'Todos';
  final List<String> filterKm = ['Todos','Normal (200 metros)','400 metros','600 metros'];
  Map<String,int> mapFilter =
  {
    'Normal (200 metros)' : 1, '400 metros' : 2, '600 metros' : 3, 'Todos' : 0,
  };

  @override
  void initState() {
    super.initState();
    valueS = widget.valueRes;
  }

  @override
  Widget build(BuildContext context) {

    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: sizeW * 0.9,
          color: UbicaColors.white,
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
                    Text('Filtro',style: UbicaStyles().stylePrimary(size: sizeH * 0.022,fontWeight: FontWeight.bold, enumStyle: EnumStyle.light),),
                  ],
                ),
              ),
              const Divider(color: UbicaColors.colorBEBDBD,height: 2,),
              Container(
                width: sizeW,
                margin: EdgeInsets.only(left: sizeW * 0.06,right: sizeW * 0.06, top: sizeH * 0.02, bottom: sizeH * 0.02),
                child: Text('Utiliza filtros para hacer tu búsqueda más precisa.',style: UbicaStyles().stylePrimary(size: sizeH * 0.018,fontWeight: FontWeight.bold, enumStyle: EnumStyle.light),),
              ),
              Container(
                margin: EdgeInsets.only(left: sizeW * 0.1,right: sizeW * 0.1, bottom: sizeH * 0.03),
                child: DropdownGeneric(
                  sizeH: sizeH,
                  value: valueS,
                  hint: Text('Dintancia',style: UbicaStyles().stylePrimary(size: sizeH * 0.018,fontWeight: FontWeight.bold, enumStyle: EnumStyle.light)),
                  onChanged: (String? value) {
                    setState(() {
                      valueS = value!;
                    });
                  },
                  items: filterKm.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: sizeW * 0.1,right: sizeW * 0.1, bottom: sizeH * 0.02),
                child: ButtonGeneral(
                  title: 'BUSCAR',
                  onPressed: () {
                    categoryProvider.changeFilterDistance = mapFilter[valueS]!;
                    Navigator.of(context).pop();
                  },
                  backgroundColor: UbicaColors.primary,
                  borderColor: UbicaColors.primary,
                  textStyle: UbicaStyles().stylePrimary(size: sizeH * 0.017,color: UbicaColors.white, enumStyle: EnumStyle.semiBold),
                  height: sizeH * 0.045,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
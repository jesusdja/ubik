import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/providers/services_provider.dart';
import 'package:ubik/widgets_utils/circular_progress_colors.dart';
import 'package:ubik/widgets_utils/textfield_general.dart';
import 'package:ubik/widgets_utils/view_image.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key, required this.typeCategory}) : super(key: key);
  final int typeCategory;
  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {

  final List<String> filterKm = ['Normal (200 metros)','400 metros','600 metros'];
  TextEditingController tbs = TextEditingController();
  late ServicesProvider servicesProvider;

  @override
  Widget build(BuildContext context) {

    servicesProvider = Provider.of<ServicesProvider>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: UbicaColors.colorECECEC,
        body: SingleChildScrollView(
          child: Column(
            children: [
              topContainer(),
              pageHome(),
            ],
          ),
        ),
      ),
    );
  }

  Widget topContainer(){
    return Container(
      height: sizeH * 0.15,
      width: sizeW,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(35.0),
          bottomRight: Radius.circular(35.0),
        ),
        image: DecorationImage(
          image: ViewImage().assetsImage('assets/image/home_top.png').image,
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: sizeH * 0.06,
                width: sizeH * 0.06,
                margin: EdgeInsets.only(left: sizeH * 0.01),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ViewImage().assetsImage('assets/image/icon_back_homescreen.png').image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _buttonSearch(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonSearch(){
    return Container(
      margin: EdgeInsets.only(right: sizeW * 0.05, top: sizeH * 0.02, bottom: sizeH * 0.02),
      child: TextFieldGeneral(
        textEditingController: tbs,
        sizeBorder: 1.0,
        radius: 35.0,
        hintText: '¿Qué necesitas?',
        labelStyle: UbicaStyles().stylePrimary(size: sizeH * 0.02, color: UbicaColors.color706864, enumStyle: EnumStyle.light),
        prefixIconConstraints: BoxConstraints.expand(width: sizeH * 0.05, height: sizeH * 0.05),
        suffixIconConstraints: BoxConstraints.expand(width: sizeH * 0.05, height: sizeH * 0.04),
        onChanged: (text){
          setState(() {});
        },
      ),
    );
  }

  Widget pageHome(){

    bool isLoad = widget.typeCategory == 1 ? servicesProvider.loadDataService : servicesProvider.loadDataBusiness;

    return Container(
      width: sizeW,
      height: sizeH * 0.83,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ViewImage().assetsImage('assets/image/Enmascarar.png').image,
          fit: BoxFit.fill,
        ),
      ),
      child: isLoad ?
      Center(
        child: circularProgressColors(colorCircular: UbicaColors.primary,widthContainer1: sizeW, widthContainer2: sizeW * 0.1),
      ) : _listContainer(),
    );
  }

  Widget _listContainer(){

    List<Map<String,dynamic>> listConta = widget.typeCategory == 1 ? servicesProvider.dataServices : servicesProvider.dataBusiness;
    String type = widget.typeCategory == 1 ? 'servicios' : 'comercios';

    return listConta.isEmpty ?
    SizedBox(
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: sizeW * 0.1),
          child: Text('No existen $type cercanos a tu posición actual',
            style: UbicaStyles().stylePrimary(size: sizeH * 0.04, color: UbicaColors.color535353, enumStyle: EnumStyle.regular)
            ,textAlign: TextAlign.center,),
        ),
      ),
    )
        :
    ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: listConta.length,
      itemBuilder: (context, index) {
        if(tbs.text.isNotEmpty && !((listConta[index]['name'] as String).toLowerCase().contains(tbs.text.toLowerCase()))){
          return Container();
        }
        return Card(
          margin: EdgeInsets.only(top: sizeH * 0.015, left: sizeW * 0.03, right: sizeW * 0.03),
          elevation: 10,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: sizeH * 0.012, horizontal: sizeW * 0.05),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Colors.white,
            ),
            child: InkWell(
                onTap: (){
                  // router.Router.navigator.pushNamed(
                  //     router.Router.servicesView,
                  //     arguments: router.ServicesViewArguments(
                  //       title: listConta[index]['name'],
                  //       typeCategory: widget.typeCategory,
                  //       idCategory: listConta[index]['id'],
                  //     ));
                  // context.bloc<ServicesBloc>()..add(ServicesEvent.filterChanged(''));
                  // FocusScope.of(context).requestFocus(new FocusNode());
                  // setState(() {
                  //   tbs.text = '';
                  // });
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(listConta[index]['name'], style: UbicaStyles().stylePrimary(size: sizeH * 0.025, enumStyle: EnumStyle.regular)),
                    ),
                    SizedBox(
                      child: CircleAvatar(
                        radius: sizeH * 0.016,
                        backgroundColor: UbicaColors.primary,
                        child: Center(
                          child: Icon(Icons.arrow_forward_outlined, color: Colors.white,size: sizeH * 0.025,),
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ),
        );
      },
    );
  }
}
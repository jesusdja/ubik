import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/providers/affiliate_user_provider.dart';
import 'package:ubik/widgets_utils/dropdown_button_generic.dart';
import 'package:ubik/widgets_utils/textfield_general.dart';
import 'package:ubik/widgets_utils/toast_widget.dart';

class DataUserCategoryAffiliate extends StatefulWidget {
  const DataUserCategoryAffiliate({Key? key}) : super(key: key);

  @override
  _DataUserCategoryAffiliateState createState() => _DataUserCategoryAffiliateState();
}

class _DataUserCategoryAffiliateState extends State<DataUserCategoryAffiliate> {

  late AffiliateUserProvider affiliateUserProvider;
  List<String> typeCategoryList = ['Servicio' , 'Comercio'];
  String typeCategory = 'Servicio';

  @override
  void initState() {
    super.initState();
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
            child: Text('Descripción',style: style1,textAlign: TextAlign.left,)
          ),
          SizedBox(height: sizeH * 0.03,),
          TextFieldGeneral(
            sizeHeight: sizeH * 0.05,
            maxLines: 5,
            labelStyle: TextStyle(color: UbicaColors.black, fontSize: sizeH * 0.02),
            textInputType: TextInputType.multiline,
            initialValue: affiliateUserProvider.description,
            onChanged: (descrip){
              affiliateUserProvider.changeDescription(value: descrip);
            },
          ),
          SizedBox(height: sizeH * 0.06,),
          SizedBox(
            width: sizeW,
            child: Text('Seleccionar categoria',style:style1,textAlign: TextAlign.left,),
          ),
          SizedBox(height: sizeH * 0.02,),
          _selectedCountries(),
          SizedBox(height: sizeH * 0.06,),
          saveButton(),
        ],
      ),
    );
  }

  Widget _selectedCountries(){

    List<Map<String,dynamic>>? listData = [];
    for (var element in affiliateUserProvider.listCategories) {
      if(typeCategory.contains(typeCategoryList[0]) && element['isService']){
        listData.add(element);
      }
      if(typeCategory.contains(typeCategoryList[1]) && element['isBusiness']){
        listData.add(element);
      }
    }

    return SizedBox(
      width: sizeW,
      child: Column(
        children: [
          SizedBox(
            height: sizeH * 0.065,
            width: sizeW * 0.9,
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownGeneric(
                sizeH: sizeH,
                value: typeCategory,
                hint: Text('',style: UbicaStyles().stylePrimary(size: sizeH * 0.018,fontWeight: FontWeight.bold, enumStyle: EnumStyle.light)),
                onChanged: (String? value) {
                  affiliateUserProvider.changeIdCategory(value: {});
                  setState(() {
                    typeCategory = value!;
                  });
                },
                items: typeCategoryList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: UbicaStyles().stylePrimary(
                            size: sizeH * 0.02,enumStyle: EnumStyle.regular
                        )),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: sizeW * 0.05,),
          listData.isEmpty ? Container() :
          SizedBox(
            height: sizeH * 0.065,
            width: sizeW * 0.9,
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownGenericMap(
                sizeH: sizeH,
                value: affiliateUserProvider.categorySelected.isNotEmpty ? affiliateUserProvider.categorySelected : listData[0],
                hint: Text('',style: UbicaStyles().stylePrimary(size: sizeH * 0.018,fontWeight: FontWeight.bold, enumStyle: EnumStyle.light)),
                onChanged: (Map<String,dynamic>? value) {
                  affiliateUserProvider.changeIdCategory(value: value!);
                },
                items: listData.map<DropdownMenuItem<Map<String,dynamic>>>((Map<String,dynamic> value) {
                  return DropdownMenuItem<Map<String,dynamic>>(
                    value: value,
                    child: Text(value['name'],
                        style: UbicaStyles().stylePrimary(
                            size: sizeH * 0.02,enumStyle: EnumStyle.regular
                        )),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
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
        FocusScope.of(context).requestFocus(FocusNode());

        String errorText = '';
        if(errorText.isEmpty && affiliateUserProvider.description.isEmpty){
          errorText = 'Descripción no puede estar vacio';
        }

        if(affiliateUserProvider.categorySelected.isEmpty){
          List<Map<String,dynamic>>? listData = [];
          for (var element in affiliateUserProvider.listCategories) {
            if(typeCategory.contains(typeCategoryList[0]) && element['isService']){
              listData.add(element);
            }
          }
          if(listData.isEmpty){
            for (var element in affiliateUserProvider.listCategories) {
              if(typeCategory.contains(typeCategoryList[1]) && element['isBusiness']){
                listData.add(element);
              }
            }
          }
          if(listData.isEmpty){
            errorText = 'Debe seleccionar alguna categoría';
          }else{
            affiliateUserProvider.changeIdCategory(value: listData[0]);
          }
        }

        if(errorText.isEmpty){
          try{
            affiliateUserProvider.changePage(value: 2);
          }catch(e){
            showAlert(text: 'Error: ${e.toString()}', isError: true);
          }
        }else{
          showAlert(text: errorText, isError: true);
        }
      },
    );
  }
}

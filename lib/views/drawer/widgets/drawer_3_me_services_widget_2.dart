import 'package:flutter/material.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/main.dart';
import 'package:ubik/widgets_utils/view_image.dart';

class ClassQualifyAffiliate extends StatefulWidget {
  const ClassQualifyAffiliate({Key? key, required this.invoiceAd, required this.type}) : super(key: key);
  final Map<String,dynamic> invoiceAd;
  final int type;
  @override
  _ClassQualifyAffiliateState createState() => _ClassQualifyAffiliateState();
}

class _ClassQualifyAffiliateState extends State<ClassQualifyAffiliate> {
  late Map<String,dynamic> invoiceAd;

  @override
  void initState() {
    super.initState();
    invoiceAd = widget.invoiceAd;
  }

  @override
  Widget build(BuildContext context) {

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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
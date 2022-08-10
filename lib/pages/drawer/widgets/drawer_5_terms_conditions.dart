import 'package:flutter/material.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/widgets_utils/appbar_widgets.dart';
import 'package:ubik/widgets_utils/logo_botton.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({Key? key}) : super(key: key);

  @override
  _TermsConditionsState createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {

  Map<int,int> mapStartIndex = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(sizeH * 0.07),
        child: appBar(),
      ),
      bottomNavigationBar: logoButton2(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: _containerText(),
      ),
    );
  }

  Widget _containerText(){

    double size = sizeH * 0.018;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        width: sizeW,
        margin: const EdgeInsets.all(20),
        child: RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            text: 'El ',
            style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
            children: [
              TextSpan(
                text: 'usuario',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.semiBold),
              ),
              TextSpan(
                text: ' reconoce y acepta que el uso del contenido y/o servicio ofrecido por la presente APP será bajo su exclusivo riesgo y responsabilidad y se  compromete a utilizar la presente aplicación móvil y todo su contenido y servicios en conformidad con la Ley, la moral, el orden público, así mismo se compromete a no emplearlo para la realización de actividades ilícitas o constitutivas de delitos que atenten contra derecho de terceros y/o infrinjan la regulación sobre la propiedad intelectual e industrial, o cualquier otra norma del ordenamiento jurídico; en particular el ',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
              TextSpan(
                text: 'usuario',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.semiBold),
              ),
              TextSpan(
                text: ' se compromete a no transmitir, introducir, difundir, y poner a disposición de tercero cualquier tipo de material e información (datos contenidos, mensajes, dibujos, archivos de sonido e imagen, fotografías, software, etc) que sean contrarios a la ley, la moral, y el orden público y las presentes condiciones de uso.\n\nEl ',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
              TextSpan(
                text: 'usuario',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.semiBold),
              ),
              TextSpan(
                text: ' estará obligado a garantizar la veracidad y exactitud de los datos de registro proporcionados en el formulario de registro de ',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
              TextSpan(
                text: 'Ubi-k.',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.semiBold),
              ),
              TextSpan(
                text: ' En todo caso el ',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
              TextSpan(
                text: 'usuario',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.semiBold),
              ),
              TextSpan(
                text: ' será el único responsable de las manifestaciones falsas o inexactas que realice y de los perjuicios que cause a ',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
              TextSpan(
                text: 'Ubi-k',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.semiBold),
              ),
              TextSpan(
                text: ' o a terceros por la información que facilite al momento de registrarse en la plataforma.\n\n',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
              TextSpan(
                text: 'Aunque proporcionamos determinadas tecnología de seguridad en internet, y hacemos usos de otras precauciones razonables para proteger la información confidencial y ofrecer una seguridad adecuada, no podemos garantizar al ',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
              TextSpan(
                text: 'usuario',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.semiBold),
              ),
              TextSpan(
                text: ' que la información transmitida a través de internet sea segura y que dicha transmisión estén libres de retraso, interrupciones, interceptaciones o errores. Por lo que Ubi-k, se excluye de cualquier responsabilidad por fallos de seguridad en la APP y las consecuencias que de ellos pudieran derivarse.\n\n',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
              TextSpan(
                text: 'Ubi-k',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.semiBold),
              ),
              TextSpan(
                text: ' podrá suspender o denegar el acceso al ',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
              TextSpan(
                text: 'usuario',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.semiBold),
              ),
              TextSpan(
                text: ' por incumplimiento de los términos y condiciones del uso de la App  o por cualquier motivo que lo amerite sin previo aviso.',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget appBar(){
    return appBarIcon(
        backgroundColor: UbicaColors.white,
        styleTitle: UbicaStyles().stylePrimary(size: sizeH * 0.025, color: UbicaColors.primary,enumStyle: EnumStyle.regular),
        title: 'Términos y condiciones',
        elevation: 10.0,
        context: context
    );
  }

}

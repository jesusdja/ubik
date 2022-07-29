import 'package:flutter/material.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';
import 'package:ubik/main.dart';
import 'package:ubik/widgets_utils/appbar_widgets.dart';
import 'package:ubik/widgets_utils/logo_botton.dart';

class PoliciesPrivacy extends StatefulWidget {
  const PoliciesPrivacy({Key? key}) : super(key: key);

  @override
  _PoliciesPrivacyState createState() => _PoliciesPrivacyState();
}

class _PoliciesPrivacyState extends State<PoliciesPrivacy> {
  Map<int,int> mapStartIndex = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarIcon(
        backgroundColor: UbicaColors.white,
        styleTitle: UbicaStyles().stylePrimary(size: sizeH * 0.025, color: UbicaColors.primary,enumStyle: EnumStyle.regular),
        title: 'Politicas de privacidad',
        elevation: 10.0,
        context: context
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
            text: 'AVISO DE PRIVACIDAD, GENERALES DE ACCESO Y USO DE UBI-K PARA USUARIOS.',
            style: UbicaStyles().stylePrimary(size: size,enumStyle: EnumStyle.semiBold),
            children: [
              TextSpan(
                text: ' LEA ESTAS CONDICIONES DETENIDAMENTE ANTES DE ACCEDER A LA APLICACIÓN DE ',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
              TextSpan(
                text: 'UBI-K',
                style: UbicaStyles().stylePrimary(size: size,enumStyle: EnumStyle.semiBold),
              ),
              TextSpan(
                text: ', YA QUE SÓLO SU CONSENTIMIENTO LE DARÁ ACCESO A SU USO.\nLos presentes términos y condiciones tienen por objeto establecer y regular el acceso general a la Aplicación ',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
              TextSpan(
                text: 'UBI-K',
                style: UbicaStyles().stylePrimary(size: size,enumStyle: EnumStyle.semiBold),
              ),
              TextSpan(
                text: ', su contenido, así como regular el acceso o uso que usted haga, como ',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
              TextSpan(
                text: 'usuario',
                style: UbicaStyles().stylePrimary(size: size,enumStyle: EnumStyle.semiBold),
              ),
              TextSpan(
                text: ', contenidos puestos a disposición por ',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
              TextSpan(
                text: 'Ubi-k, C.A',
                style: UbicaStyles().stylePrimary(size: size,enumStyle: EnumStyle.semiBold),
              ),
              TextSpan(
                text: ', debidamente inscrita por ante el Registro Mercantil Primero del Estado Bolívar, en fecha dos (02) de julio del 2020, quedando insertado bajo el Nro. 149, Tomo 4-A- REGMERPRIBO, con última modificación debidamente inscrita por ante el Registro Mercantil Primero del Estado Bolívar, en fecha ocho (08) de septiembre del 2020, quedando insertado bajo el Nro. 137, Tomo 5-A- REGMERPRIBO.\n\n',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
              TextSpan(
                text: 'Ubi-k',
                style: UbicaStyles().stylePrimary(size: size,enumStyle: EnumStyle.semiBold),
              ),
              TextSpan(
                text: ' es legítima propietaria de la marca, software Y APP ',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
              TextSpan(
                text: 'Ubi-k',
                style: UbicaStyles().stylePrimary(size: size,enumStyle: EnumStyle.semiBold),
              ),
              TextSpan(
                text: ', a través del cual pone a disposición al ',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
              TextSpan(
                text: 'usuario',
                style: UbicaStyles().stylePrimary(size: size,enumStyle: EnumStyle.semiBold),
              ),
              TextSpan(
                text: ', para ubicación de Servicios, comercios y emprendedores por medio de sistema de geolocalización prioriza los más cerca de su búsqueda, pudiendo contactarlos directamente ya que nuestra App le muestra números telefónicos, redes sociales,  fotos, perfil y calificación de servicios anteriores. También le muestra mapa con la ubicación  y distancia del proveedor. Logrando ahorrar tiempo y dinero, tiempo porque resuelve  rápido su necesidad  y dinero porque ahora tiene muchos proveedores disponibles  para que solicite presupuesto y elegir tu mejor opción.\n\n',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
              TextSpan(
                text: 'Ubi-k',
                style: UbicaStyles().stylePrimary(size: size,enumStyle: EnumStyle.semiBold),
              ),
              TextSpan(
                text: ' no será responsable  directa, indirecta ni subsidiariamente de daños y perjuicios de cualquier naturaleza derivada de la utilización de los servicios y contenidos de la aplicación por parte del ',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
              TextSpan(
                text: 'usuario.\nUbi-k',
                style: UbicaStyles().stylePrimary(size: size,enumStyle: EnumStyle.semiBold),
              ),
              TextSpan(
                text: ' se encarga única y exclusivamente de publicación de servicios, comercios y productos, cobrando una afiliación mensual. Dándole el derecho de ser elegibles en la APP cuando el usuario realice la búsqueda, siendo estos proveedores independientes, cobrando sus servicios y producto directamente al usuario.',
                style: UbicaStyles().stylePrimary(size: size, enumStyle: EnumStyle.regular),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

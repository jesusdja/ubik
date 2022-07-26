import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/config/ubik_style.dart';


Future<bool> alertClosetSession(BuildContext context) async{
  Size size = MediaQuery.of(context).size;
  bool res = await showDialog(
      context: context,
      builder: ( context ) {
        return AlertDialog(
          title: const Text(''),
          content: Text('¿Estas seguro que quieres cerrar la sesión?',textAlign: TextAlign.center,
            style: UbikStyles().stylePrimary(size: size.height * 0.025, color: UbicaColors.primary),),
          actions: <Widget>[
            CupertinoButton(
              child: Text('Ok',
                style: UbikStyles().stylePrimary(size: size.height * 0.02, color: UbicaColors.primary,fontWeight: FontWeight.bold),),
              onPressed: ()  {
                Navigator.of(context).pop(true);
              },
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
            CupertinoButton(
              child: Text('Cancelar',
                style: UbikStyles().stylePrimary(size: size.height * 0.02, color: UbicaColors.primary,fontWeight: FontWeight.bold),),
              onPressed: (){
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      }
  );
  return res;
}

Future<bool?> alertDeleteVideo(BuildContext context) async{
  Size size = MediaQuery.of(context).size;
  bool res = await showDialog(
      context: context,
      builder: ( context ) {
        return AlertDialog(
          title: const Text(''),
          content: Text('¿Estas seguro que quieres borrar el video?',textAlign: TextAlign.center,
            style: UbikStyles().stylePrimary(size: size.height * 0.025, color: UbicaColors.primary),),
          actions: <Widget>[
            CupertinoButton(
              child: Text('Si',
                style: UbikStyles().stylePrimary(size: size.height * 0.02, color: UbicaColors.primary,fontWeight: FontWeight.bold),),
              onPressed: ()  {
                Navigator.of(context).pop(true);
              },
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
            CupertinoButton(
              child: Text('No',
                style: UbikStyles().stylePrimary(size: size.height * 0.02, color: UbicaColors.primary,fontWeight: FontWeight.bold),),
              onPressed: (){
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      }
  );
  return res;
}
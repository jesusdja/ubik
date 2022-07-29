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
            style: UbicaStyles().stylePrimary(size: size.height * 0.025, color: UbicaColors.primary),),
          actions: <Widget>[
            CupertinoButton(
              child: Text('Ok',
                style: UbicaStyles().stylePrimary(size: size.height * 0.02, color: UbicaColors.primary,fontWeight: FontWeight.bold),),
              onPressed: ()  {
                Navigator.of(context).pop(true);
              },
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
            CupertinoButton(
              child: Text('Cancelar',
                style: UbicaStyles().stylePrimary(size: size.height * 0.02, color: UbicaColors.primary,fontWeight: FontWeight.bold),),
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
            style: UbicaStyles().stylePrimary(size: size.height * 0.025, color: UbicaColors.primary),),
          actions: <Widget>[
            CupertinoButton(
              child: Text('Si',
                style: UbicaStyles().stylePrimary(size: size.height * 0.02, color: UbicaColors.primary,fontWeight: FontWeight.bold),),
              onPressed: ()  {
                Navigator.of(context).pop(true);
              },
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
            CupertinoButton(
              child: Text('No',
                style: UbicaStyles().stylePrimary(size: size.height * 0.02, color: UbicaColors.primary,fontWeight: FontWeight.bold),),
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

void showUbicaDialog({ required BuildContext context, required Widget child,}) {
  showGeneralDialog<dynamic>(
    context: context,
    pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: UbicaColors.black.withOpacity(0.05),
          body: Builder(
            builder: (BuildContext context) => child,
          ),
        ),
      );
    },
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: UbicaColors.black.withOpacity(0.6),
    transitionDuration: const Duration(milliseconds: 150),
    useRootNavigator: true,
    transitionBuilder: _buildMaterialDialogTransitions,
  );
}

Widget _buildMaterialDialogTransitions(
    BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}
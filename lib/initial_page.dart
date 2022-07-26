import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ubik/pages/login/login_page.dart';
import 'package:ubik/providers/auth_provider.dart';
import 'package:ubik/widgets_utils/circular_progress_colors.dart';

import 'main.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {

    sizeH = MediaQuery.of(context).size.height;
    sizeW = MediaQuery.of(context).size.width;

    final authProvider = Provider.of<AuthProvider>(context);

    if ( authProvider.authStatus == AuthStatus.checking ) {
      return const Scaffold(body: SizedBox(child: Center(child: Text('checking')),),);
    }
    if( authProvider.authStatus == AuthStatus.login ) {
      return const LoginPage();
    }
    if( authProvider.authStatus == AuthStatus.home ) {
      return const Scaffold(body: SizedBox(child: Center(child: Text('home')),),);
    }
    return const BasicSplash();
  }
}

class BasicSplash extends StatelessWidget {
  const BasicSplash({Key? key}) : super(key: key);

  Future<bool> exit() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        child: Scaffold(
          body: circularProgressColors(widthContainer1: sizeW,widthContainer2: sizeH * 0.03,),
        ),
        onWillPop: exit
    );
  }
}

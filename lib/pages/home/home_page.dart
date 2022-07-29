import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ubik/initial_page.dart';
import 'package:ubik/services/finish_app.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoButton(
          onPressed: () async {
            await finishApp();
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context2) => const InitialPage()));
          },
          child: Text('Salir'),
        ),
      ),
    );
  }
}

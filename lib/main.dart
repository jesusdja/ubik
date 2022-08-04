import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubik/initial_page.dart';
import 'package:ubik/providers/affiliate_user_provider.dart';
import 'package:ubik/providers/auth_provider.dart';
import 'package:ubik/providers/home_provider.dart';
import 'package:ubik/providers/services_provider.dart';
import 'package:ubik/providers/user_provider.dart';
import 'package:ubik/services/sharedprefereces.dart';

double sizeH = 0;
double sizeW = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  await Firebase.initializeApp();
  await SharedPrefs.configurePrefs();

  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false,create: ( _ ) => AuthProvider()),
        ChangeNotifierProvider(lazy: false,create: ( _ ) => UserProvider()),
        ChangeNotifierProvider(lazy: false,create: ( _ ) => HomeProvider()),
        ChangeNotifierProvider(lazy: false,create: ( _ ) => ServicesProvider()),
        ChangeNotifierProvider(lazy: false,create: ( _ ) => AffiliateUserProvider()),
      ],
      child: const MyApp(),
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ubi-k',
      home: const InitialPage(),
      theme: ThemeData.light().copyWith(
          scrollbarTheme: const ScrollbarThemeData().copyWith(
              thumbColor: MaterialStateProperty.all(
                  Colors.grey.withOpacity(0.5)
              )
          )
      ),
    );
  }
}

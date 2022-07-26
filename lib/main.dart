import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubik/providers/auth_provider.dart';
import 'package:ubik/services/sharedprefereces.dart';

double sizeH = 0;
double sizeW = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
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
      builder: ( _ , child ){
        final authProvider = Provider.of<AuthProvider>(context);

        if ( authProvider.authStatus == AuthStatus.checking ) {
          return const Scaffold(body: SizedBox(child: Center(child: Text('checking')),),);
        }
        if( authProvider.authStatus == AuthStatus.login ) {
          return const Scaffold(body: SizedBox(child: Center(child: Text('login')),),);
        }
        if( authProvider.authStatus == AuthStatus.home ) {
          return const Scaffold(body: SizedBox(child: Center(child: Text('home')),),);
        }
        return const Scaffold(body: SizedBox(child: Center(child: Text('checking')),),);
      },
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

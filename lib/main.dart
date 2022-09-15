import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validator_form_dialog/screens/check_auth_screen.dart';
import 'package:validator_form_dialog/screens/screens.dart';
import 'package:validator_form_dialog/services/notifications_services.dart';
import 'package:validator_form_dialog/services/product_services.dart';

import 'services/auth_services.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsServices()),
        ChangeNotifierProvider(create: (_) => AuthServices()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //scaffoldMessengerKey es una propiedad estatica, por lo tanto no hace falta instanciarla
        scaffoldMessengerKey: NotificationsSerices.messengerKey,
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.grey[300],
            appBarTheme: const AppBarTheme(backgroundColor: Colors.indigo),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.indigo, elevation: 0)),
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login': (_) {
            return LoginScreen();
          },
          'home': (_) {
            return HomeScreen();
          },
          'product': (_) {
            return ProductScreen();
          },
          'register': ((context) {
            return RegisterScreen();
          }),
          'checking': (context) {
            return CheckAuthScreen();
          }
        });
  }
}

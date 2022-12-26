// ignore_for_file: prefer_const_constructors

import 'package:bar2_banzeen/screens/login.dart';
import 'screens/messaging.dart';
import 'package:flutter/material.dart';

import 'app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRouter().generateRoute,
      // initialRoute: LoginPage.routeName,
      initialRoute: MessagingScreen.routeName,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          //centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF29292A),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 18.0,
            fontWeight: FontWeight.w900,
            color: Color(0xffc63432),
          ),
          button: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12.0,
          ),
        ),
        backgroundColor: Color(0xffeeeff1),
        primaryColor: Color(0xffc63432),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Color(0xffd59727)),
      ),
    );
  }
}

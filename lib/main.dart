import 'package:bar2_banzeen/screens/main_page.dart';
import 'package:bar2_banzeen/screens/login_screen.dart';
import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>(
          create: (_) => AuthenticationService().onAuthStateChanged,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        onGenerateRoute: AppRouter().generateRoute,
        initialRoute: LoginScreen.routeName,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Color(0xffc63432),
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          textTheme: const TextTheme(
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
          backgroundColor: const Color(0xffeeeff1),
          primaryColor: const Color(0xffc63432),
          accentColor: const Color(0xffd59727),
        ),
      ),
    );
  }
}

import 'package:bar2_banzeen/components/theme.dart';
import 'package:bar2_banzeen/screens/editProfile.dart';

import 'package:bar2_banzeen/screens/main_page.dart';

import 'package:bar2_banzeen/screens/login_screen.dart';

import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:bar2_banzeen/widgets/wrapper.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;
  void initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (err) {
      setState(() {
        _error = true;
      });
    }
  }

  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    appTheme.addListener(() {
      //👈 this is to notify the app that the theme has changed
      setState(
          () {}); //👈 this is to force a rerender so that the changes are carried out
    });
    initializeFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>(
            create: (_) => AuthenticationService().onAuthStateChanged,
            initialData: null)
      ],
      child: MaterialApp(
        onGenerateRoute: AppRouter().generateRoute,
        initialRoute: LoginScreen.routeName,
        // initialRoute: EditProfile.routeName,
        themeMode: appTheme.themeMode, //👈 this is the themeMode defined in the AppTheme class
        darkTheme: darkTheme,          //👈 this is the darkTheme that we defined in the theme.dart file

        theme: lightTheme,
      ),
    );
  }
}

import 'package:bar2_banzeen/components/theme.dart';
import 'package:bar2_banzeen/screens/edit_profile_screen.dart';
import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:bar2_banzeen/services/users_service.dart';
import 'package:bar2_banzeen/widgets/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    appTheme.addListener(() {
      //👈 this is to notify the app that the theme has changed
      setState(
          () {}); //👈 this is to force a rerender so that the changes are carried out
    });
  }

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
        initialRoute: Wrapper.routeName,
        themeMode: appTheme
            .themeMode, //👈 this is the themeMode defined in the AppTheme class
        darkTheme:
            darkTheme, //👈 this is the darkTheme that we defined in the theme.dart file
        theme: lightTheme,
      ),
    );
  }
}

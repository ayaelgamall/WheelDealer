import 'package:bar2_banzeen/components/theme.dart';
import 'package:bar2_banzeen/screens/main_page.dart';
import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

import 'package:go_router/go_router.dart';
import 'package:bar2_banzeen/screens/car_screen.dart';
import 'package:bar2_banzeen/screens/favourites_screen.dart';
import 'package:bar2_banzeen/screens/messages_screen.dart';
import 'package:bar2_banzeen/screens/notifications_screen.dart';
import 'package:bar2_banzeen/screens/selected_tab_screen.dart';
import 'package:bar2_banzeen/screens/sell_car_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');
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
  final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/mainPage',
    routes: <RouteBase>[
      /// Application shell
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return SelectedTab(child: child);
        },
        routes: <RouteBase>[
          /// The first screen to display in the bottom navigation bar.
          GoRoute(
            path: '/mainPage',
            builder: (BuildContext context, GoRouterState state) {
              return const MainPage();
            },
            routes: <RouteBase>[
              // The details screen to display stacked on the inner Navigator.
              // This will cover MainScreen but not the application shell.
              GoRoute(
                path: 'car',
                builder: (BuildContext context, GoRouterState state) {
                  return const CarInfo();
                },
              ),
            ],
          ),

          /// Displayed when favourites item in the the bottom navigation bar is
          /// selected.
          GoRoute(
            path: '/favourites',
            builder: (BuildContext context, GoRouterState state) {
              return const Favourites();
            },
            // routes: <RouteBase>[
            //   /// Same as "/a/details", but displayed on the root Navigator by
            //   /// specifying [parentNavigatorKey]. This will cover both screen B
            //   /// and the application shell.
            //   GoRoute(
            //     path: 'details',
            //     parentNavigatorKey: _rootNavigatorKey,
            //     builder: (BuildContext context, GoRouterState state) {
            //       return const DetailsScreen(label: 'B');
            //     },
            //   ),
            // ],
          ),

          /// The Sell Car screen to display in the bottom navigation bar.
          GoRoute(
            path: '/sellCar',
            builder: (BuildContext context, GoRouterState state) {
              return const SellCarScreen();
            },
            // routes: <RouteBase>[
            //   // The details screen to display stacked on the inner Navigator.
            //   // This will cover screen A but not the application shell.
            //   GoRoute(
            //     path: 'details',
            //     builder: (BuildContext context, GoRouterState state) {
            //       return const DetailsScreen(label: 'C');
            //     },
            //   ),
            // ],
          ),
          GoRoute(
            path: '/notifications',
            builder: (BuildContext context, GoRouterState state) {
              return const Notifications();
            },
            // routes: <RouteBase>[
            //   // The details screen to display stacked on the inner Navigator.
            //   // This will cover screen A but not the application shell.
            //   GoRoute(
            //     path: 'details',
            //     builder: (BuildContext context, GoRouterState state) {
            //       return const DetailsScreen(label: 'C');
            //     },
            //   ),
            // ],
          ),
          GoRoute(
            path: '/profile',
            builder: (BuildContext context, GoRouterState state) {
              return const MessagingScreen();
            },
            // routes: <RouteBase>[
            //   // The details screen to display stacked on the inner Navigator.
            //   // This will cover screen A but not the application shell.
            //   GoRoute(
            //     path: 'details',
            //     builder: (BuildContext context, GoRouterState state) {
            //       return const DetailsScreen(label: 'C');
            //     },
            //   ),
            // ],
          ),
        ],
      ),
    ],
  );

  //tabs for bottom nav
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
      child: MaterialApp.router(
        routerConfig: router,
        themeMode: appTheme
            .themeMode, //👈 this is the themeMode defined in the AppTheme class
        darkTheme:
            darkTheme, //👈 this is the darkTheme that we defined in the theme.dart file
        theme: lightTheme,
      ),
    );
  }
}

import 'package:bar2_banzeen/components/theme.dart';
import 'package:bar2_banzeen/prefrences/DarkThemePrefrence.dart';
import 'package:bar2_banzeen/screens/chat_screen.dart';
import 'package:bar2_banzeen/screens/dummy.dart';
import 'package:bar2_banzeen/screens/edit_profile_screen.dart';
import 'package:bar2_banzeen/screens/explore_page.dart';
import 'package:bar2_banzeen/screens/favourite_cars_screen.dart';
import 'package:bar2_banzeen/screens/get_started_screen.dart';
import 'package:bar2_banzeen/screens/login_screen.dart';
import 'package:bar2_banzeen/screens/main_page.dart';
import 'package:bar2_banzeen/screens/settings_screen.dart';
import 'package:bar2_banzeen/screens/user_profile_screen.dart';
import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:bar2_banzeen/widgets/drawer.dart';
import 'package:bar2_banzeen/widgets/profile_avatar.dart';
import 'package:bar2_banzeen/services/users_service.dart';
import 'package:bar2_banzeen/widgets/search_bar.dart';
import 'package:bar2_banzeen/widgets/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

import 'package:go_router/go_router.dart';
import 'package:bar2_banzeen/screens/car_screen.dart';
import 'package:bar2_banzeen/screens/messages_screen.dart';
import 'package:bar2_banzeen/screens/notifications_screen.dart';
import 'package:bar2_banzeen/screens/selected_tab_screen.dart';
import 'package:bar2_banzeen/screens/sell_car_screen.dart';

import 'models/car.dart';

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
    initialLocation: "/",
    routes: <RouteBase>[
      /// Application shell
      GoRoute(
          path: "/",
          builder: (BuildContext context, GoRouterState state) {
            return const GetStarted();
          }),
      GoRoute(
        path: "/wrapper",
        builder: (BuildContext context, GoRouterState state) {
          return const Wrapper();
        },
      ),
      GoRoute(
          path: "/chat/:userId/:chatId",
          builder: (BuildContext context, GoRouterState state) {
            // return MyWidget();
            return ChatScreen(
                toUserId: state.params['userId']!,
                chatId: state.params['chatId']!);
          }),
      // GoRoute(
      //     path: "/editProfile",
      //     builder: (BuildContext context, GoRouterState state) {
      //       // return MyWidget();
      //       return const EditProfile();
      //     }),
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
                path: 'messages',
                builder: (BuildContext context, GoRouterState state) {
                  return const MessagingScreen();
                },
              ),
              GoRoute(
                path: 'car',
                builder: (BuildContext context, GoRouterState state) {
                  Map<String, Object?> extra =
                      state.extra as Map<String, Object?>;
                  Car car = extra['car'] as Car;
                  int? value = extra['bid'] as int?;
                  return CarPage(car: car, topBid: value);
                },
              ),
              GoRoute(
                  path: 'settings',
                  builder: (BuildContext context, GoRouterState state) {
                    return Settings();
                  },
                  routes: [
                    GoRoute(
                      path: 'editProfile',
                      builder: (BuildContext context, GoRouterState state) {
                        return const EditProfile();
                      },
                    ),
                  ]),
              GoRoute(
                path: 'messages',
                builder: (BuildContext context, GoRouterState state) {
                  return const MessagingScreen();
                },
              ),
              GoRoute(
                path: 'explore',
                builder: (BuildContext context, GoRouterState state) {
                  Map<String, Object?> extra =
                      state.extra as Map<String, Object?>;
                  String sort = extra['sort'] as String;
                  bool desc = extra['desc'] as bool;
                  return
                      // sort!=null && desc!=null?
                      ExplorePage(
                    sortBy: sort,
                    desc: desc,
                    filters: {},
                  );
                  // :sort!=null ?
                  // ExplorePage(sortBy: sort):
                  //  ExplorePage();
                  // return showSearch(context: context, delegate: CustomSearchDelegate());
                },
              ),
            ],
          ),

          /// Displayed when favourites item in the the bottom navigation bar is
          /// selected.
          GoRoute(
            path: '/favourites',
            builder: (BuildContext context, GoRouterState state) {
              return FavouriteCarsScreen();
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'explore',
                builder: (BuildContext context, GoRouterState state) {
                  Map<String, Object?> extra =
                      state.extra as Map<String, Object?>;
                  String sort = extra['sort'] as String;
                  bool desc = extra['desc'] as bool;
                  return
                      // sort!=null && desc!=null?
                      ExplorePage(
                    sortBy: sort,
                    desc: desc,
                    filters: {},
                  );
                  // return showSearch(context: context, delegate: CustomSearchDelegate());
                },
              ),
              GoRoute(
                path: 'car',
                builder: (BuildContext context, GoRouterState state) {
                  Map<String, Object?> extra =
                      state.extra as Map<String, Object?>;
                  Car car = extra['car'] as Car;
                  int? value = extra['bid'] as int?;
                  return CarPage(car: car, topBid: value);
                },
              ),
              GoRoute(
                  path: 'settings',
                  builder: (BuildContext context, GoRouterState state) {
                    return Settings();
                  },
                  routes: [
                    GoRoute(
                      path: 'editProfile',
                      builder: (BuildContext context, GoRouterState state) {
                        return const EditProfile();
                      },
                    ),
                  ]),
              GoRoute(
                path: 'messages',
                builder: (BuildContext context, GoRouterState state) {
                  return const MessagingScreen();
                },
              ),
            ],
          ),

          /// The Sell Car screen to display in the bottom navigation bar.
          GoRoute(
            path: '/sellCar',
            builder: (BuildContext context, GoRouterState state) {
              return SellCarScreen(); //TODO REMOVE DUMMY
              // return  SellCarScreen(carId: "3EQL9bSGFwnUtlNaq24h",); //TODO REMOVE DUMMY
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'explore',
                builder: (BuildContext context, GoRouterState state) {
                  Map<String, Object?> extra =
                      state.extra as Map<String, Object?>;
                  String sort = extra['sort'] as String;
                  bool desc = extra['desc'] as bool;
                  return
                      // sort!=null && desc!=null?
                      ExplorePage(
                    sortBy: sort,
                    desc: desc,
                    filters: {},
                  );
                  // return const ExplorePage();
                  // return showSearch(context: context, delegate: CustomSearchDelegate());
                },
              ),
              GoRoute(
                path: 'messages',
                builder: (BuildContext context, GoRouterState state) {
                  return const MessagingScreen();
                },
              ),
              GoRoute(
                  path: 'settings',
                  builder: (BuildContext context, GoRouterState state) {
                    return Settings();
                  },
                  routes: [
                    GoRoute(
                      path: 'editProfile',
                      builder: (BuildContext context, GoRouterState state) {
                        return const EditProfile();
                      },
                    ),
                  ]),
            ],
          ),
          GoRoute(
            path: '/notifications',
            builder: (BuildContext context, GoRouterState state) {
              return const Notifications();
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'explore',
                builder: (BuildContext context, GoRouterState state) {
                  Map<String, Object?> extra =
                      state.extra as Map<String, Object?>;
                  String sort = extra['sort'] as String;
                  bool desc = extra['desc'] as bool;
                  return
                      // sort!=null && desc!=null?
                      ExplorePage(
                    sortBy: sort,
                    desc: desc,
                    filters: {},
                  );
                  // return showSearch(context: context, delegate: CustomSearchDelegate());
                },
              ),
              GoRoute(
                  path: 'settings',
                  builder: (BuildContext context, GoRouterState state) {
                    return Settings();
                  },
                  routes: [
                    GoRoute(
                      path: 'editProfile',
                      builder: (BuildContext context, GoRouterState state) {
                        return const EditProfile();
                      },
                    ),
                  ]),
              GoRoute(
                path: 'messages',
                builder: (BuildContext context, GoRouterState state) {
                  return const MessagingScreen();
                },
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            builder: (BuildContext context, GoRouterState state) {
              return const UserProfile();
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'car',
                builder: (BuildContext context, GoRouterState state) {
                  Map<String, Object?> extra =
                      state.extra as Map<String, Object?>;
                  Car car = extra['car'] as Car;
                  int? value = extra['bid'] as int?;
                  return CarPage(car: car, topBid: value);
                },
              ),
              GoRoute(
                path: 'editPost/:carId',
                builder: (context, state) {
                  return SellCarScreen(carId: state.params['carId']);
                },
              ),
              GoRoute(
                path: 'explore',
                builder: (BuildContext context, GoRouterState state) {
                  Map<String, Object?> extra =
                      state.extra as Map<String, Object?>;
                  String sort = extra['sort'] as String;
                  bool desc = extra['desc'] as bool;
                  return
                      // sort!=null && desc!=null?
                      ExplorePage(
                    sortBy: sort,
                    desc: desc,
                    filters: {},
                  );
                  // return showSearch(context: context, delegate: CustomSearchDelegate());
                },
              ),
              GoRoute(
                path: 'editProfile',
                builder: (BuildContext context, GoRouterState state) {
                  return const EditProfile();
                },
              ),
              GoRoute(
                path: 'messages',
                builder: (BuildContext context, GoRouterState state) {
                  return const MessagingScreen();
                },
              ),
              GoRoute(
                  path: 'settings',
                  builder: (BuildContext context, GoRouterState state) {
                    return Settings();
                  },
                  routes: [
                    GoRoute(
                      path: 'editProfile',
                      builder: (BuildContext context, GoRouterState state) {
                        return const EditProfile();
                      },
                    ),
                  ]),
            ],
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

  DarkThemePreference preference = DarkThemePreference();
  void initialThemeMode() async {
    appTheme.isDarkTheme = await preference.getTheme();
  }

  @override
  initState() {
    super.initState();
    appTheme.addListener(() {
      initialThemeMode();

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

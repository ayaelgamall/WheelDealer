import 'package:flutter/material.dart';

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,

  primarySwatch: createMaterialColor(const Color(
      0xff00ABB3)), //👈 this is the primary color that stuff like the AppBar and FloatingActionButton Widget will default to
  backgroundColor: const Color(0xFFEAEAEA),
  scaffoldBackgroundColor: const Color(0xFFEAEAEA),
  buttonTheme: const ButtonThemeData(buttonColor: Color(0xff00ABB3)),
  textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xff3C4048)),
      bodyLarge: TextStyle(color: Color(0xff00ABB3))
      // headlineMedium: TextStyle(color: Colors.white, fontSize: 25)
      ),
  primaryColor: const Color(0xffB2B2B2),
  // Color.fromARGB(255, 183, 147, 0)
  unselectedWidgetColor: const Color(0xffcccccc),
  disabledColor: const Color(0xffcccccc),

  highlightColor: const Color(0xffFCE192),
  cardColor: const Color(0xffB2B2B2),
  canvasColor: const Color(0xFFEAEAEA),
  appBarTheme: const AppBarTheme(
    elevation: 0.0,
  ),
);

ThemeData darkTheme = ThemeData(
  primarySwatch: createMaterialColor(const Color(0xff22A39F)),
  brightness: Brightness.dark,

  backgroundColor: const Color(0xFF222222),
  scaffoldBackgroundColor: const Color(0xFF222222),

  buttonTheme: const ButtonThemeData(buttonColor: Color(0xff22A39F)),
  primaryTextTheme: Typography().white,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xff00ABB3)),
    bodyMedium: TextStyle(color: Colors.white),
  ),
  hintColor: const Color(0xAFF3EFE0),

//   textTheme: const TextTheme(
//     bodyText1: TextStyle(color: Color(0xffF3EFE0)),
//     bodyText2: TextStyle(color: Color(0xffF3EFE0)),
//     // bodyMedium: TextStyle(color: Color(0xffF3EFE0)),
// // headlineMedium: TextStyle(color: Colors.white, fontSize: 25)
//   ),

  primaryColor: const Color(0xff434242),
// Color.fromARGB(255, 183, 147, 0)
  unselectedWidgetColor: const Color(0xff434242),
  disabledColor: const Color(0xff434242),
  hoverColor: Color(0xff22A39F),
  // accentColor: kYellow,
  // primaryIconTheme: ,
  iconTheme: const IconThemeData(color: Colors.white),
  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffF3EFE0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff22A39F)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffff0000)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffff0000)),
    ),
  ),
  highlightColor: const Color(0xff372901),
  textSelectionTheme:
      const TextSelectionThemeData(selectionColor: Colors.white),
  cardColor: const Color(0xff434242),
  canvasColor: const Color(0xFF222222),
  // buttonTheme: Theme.of(context).buttonTheme.copyWith(
  //     colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
  appBarTheme: const AppBarTheme(
    elevation: 0.0,
  ), //todo change
);

class AppTheme with ChangeNotifier {
  bool isDarkTheme =
      true; // TODO persist this make use of a storage library to store its value. I suggest get_storage

  ThemeMode get themeMode => isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}

AppTheme appTheme = AppTheme();

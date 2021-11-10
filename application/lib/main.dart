import 'package:flutter/material.dart';

import 'MainPage.dart';
import './HomePage.dart';

void main() => runApp(new ExampleApplication());

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme(
          primary: Colors.green,
          onPrimary: Colors.white,
          primaryVariant: Colors.green,

          secondary: Colors.lightGreen,
          onSecondary: Colors.white,
          secondaryVariant: Colors.lightGreen,

          background: Colors.white,
          onBackground: Colors.black,

          error: Colors.red,
          onError: Colors.white,

          surface: Colors.white,
          onSurface: Colors.black,

          brightness: Brightness.light,
        )),
        home: MainPage()
        );
       
  }
}

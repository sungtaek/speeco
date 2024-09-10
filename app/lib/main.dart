import 'package:flutter/material.dart';

import 'pages/home.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speeco',
      theme: ThemeData(
        fontFamily: 'OpenSans',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      initialRoute: "/home",
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        "/home": (BuildContext context) => HomePage(),
      }
    );
  }
}

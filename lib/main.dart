import 'package:flutter/material.dart';
import 'screens/homepage.dart';

void main() {
  runApp(BoringApp());
}

class BoringApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // primary #e53935
        // light #ff6f60
        // dark #ab000d
        // text #fafafa
        primaryColor: Color(0xffe53935),
        primaryColorLight: Color(0xffff6f60),
        primaryColorDark: Color(0xffab000d),
        accentColor: Color(0xffffc947),


        // secondary #ff9800
        // light #ffc947
        // dark #c66900
        // text #3e2723


        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}



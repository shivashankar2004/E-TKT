import 'package:flutter/material.dart';
import 'package:flutter_frontend/login.dart';
import 'package:flutter_frontend/signup.dart';
import 'package:flutter_frontend/homepage.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
        routes: {
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
    
          /*'/pref1':(context) => Preference1(),
        '/pref2':(context) => Preference2(),
        '/mainpage':(context) => MainMusicPage(),
        '/settings':(context) => SettingsPage(),*/
        });
  }
}

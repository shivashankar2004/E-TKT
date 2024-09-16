// ignore_for_file: depend_on_referenced_packages, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_frontend/adm-login.dart';
import 'package:flutter_frontend/login.dart';
import 'package:flutter_frontend/signup.dart';
import 'package:flutter_frontend/dummy.dart';


void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AdminLoginPage(),
        routes: {
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          '/dummy': (context) => MyHomePage(),
          '/adm-login':(context)=>AdminLoginPage()
          /*'/pref1':(context) => Preference1(),
        '/pref2':(context) => Preference2(),
        '/mainpage':(context) => MainMusicPage(),
        '/settings':(context) => SettingsPage(),*/
        });
  }
}

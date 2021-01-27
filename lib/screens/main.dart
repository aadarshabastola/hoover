import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hoover/dataprovider/appdata.dart';
import 'package:hoover/globalVariables.dart';
import 'package:hoover/screens/loginscreen.dart';
import 'package:hoover/screens/mainpage.dart';
import 'dart:io';

import 'package:hoover/screens/registrationpage.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS
        ? FirebaseOptions(
            appId: '1:192536061178:ios:592fd63472588499c75543',
            apiKey: 'AIzaSyCwN40u4S-ptB-0clf67AZIKAzRmYgQ8aY',
            projectId: 'hoover-8274a', //fhoover
            messagingSenderId: '192536061178',
            databaseURL: 'https://hoover-8274a-default-rtdb.firebaseio.com',
          )
        : FirebaseOptions(
            appId: '1:192536061178:android:c943840f64ff1a52c75543',
            apiKey: 'AIzaSyAMV5YSpC5NsTKeCLCMsA8xUE_mfTqleJ4',
            projectId: 'hoover-8274a',
            databaseURL: 'https://hoover-8274a-default-rtdb.firebaseio.com',
          ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
        ),
        initialRoute: MainPage.id,
        routes: {
          RegistrationPage.id: (context) => RegistrationPage(),
          LoginPage.id: (context) => LoginPage(),
          MainPage.id: (context) => MainPage(),
        },
      ),
    );
  }
}

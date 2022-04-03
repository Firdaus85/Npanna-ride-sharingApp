import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ridesharingapp/AllScreens/mainScreen.dart';
import 'package:ridesharingapp/AllScreens/registrationScreen.dart';
import 'package:ridesharingapp/DataHandler/appData.dart';

import 'AllScreens/loginScreen.dart';

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // ignore: prefer_const_constructors
      options: FirebaseOptions(
    databaseURL: "https://npannaapp-default-rtdb.firebaseio.com/",
    apiKey: "AIzaSyAvoP-cDnkrTGwPfPhAD_LSy6uv8umG6Uw",
    appId: "1:602246314749:android:53afa9e4bfb220ac965c94",
    messagingSenderId: "602246314749",
    projectId: " npannaapp",
  ));
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,

      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        title: 'Npanna',
        theme: ThemeData(
          fontFamily: "Lato",
          primarySwatch: Colors.blue,
        ),
        initialRoute: MainScreen.idScreen,
        routes: {
          RegistrationScreen.idScreen: (context) => RegistrationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
        },
      ),
    );
  }
}

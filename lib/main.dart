
import 'package:clubchat/layout/tabs_screen.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/modules/Home/Home_Screen.dart';
import 'package:clubchat/modules/Login/LoginScreen.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   Widget startPage  = LoginScreen();
  void initState() {
    super.initState();
    intialize();

  }
  void intialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = await prefs.getInt('userId') ?? 0;
    if(id == 0){
      setState(() {
        startPage = LoginScreen();
      });
    } else {
      setState(() {
        startPage = TabsScreen();
      });

    }

     AppUser? user = await AppUserServices().getUser(id);
     if(user != null){
       setState(() {
         AppUserServices().userSetter(user);
         startPage = TabsScreen();
       });
       FlutterNativeSplash.remove();
     } else {
       setState(() {
         startPage = LoginScreen();
       });
       FlutterNativeSplash.remove();
     }


  }
  // FlutterNativeSplash.remove();
  
  @override
  Widget build(BuildContext context) {
    return    MaterialApp(
      theme: ThemeData(
        fontFamily: 'arabFont',
          primarySwatch: Colors.orange ,
          primaryColor:  Colors.orange ,

      ),
      debugShowCheckedModeBanner: false,
      home: startPage,
    );
  }
}


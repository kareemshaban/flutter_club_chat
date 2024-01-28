
import 'package:clubchat/layout/tabs_screen.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/modules/Home/Home_Screen.dart';
import 'package:clubchat/modules/Login/LoginScreen.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
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
   String? local_lang  ;
  void initState() {
    super.initState();
    intialize();

  }
  void intialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = await prefs.getInt('userId');

    String l = await prefs.getString('local_lang') ?? 'en';
    setState(() {
      if(l == null) ;  l = 'en' ;
      local_lang = l ;
    });
    if(id == null){
      FlutterNativeSplash.remove();
      setState(() {
        startPage = LoginScreen();
      });
    } else {
      if(id == 0){
        FlutterNativeSplash.remove();
        setState(() {
          startPage = LoginScreen();
        });
      } else {
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
    }





  }
  // FlutterNativeSplash.remove();
  
  @override
  Widget build(BuildContext context) {
    print(local_lang);
    return    GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'arabFont',
          primarySwatch: Colors.orange ,
          primaryColor:  Colors.orange ,
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.black.withOpacity(0)
          )

      ),
      debugShowCheckedModeBanner: false,
      home: startPage,
      translations:  Translation(),
      locale: Locale(local_lang!),
    );
  }
}



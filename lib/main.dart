
import 'package:clubchat/modules/Login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

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

  void initState() {
    super.initState();
    intialize();

  }
  void intialize() async {
    await Future.delayed(Duration(seconds: 2));
    FlutterNativeSplash.remove();
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
      home: LoginScreen(),
    );
  }
}


import 'dart:async';
import 'dart:convert';

import 'package:clubchat/layout/tabs_screen.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


const List<String> scopes = <String>[
  'email',
  'profile',
];
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: scopes,
);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';

  @override
  void initState()  {
    super.initState();

    checkUserLogin();
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      bool isAuthorized = account != null;
      if (kIsWeb && account != null) {
        isAuthorized = await _googleSignIn.canAccessScopes(scopes);
      }
      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;

        // Navigator()
      });


    });
    _googleSignIn.signInSilently();

  }
  void checkUserLogin() async{
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    // if(prefs.getInt('userId') != null){
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const TabsScreen()),
    //   );
    // }
  }
  Future<void> _handleSignIn() async {
    try {
    // await   _googleSignIn.disconnect();
     var googleREs = await _googleSignIn.signIn();
      print(googleREs ) ;
     AppUser? user = await AppUserServices().createAccount(_googleSignIn.currentUser?.displayName , 'GOOGLE' ,
       _googleSignIn.currentUser?.photoUrl ?? "" , "" , _googleSignIn.currentUser?.email , _googleSignIn.currentUser?.id );
     if(user!.id > 0){
       Fluttertoast.showToast(
           msg: 'login_welcome_msg'.tr,
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.CENTER,
           timeInSecForIosWeb: 1,
           backgroundColor: Colors.black26,
           textColor: Colors.orange,
           fontSize: 16.0
       );
       final SharedPreferences prefs = await SharedPreferences.getInstance();

       await prefs.setInt('userId', user.id);
       AppUserServices().userSetter(user);
       Navigator.pushReplacement(
         context,
         MaterialPageRoute(builder: (context) => const TabsScreen()),
       );
     }

    } catch (error) {
      print(error);
    }
  }


  @override
  Widget build(BuildContext context) {
    return     Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration:  BoxDecoration(  image: DecorationImage(
            image: AssetImage("assets/images/login_bg.jpg"),
            fit: BoxFit.cover,
            colorFilter:  ColorFilter.mode(Colors.grey.withOpacity(.75), BlendMode.dstATop),
          ), ),
          child:  Column(
            children: [
              const SizedBox(height: 100.0,),
              const Image(image: AssetImage("assets/images/logo_trans.png") , width: 200.0, height: 200.0,),
              Text(" login_title".tr , style: TextStyle(fontSize: 30.0 , color: Colors.white.withOpacity(.7) , fontWeight: FontWeight.bold),),
              Expanded(child:
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.grey.withOpacity(.4),
                        child: const Image(image: AssetImage('assets/images/phone.png') , width: 40.0 , height: 40.0,),
                      ),
                      const SizedBox(width: 40.0,),
                      GestureDetector(
                        onTap: (){_handleSignIn();},
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.withOpacity(.4),
                          radius: 30.0,
                          child: const Image(image: AssetImage('assets/images/gmail.png') , width: 40.0 , height: 40.0,),
                        ),
                      ),
                      const SizedBox(width: 40.0,),
                      CircleAvatar(
                        backgroundColor: Colors.grey.withOpacity(.4),
                        radius: 30.0,
                        child: const Image(image: AssetImage('assets/images/facebook.png') , width: 40.0 , height: 40.0,),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                         Text('login_privacy'.tr , style: TextStyle(fontSize: 12.0 , color: Colors.white)  ,),
                        TextButton(onPressed: (){}, child:  Text("login_policy".tr , style: TextStyle(color: Colors.orange , fontSize: 12.0 , fontWeight: FontWeight.bold , decoration: TextDecoration.underline , decorationColor: Colors.orange,),) ),
                         Text('login_and'.tr , style: TextStyle(fontSize: 12.0 , color: Colors.white) ),
                        TextButton(onPressed: (){}, child:  Text("login_services".tr , style: TextStyle(color: Colors.orange , fontSize: 12.0 , fontWeight: FontWeight.bold , decoration: TextDecoration.underline , decorationColor: Colors.orange,),)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                ],
              )
              )
            ],
          ),
        ),
      ),
    );
  }
}

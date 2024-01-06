import 'dart:async';
import 'dart:convert';

import 'package:clubchat/layout/tabs_screen.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  void initState() async {
    super.initState();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getInt('userId') != null){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TabsScreen()),
      );
    }
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
  Future<void> _handleSignIn() async {
    try {
    // await   _googleSignIn.disconnect();
      await _googleSignIn.signIn();
     var res = await AppUserServices().createAccount(_googleSignIn.currentUser?.displayName , 'GOOGLE' ,
       _googleSignIn.currentUser?.photoUrl ?? "" , "" , _googleSignIn.currentUser?.email , _googleSignIn.currentUser?.id );
       final Map resonse = json.decode(res.body);

      //print( resonse['state']);
      if(resonse['state'] == 'success'){
        Fluttertoast.showToast(
            msg: resonse['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        print(resonse['user']['id']);
        await prefs.setInt('userId', resonse['user']['id']);
        Navigator.push(
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
              Text(" It's About Joy!" , style: TextStyle(fontSize: 30.0 , color: Colors.white.withOpacity(.7) , fontWeight: FontWeight.bold),),
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
                        const Text('By signing in ClubChat you agree to ' , style: TextStyle(fontSize: 12.0 , color: Colors.white)  ,),
                        TextButton(onPressed: (){}, child: const Text("ClubChat Policy" , style: TextStyle(color: Colors.orange , fontSize: 12.0 , fontWeight: FontWeight.bold , decoration: TextDecoration.underline , decorationColor: Colors.orange,),) ),
                        const Text('and' , style: TextStyle(fontSize: 12.0 , color: Colors.white) ),
                        TextButton(onPressed: (){}, child: const Text("ClubChat Terms Services" , style: TextStyle(color: Colors.orange , fontSize: 12.0 , fontWeight: FontWeight.bold , decoration: TextDecoration.underline , decorationColor: Colors.orange,),)),
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

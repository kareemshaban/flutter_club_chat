import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AppCupScreen extends StatefulWidget {
  const AppCupScreen({super.key});

  @override
  State<AppCupScreen> createState() => _AppCupScreenState();
}

class _AppCupScreenState extends State<AppCupScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        backgroundColor: MyColors.darkColor,
        centerTitle: true,
        title: Text("app_rank".tr , style: TextStyle(fontSize: 20.0 , color: Colors.white),) ,
        actions: [
          IconButton(icon: Icon(FontAwesomeIcons.sync , color: Colors.white,) , onPressed: (){

          },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: MyColors.darkColor,  image: DecorationImage(image: AssetImage('assets/images/icon_profit_live_user.png') , fit: BoxFit.fill)),
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}

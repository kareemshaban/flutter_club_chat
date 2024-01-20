import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Agreement_Screen extends StatefulWidget {
  const Agreement_Screen({super.key});

  @override
  State<Agreement_Screen> createState() => _Agreement_ScreenState();
}

class _Agreement_ScreenState extends State<Agreement_Screen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.unSelectedColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.darkColor,
        title: Text("agreement_title".tr , style: TextStyle(color: MyColors.unSelectedColor,fontSize: 20.0) ,),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 5.0,),
            Text("agreement_user_agreement".tr,style: TextStyle(color: Colors.white,fontSize: 20.0),),


          ],
        ),
      ),
    );
  }
}

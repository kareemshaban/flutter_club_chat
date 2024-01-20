import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class Privacy_Policy_Screen extends StatefulWidget {
  const Privacy_Policy_Screen({super.key});

  @override
  State<Privacy_Policy_Screen> createState() => _Privacy_Policy_ScreenState();
}

class _Privacy_Policy_ScreenState extends State<Privacy_Policy_Screen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.unSelectedColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.darkColor,
        title: Text("Privacy Policy" , style: TextStyle(color: MyColors.unSelectedColor,fontSize: 20.0) ,),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 5.0,),
            Text("club chat Privacy Policy",style: TextStyle(color: Colors.white,fontSize: 20.0),),
          ],
        ),
      ),
    );
  }
}

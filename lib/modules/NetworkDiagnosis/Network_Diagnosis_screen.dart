import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class Network_Diagnosis_Screen extends StatefulWidget {
  const Network_Diagnosis_Screen({super.key});

  @override
  State<Network_Diagnosis_Screen> createState() => _Network_Diagnosis_ScreenState();
}

class _Network_Diagnosis_ScreenState extends State<Network_Diagnosis_Screen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.unSelectedColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.darkColor,
        title: Text("Network Diagnosis" , style: TextStyle(color: MyColors.unSelectedColor,fontSize: 20.0) ,),
      ),
        body: Container(
          color: MyColors.darkColor,
          width: double.infinity,
          height: double.infinity,
          child: Center(
             child: Container(
               padding: EdgeInsetsDirectional.symmetric(horizontal: 40.0 , vertical: 5.0),
               decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(20.0)),
               child: MaterialButton(onPressed: (){} ,
               child: Text("Start" , style: TextStyle(color: Colors.white , fontSize: 18.0),),
               ),
             ),
          ),
        ),
    );
  }
}

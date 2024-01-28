import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Network_Diagnosis_Screen extends StatefulWidget {
  const Network_Diagnosis_Screen({super.key});

  @override
  State<Network_Diagnosis_Screen> createState() => _Network_Diagnosis_ScreenState();
}

class _Network_Diagnosis_ScreenState extends State<Network_Diagnosis_Screen> {
  bool isLoading = false ;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.unSelectedColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.darkColor,
        title: Text("network_title".tr , style: TextStyle(color: MyColors.unSelectedColor,fontSize: 20.0) ,),
      ),
        body: Container(
          color: MyColors.darkColor,
          width: double.infinity,
          height: double.infinity,
          child: Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Container(
                   padding: EdgeInsetsDirectional.symmetric(horizontal: 40.0 , vertical: 5.0),
                   decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(20.0)),
                   child: MaterialButton(onPressed: (){start();} ,
                   child: Text("network_start".tr , style: TextStyle(color: Colors.white , fontSize: 18.0),),
                   ),
                 ),
                  CircularProgressIndicator(
                   color: Colors.white,
                   strokeWidth: 3,
                     value: isLoading ? null : 0
                 ),
               ],
             ),
          ),
        ),
    );
  }

  start() async{
    setState(() {
      isLoading = true ;
    });
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      isLoading = false ;
    });
    Fluttertoast.showToast(
        msg: 'All Network Services is working as expected ',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
        fontSize: 16.0
    );
  }
}

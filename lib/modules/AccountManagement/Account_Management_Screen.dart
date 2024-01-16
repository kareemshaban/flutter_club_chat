import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class Account_Management_Screen extends StatefulWidget {
  const Account_Management_Screen({super.key});

  @override
  State<Account_Management_Screen> createState() => _Account_Management_ScreenState();
}

class _Account_Management_ScreenState extends State<Account_Management_Screen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.unSelectedColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.darkColor,
        title: Text("Account Management" , style: TextStyle(color: MyColors.unSelectedColor,fontSize: 20.0) ,),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}

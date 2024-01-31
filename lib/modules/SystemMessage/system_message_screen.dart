import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/styles/colors.dart';

class SystemMessage extends StatefulWidget {
  const SystemMessage({super.key});

  @override
  State<SystemMessage> createState() => _SystemMessageState();
}

class _SystemMessageState extends State<SystemMessage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.unSelectedColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.darkColor,
        title: Text("chats_system_massage".tr , style: TextStyle(color: MyColors.unSelectedColor,fontSize: 20.0) ,),
      ),
    body: Container(
    color: MyColors.darkColor,
    width: double.infinity,
    height: double.infinity,
    )
    );
  }
}

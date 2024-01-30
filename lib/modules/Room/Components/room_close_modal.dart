import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoomCloseModal extends StatefulWidget {
  const RoomCloseModal({super.key});

  @override
  State<RoomCloseModal> createState() => _RoomCloseModalState();
}

class _RoomCloseModalState extends State<RoomCloseModal> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 50.0 , horizontal: 10.0),
      color: Colors.black.withAlpha(180),
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      keepRoom();
                    },
                    child: CircleAvatar(
                      radius: 35.0,
                      backgroundColor: MyColors.primaryColor,
                      child: Image(image: AssetImage('assets/images/minimize.png'), width: 40.0 , height: 40.0,),
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Text("room_close_keep".tr , style: TextStyle(color: Colors.white , fontSize: 18.0),)
                ],
              ),
              SizedBox(height: 20.0,),
              Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      exitRoom();
                    },
                    child: CircleAvatar(
                      radius: 35.0,
                      backgroundColor: MyColors.primaryColor,
                      child: Image(image: AssetImage('assets/images/power-off.png'), width: 45.0 , height: 45.0,),
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Text("room_close_exit".tr , style: TextStyle(color: Colors.white , fontSize: 18.0),)
                ],
              ),
            ],
          ),
        ),
      ) ,
    );
  }

  keepRoom(){

  }
  exitRoom(){

  }
}

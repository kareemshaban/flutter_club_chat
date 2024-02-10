import 'package:clubchat/helpers/ExitRoomHelper.dart';
import 'package:clubchat/layout/tabs_screen.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/ChatRoomService.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoomCloseModal extends StatefulWidget {
  const RoomCloseModal({super.key});

  @override
  State<RoomCloseModal> createState() => _RoomCloseModalState();
}

class _RoomCloseModalState extends State<RoomCloseModal> {
  AppUser? user ;
  ChatRoom? room ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
      room = ChatRoomService().roomGetter();
    });
  }
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
    ExitRoomHelper(user!.id , room!.id);
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const TabsScreen(),));
  }
}

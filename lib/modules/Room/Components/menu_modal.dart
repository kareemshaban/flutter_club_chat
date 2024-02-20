import 'dart:math';

import 'package:clubchat/helpers/ChatRoomMessagesHelper.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/modules/Room/Components/themes_modal.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/ChatRoomService.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'musics_modal.dart';

class MenuModal extends StatefulWidget {
  final ScrollController scrollController ;
  const MenuModal({super.key , required this.scrollController});

  @override
  State<MenuModal> createState() => _MenuModalState();
}

class _MenuModalState extends State<MenuModal> {
  ChatRoom? room ;
  AppUser? user ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      room = ChatRoomService().roomGetter();
      user = AppUserServices().userGetter();
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 200,
      padding: EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(color: Colors.black.withAlpha(180),
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(15.0)) ,
          border: Border(top: BorderSide(width: 3.0, color: MyColors.primaryColor),) ),
      child:  Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    showModalBottomSheet(
                        context: context,
                        builder: (ctx) => ThemesBottomSheet());
                  },
                  child: Column(
                    children: [
                      Image(image: AssetImage('assets/images/theme.png') , width: 40.0,),
                      SizedBox(height: 8.0,),
                      Text('menu_theme'.tr , style: TextStyle(color: Colors.white , fontSize: 12.0),)
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Navigator.pop(context);
                    showModalBottomSheet(
                        context: context,
                        builder: (ctx) => MusicBottomSheet());
                  },
                  child: Column(
                    children: [
                      Image(image: AssetImage('assets/images/music.png') , width: 40.0,),
                      SizedBox(height: 8.0,),
                      Text('menu_music'.tr , style: TextStyle(color: Colors.white , fontSize: 12.0),)
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    numberGame();
                  },
                  child: Column(
                    children: [
                      Image(image: AssetImage('assets/images/numbers.png') , width: 40.0,),
                      SizedBox(height: 8.0,),
                      Text('menu_lucky_number'.tr , style: TextStyle(color: Colors.white , fontSize: 12.0),)
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                      nurdGame();
                  },
                  child: Column(
                    children: [
                      Image(image: AssetImage('assets/images/3d-dice.png') , width: 40.0,),
                      SizedBox(height: 8.0,),
                      Text('menu_dice'.tr , style: TextStyle(color: Colors.white , fontSize: 12.0),)
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.0,),
          Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              children: [
                Image(image: AssetImage('assets/images/lucky_bag.png') , width: 40.0,),
                SizedBox(height: 8.0,),
                Text('menu_lucky_bag'.tr , style: TextStyle(color: Colors.white , fontSize: 12.0),)
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Image(image: AssetImage('assets/images/settings.png') , width: 40.0,),
                SizedBox(height: 8.0,),
                Text('menu_settings'.tr , style: TextStyle(color: Colors.white , fontSize: 12.0),)
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [

              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [

              ],
            ),
          ),
        ],
      ),

        ],
      )

    );
  }
  Widget ThemesBottomSheet() => ThemesModal();
  Widget MusicBottomSheet() => MusicsModal();

  nurdGame() async {
    var rng = Random();
    int rand = rng.nextInt(5);
    await ChatRoomMessagesHelper(room_id: room!.id , user_id: user!.id , message: (rand + 1).toString() , type: 'NURD').handleSendRoomMessage();
    Future.delayed(Duration(seconds: 2)).then((value) => {
      widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1),
          curve: Curves.fastOutSlowIn)
    });
    Navigator.pop(context);
  }
  numberGame() async {
    var rng = Random();
    int num1 = rng.nextInt(9);
    int num2 = rng.nextInt(9);
    int num3 = rng.nextInt(9);
    String val = num1.toString() + num2.toString() + num3.toString() ;
    await ChatRoomMessagesHelper(room_id: room!.id , user_id: user!.id , message: val , type: 'LUCKY').handleSendRoomMessage();
    Future.delayed(Duration(seconds: 2)).then((value) => {
    widget.scrollController.animateTo(
    widget.scrollController.position.maxScrollExtent,
    duration: const Duration(milliseconds: 1),
    curve: Curves.fastOutSlowIn)
    });

    Navigator.pop(context);
  }
}

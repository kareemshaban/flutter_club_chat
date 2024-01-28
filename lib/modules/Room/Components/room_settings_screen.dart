import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/modules/Room/Components/room_admins_modal.dart';
import 'package:clubchat/modules/Room/Components/room_block_modal.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/ChatRoomService.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class RoomSettingsModal extends StatefulWidget {
  const RoomSettingsModal({super.key});

  @override
  State<RoomSettingsModal> createState() => _RoomSettingsModalState();
}

class _RoomSettingsModalState extends State<RoomSettingsModal> {
  ChatRoom? room ;
  AppUser? user ;
  bool _isLoading1 =false ;
  bool _isLoading2 =false ;
  bool _isLoading3 =false ;

  var roomTitleController = TextEditingController();
  var roomHelloController = TextEditingController();
  var roomPasswordController = TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      room = ChatRoomService().roomGetter();
      user = AppUserServices().userGetter();
      roomTitleController.text = room!.name ;
      roomHelloController.text = room!.hello_message ;
      roomPasswordController.text = room!.password ;

    });
  }
  @override
  Widget build(BuildContext context) {
    return  Container(

        padding: EdgeInsets.symmetric(vertical: 50.0 , horizontal: 10.0),
        color: Colors.black.withAlpha(180),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_back_ios , color: Colors.white, size: 30.0,)),
              Expanded(child: Text('room_settings'.tr , style: TextStyle(color: Colors.white , fontSize: 20.0), textAlign: TextAlign.center,))
            ],
          ),
          SizedBox(height: 15.0,),
          Row(
            children: [
              Container(
                width: 8.0,
                height: 30.0,
                decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(3.0)),
              ),
              SizedBox(width: 10.0,),
              Text("room_settings_room_title".tr, style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),)
            ],
          ),
          SizedBox(height: 15.0,),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    TextFormField(
                      controller: roomTitleController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: MyColors.primaryColor,
                      maxLength: 20,
                      decoration: InputDecoration(
                          hintText: "room_settings_room_title".tr,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: MyColors.whiteColor)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15.0,),
              ElevatedButton.icon(
                onPressed: (){
                  updateRoomName();
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0) , backgroundColor: MyColors.primaryColor ,
                ),
                icon: _isLoading1
                    ? Container(
                  width: 20,
                  height: 20,
                  padding: const EdgeInsets.all(2.0),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                    :  Icon(Icons.check_circle , color: MyColors.darkColor , size: 20.0,),
                label:  Text('room_settings_update'.tr , style: TextStyle(color: MyColors.darkColor , fontSize: 13.0), ),
              )
            ],
          ),


          Row(
            children: [
              Container(
                width: 8.0,
                height: 30.0,
                decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(3.0)),
              ),
              SizedBox(width: 10.0,),
              Text("room_settings_hello".tr, style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),)
            ],
          ),
          SizedBox(height: 15.0,),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    TextFormField(
                      controller: roomHelloController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: MyColors.primaryColor,
                      maxLength: 20,
                      decoration: InputDecoration(
                          hintText: "room_settings_room_title".tr,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: MyColors.whiteColor)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15.0,),
              ElevatedButton.icon(
                onPressed: (){
                  updateRoomHello();
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0) , backgroundColor: MyColors.primaryColor ,
                ),
                icon: _isLoading2
                    ? Container(
                  width: 20,
                  height: 20,
                  padding: const EdgeInsets.all(2.0),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                    :  Icon(Icons.check_circle , color: MyColors.darkColor , size: 20.0,),
                label:  Text('room_settings_update'.tr , style: TextStyle(color: MyColors.darkColor , fontSize: 13.0), ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                width: 8.0,
                height: 30.0,
                decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(3.0)),
              ),
              SizedBox(width: 10.0,),
              Text("room_settings_room_password".tr, style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),)
            ],
          ),
          SizedBox(height: 15.0,),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    TextFormField(
                      controller: roomPasswordController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: MyColors.primaryColor,
                      maxLength: 20,
                      decoration: InputDecoration(
                        prefixIcon: room!.state == 1 ? Icon(Icons.lock , color: MyColors.primaryColor, size: 20.0,) :
                        Icon(Icons.lock_open , color: MyColors.whiteColor, size: 20.0,) ,
                          hintText: "room_settings_room_password".tr,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: MyColors.whiteColor)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15.0,),
              ElevatedButton.icon(
                onPressed: (){
                  updateRoomPassword();
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0) , backgroundColor: MyColors.primaryColor ,
                ),
                icon: _isLoading3
                    ? Container(
                  width: 20,
                  height: 20,
                  padding: const EdgeInsets.all(2.0),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                    :  Icon(Icons.check_circle , color: MyColors.darkColor , size: 20.0,),
                label:  Text('room_settings_update'.tr , style: TextStyle(color: MyColors.darkColor , fontSize: 13.0), ),
              )
            ],
          ),
          SizedBox(height: 15.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Text("room_settings_room_admins".tr , style: TextStyle(fontSize: 16.0 , color: MyColors.whiteColor , fontWeight: FontWeight.bold),),
                Expanded(child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                          showModalBottomSheet(
                              isScrollControlled: true ,
                              context: context,
                              builder: (ctx) => roomAdminsBottomSheet());
                        }, icon: Icon(Icons.arrow_forward_ios_outlined , color: Colors.white , size: 20.0,) ,)
                      ],
                    )                          ],
                )

                )
              ],
            ),
          ),
          SizedBox(height: 15.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Text("room_settings_room_block_list".tr , style: TextStyle(fontSize: 16.0 , color: MyColors.whiteColor , fontWeight: FontWeight.bold),),
                Expanded(child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                          showModalBottomSheet(
                              isScrollControlled: true ,
                              context: context,
                              builder: (ctx) => roomBlockBottomSheet());
                        }, icon: Icon(Icons.arrow_forward_ios_outlined , color: Colors.white , size: 20.0,) ,)
                      ],
                    )                          ],
                )

                )
              ],
            ),
          ),


        ],
      ),
    );

    }
    void updateRoomName() async {
      setState(() {
        _isLoading1 = true ;
      });
      ChatRoom? res = await ChatRoomService().updateRoomName(room!.id , roomTitleController.text );
      setState(() {
        room = res ;
        ChatRoomService().roomSetter(room!);
        setState(() {
          _isLoading1 = false ;
        });
      });
    }

  void updateRoomHello() async {
    setState(() {
      _isLoading2 = true ;
    });
      ChatRoom? res = await ChatRoomService().updateRoomHello(room!.id , roomHelloController.text);
    setState(() {
      room = res ;
      ChatRoomService().roomSetter(room!);
      setState(() {
        _isLoading2 = false ;
      });
    });
  }

  void updateRoomPassword() async {
    setState(() {
      _isLoading3 = true ;
    });

    ChatRoom? res = await ChatRoomService().updateRoomPassword(room!.id , roomPasswordController.text);
    setState(() {
      room = res ;
      ChatRoomService().roomSetter(room!);
      setState(() {
        _isLoading3 = false ;
      });
    });

  }

  Widget roomAdminsBottomSheet() => RoomAdminsModal();
  Widget roomBlockBottomSheet() => RoomBlockModal();

}


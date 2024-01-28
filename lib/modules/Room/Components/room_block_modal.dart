import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/models/RoomBlock.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/ChatRoomService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/Follower.dart';
import '../../../shared/components/Constants.dart';
import '../../../shared/styles/colors.dart';

class RoomBlockModal extends StatefulWidget {
  const RoomBlockModal({super.key});

  @override
  State<RoomBlockModal> createState() => _RoomBlockModalState();
}

class _RoomBlockModalState extends State<RoomBlockModal> {
  List<RoomBlock>? blockers = [];
  AppUser? user ;
  ChatRoom? room ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      user = AppUserServices().userGetter();
      room = ChatRoomService().roomGetter();
      blockers = room!.blockers ;
    });
  }


  Future<void> _refresh()async{
    await loadData() ;
  }
  loadData() async {
    ChatRoom? res = await ChatRoomService().openRoomById(room!.id);
    setState(() {
      setState(() {
        room = res ;
        blockers = room!.blockers ;
      });
      ChatRoomService().roomSetter(room!);
    });
  }

  Widget build(BuildContext context) {
    return Container(
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
              Expanded(child: Text('room_settings_room_block_list'.tr , style: TextStyle(color: Colors.white , fontSize: 20.0), textAlign: TextAlign.center,))
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: MyColors.primaryColor,
              child: ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder(index) ,
                  separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: blockers!.length),
            ),
          ),
        ],
      ),
    );
  }
  Widget itemListBuilder(index) => Column(
    children: [
      Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: blockers![index].mic_user_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,

                  backgroundImage: blockers![index].mic_user_img != "" ?
                  NetworkImage('${ASSETSBASEURL}AppUsers/${blockers![index].mic_user_img}') : null,
                  radius: 30,
                  child: blockers![index].mic_user_img == "" ?
                  Text(blockers![index].mic_user_name!.toUpperCase().substring(0 , 1) +
                      (blockers![index].mic_user_name!.contains(" ") ? blockers![index].mic_user_name!.substring(blockers![index].mic_user_name!.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                    style: const TextStyle(color: Colors.white , fontSize: 24.0 , fontWeight: FontWeight.bold),) : null,
                )
              ],
            ),
            const SizedBox(width: 10.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(blockers![index].mic_user_name! , style: TextStyle(color: MyColors.whiteColor , fontSize: 18.0),),
                    const SizedBox(width: 5.0,),
                    CircleAvatar(
                      backgroundColor: blockers![index].mic_user_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                      radius: 10.0,
                      child: blockers![index].mic_user_gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                    )
                  ],
                ),
                Row(

                  children: [
                    Image(image: NetworkImage(ASSETSBASEURL + 'Levels/' + blockers![index].mic_user_share_level!) , width: 40,),
                    const SizedBox(width: 10.0,),
                    Image(image: NetworkImage(ASSETSBASEURL + 'Levels/' + blockers![index].mic_user_karizma_level!) , width: 40,),
                    const SizedBox(width: 10.0,),
                    Image(image: NetworkImage(ASSETSBASEURL + 'Levels/' + blockers![index].mic_user_charging_level!) , width: 30,),

                  ],
                ),

                Text("ID:${blockers![index].mic_user_tag}" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 13.0),),


              ],

            ),

          ]),
      Container(
        width: double.infinity,
        height: 1.0,
        color: MyColors.lightUnSelectedColor,
        margin: EdgeInsetsDirectional.only(start: 50.0),
        child: const Text(""),
      )
    ],
  );

  Widget itemSperatorBuilder() => SizedBox(height: 5.0,);

}

import 'package:clubchat/helpers/RoomBasicDataHelper.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/models/RoomAdmin.dart';
import 'package:clubchat/modules/Room/Components/add_admin_modal.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/ChatRoomService.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../models/Follower.dart';
import '../../../shared/components/Constants.dart';
import '../../../shared/styles/colors.dart';

class RoomAdminsModal extends StatefulWidget {
  const RoomAdminsModal({super.key});

  @override
  State<RoomAdminsModal> createState() => _RoomAdminsModalState();
}

class _RoomAdminsModalState extends State<RoomAdminsModal> {
    List<RoomAdmin>? admins = [];
    AppUser? user ;
    ChatRoom? room ;
    bool _isLoading = false ;

    @override
    void initState() {
      // TODO: implement initState
      super.initState();

      setState(() {
        user = AppUserServices().userGetter();
        room = ChatRoomService().roomGetter();
        admins = room!.admins ;
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
        admins = room!.admins ;
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
              Expanded(child: Text('room_settings_room_admins'.tr , style: TextStyle(color: Colors.white , fontSize: 20.0), textAlign: TextAlign.center,)),
              IconButton(onPressed: (){
                Navigator.pop(context);
                showModalBottomSheet(
                    isScrollControlled: true ,
                    context: context,
                    builder: (ctx) => addAdminsBottomSheet());

              }, icon: Icon(Icons.add_circle_outline , color: Colors.white, size: 25.0,)),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: MyColors.primaryColor,
              child: ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder(index) ,
                  separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: admins!.length),
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
                  backgroundColor: admins![index].mic_user_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,

                  backgroundImage: admins![index].mic_user_img != "" ?
                  NetworkImage('${ASSETSBASEURL}AppUsers/${admins![index].mic_user_img}') : null,
                  radius: 30,
                  child: admins![index].mic_user_img == "" ?
                  Text(admins![index].mic_user_name!.toUpperCase().substring(0 , 1) +
                      (admins![index].mic_user_name!.contains(" ") ? admins![index].mic_user_name!.substring(admins![index].mic_user_name!.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
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
                    Text(admins![index].mic_user_name! , style: TextStyle(color: MyColors.whiteColor , fontSize: 18.0),),
                    const SizedBox(width: 5.0,),
                    CircleAvatar(
                      backgroundColor: admins![index].mic_user_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                      radius: 10.0,
                      child: admins![index].mic_user_gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                    )
                  ],
                ),
                Row(

                  children: [
                    Image(image: NetworkImage(ASSETSBASEURL + 'Levels/' + admins![index].mic_user_share_level!) , width: 40,),
                    const SizedBox(width: 10.0,),
                    Image(image: NetworkImage(ASSETSBASEURL + 'Levels/' + admins![index].mic_user_karizma_level!) , width: 40,),
                    const SizedBox(width: 10.0,),
                    Image(image: NetworkImage(ASSETSBASEURL + 'Levels/' + admins![index].mic_user_charging_level!) , width: 30,),

                  ],
                ),

                Text("ID:${admins![index].mic_user_tag}" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 13.0),),


              ],

            ),
            Expanded(child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: (){
                    // uploadCoverPhoto();
                  removeAdmin(admins![index].user_id);
                  },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8.0) , backgroundColor: Colors.white ,
                  ),
                  icon: _isLoading
                      ? Container(
                    width: 18,
                    height: 18,
                    padding: const EdgeInsets.all(2.0),
                    child: const CircularProgressIndicator(
                      color: Colors.black54,
                      strokeWidth: 3,
                    ),
                  )
                      :  Icon(Icons.remove_circle_outline , color: Colors.red , size: 20.0,),
                  label:  Text('remove_btn'.tr , style: TextStyle(color: Colors.red , fontSize: 15.0), ),
                )
              ],
            )
            )

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

    Widget addAdminsBottomSheet() => AddAdminModal();

    removeAdmin(user_id) async{
      setState(() {
        _isLoading = true ;
      });
      ChatRoom? res = await ChatRoomService().removeChatRoomAdmin(user_id, room!.id);
      setState(() {
        _isLoading = false ;
        room = res ;
        admins = room!.admins ;
      });
      ChatRoomService().roomSetter(room!);

      Fluttertoast.showToast(
          msg: 'admin_deleted'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
    }

}

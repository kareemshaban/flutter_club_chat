import 'package:clubchat/helpers/RoomBasicDataHelper.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/models/Emossion.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/ChatRoomService.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class EmojModal extends StatefulWidget {
  const EmojModal({super.key});

  @override
  State<EmojModal> createState() => _EmojModalState();
}

class _EmojModalState extends State<EmojModal> {
  List<Emossion> emossions = [];
  AppUser? user ;
  ChatRoom? room ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RoomBasicDataHelper? helper = ChatRoomService().roomBasicDataHelperGetter();
    emossions = helper!.emossions;
    user = AppUserServices().userGetter();
    room = ChatRoomService().roomGetter();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(color: Colors.black.withAlpha(180),
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(15.0)) ,
          border: Border(top: BorderSide(width: 3.0, color: MyColors.primaryColor),) ),
      child:      GridView.count(
        shrinkWrap: true,
        crossAxisCount: 5,
        children:
        emossions.map((emoj) => emojListItem(emoj)).toList(),
        mainAxisSpacing: 0.0,
      ),

    );
  }

  Widget emojListItem(emoj) => Container(
    child: Column(
      children: [
        Image(image: NetworkImage(ASSETSBASEURL + 'Emossions/' + emoj.icon) , width: 60.0,)
      ],
    ),
  );
}

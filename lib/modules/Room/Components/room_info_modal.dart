import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/modules/Room/Components/room_settings_screen.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/ChatRoomService.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class RoomInfoModal extends StatefulWidget {
  const RoomInfoModal({super.key});

  @override
  State<RoomInfoModal> createState() => _RoomInfoModalState();
}

class _RoomInfoModalState extends State<RoomInfoModal> {
  ChatRoom? room;
  String? room_img;
  AppUser? user ;
  bool isAdmin = false ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      room = ChatRoomService().roomGetter();
      user = AppUserServices().userGetter();
      isAdmin = room!.userId == user!.id ;
      if (room!.img == room!.admin_img) {
        room_img = '${ASSETSBASEURL}AppUsers/${room?.img}';
      } else {
        room_img = '${ASSETSBASEURL}Rooms/${room?.img}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(color: Colors.black.withAlpha(180),
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(15.0)) ,
          border: Border(top: BorderSide(width: 3.0, color: MyColors.primaryColor),) ),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              width: 50.0,
                              height: 50.0,
                              child: SizedBox(),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: room!.img == ""
                                      ? DecorationImage(
                                      image: AssetImage('assets/images/user.png'),
                                      fit: BoxFit.cover)
                                      : DecorationImage(
                                      image: NetworkImage(room_img!),
                                      fit: BoxFit.cover))),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                room!.name,
                                style: TextStyle(color: Colors.white, fontSize: 16.0),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'ID:' + room!.tag,
                                    style: TextStyle(
                                        color: MyColors.unSelectedColor, fontSize: 11.0),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '|',
                                    style: TextStyle(
                                        color: MyColors.unSelectedColor, fontSize: 14.0),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Image(
                                        image: NetworkImage(
                                            ASSETSBASEURL + 'Countries/' + room!.flag),
                                        width: 30.0,
                                      )),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '|',
                                    style: TextStyle(
                                        color: MyColors.unSelectedColor, fontSize: 14.0),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0) ,
                                        color: getTagColor()),
                                    padding: EdgeInsets.all(3.0),
                                    child: Text('#' + room!.subject , style: TextStyle(fontSize: 10.0 , color: Colors.white),),
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  Expanded(

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        isAdmin ? IconButton(onPressed: (){
                            Navigator.pop(context);
                            showModalBottomSheet(
                                isScrollControlled: true ,
                                context: context,
                                builder: (ctx) => roomSettingsBottomSheet());

                        }, icon: Icon(Icons.settings , size: 35.0,) , color: MyColors.unSelectedColor, ) : SizedBox(width: 1.0,),

                      ],
                    ),
                  )

                ],
              ),
              SizedBox(height: 20.0),
                Row(
                  children: [
                    Container(
                      width: 8.0,
                      height: 30.0,
                      decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(3.0)),
                    ),
                    SizedBox(width: 10.0,),
                    Text("edit_profile_basic_information".tr, style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),)
                  ],
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Text("ID" , style: TextStyle(fontSize: 16.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
                    Expanded(child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(room!.tag , style: TextStyle(fontSize: 16.0 , color: Colors.white),),
                            SizedBox(width: 5.0,),
                            IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.tag , color: Colors.white , size: 20.0,) ,)
                          ],
                        )                          ],
                    )

                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Text("room_info_room_name".tr , style: TextStyle(fontSize: 16.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
                    Expanded(child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(room!.name , style: TextStyle(fontSize: 16.0 , color: Colors.white),),
                            SizedBox(width: 5.0,),
                            IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.signature , color: Colors.white , size: 20.0,) ,)
                          ],
                        )                          ],
                    )

                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Text("room_info_room_admin".tr , style: TextStyle(fontSize: 16.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
                    Expanded(child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                Text(room!.admin_name , style: TextStyle(fontSize: 16.0 , color: Colors.white),),
                                Text(room!.admin_tag , style: TextStyle(fontSize: 14.0 , color: MyColors.unSelectedColor),),
                              ],
                            ),

                            SizedBox(width: 5.0,),
                            IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.idBadge , color: Colors.white , size: 20.0,) ,)
                          ],
                        )                          ],
                    )

                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Text("room_info_room_country".tr , style: TextStyle(fontSize: 16.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
                    Expanded(child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image(image: NetworkImage(ASSETSBASEURL + 'Countries/' + room!.flag) , width: 30.0,),
                            SizedBox(width: 5.0,),
                            IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.flag , color: Colors.white , size: 20.0,) ,)
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
  Color getTagColor(){
    if(room!.subject == "CHAT"){
      return MyColors.primaryColor.withOpacity(.8) ;
    } else if(room!.subject == "FRIENDS"){
      return MyColors.successColor.withOpacity(.8) ;
    }else if(room!.subject == "GAMES"){
      return MyColors.blueColor.withOpacity(.8) ;
    }
    else {
      return MyColors.primaryColor.withOpacity(.8) ;
    }

  }

  Widget roomSettingsBottomSheet() => RoomSettingsModal();
}

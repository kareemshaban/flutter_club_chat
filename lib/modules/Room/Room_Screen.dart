import 'package:clubchat/helpers/DesigGiftHelper.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/models/Design.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/ChatRoomService.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:svgaplayer_flutter/player.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  AppUser? user;
  List<Design> designs = [] ;
  String frame = "" ;
  ChatRoom? room ;
  String room_img = "" ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      user = AppUserServices().userGetter();
      room = ChatRoomService().roomGetter();
      if(room!.img == room!.admin_img){

        room_img = '${ASSETSBASEURL}AppUsers/${room?.img}' ;
      } else {
        room_img = '${ASSETSBASEURL}Rooms/${room?.img}' ;
      }

    });
    geAdminDesigns();
  }

  geAdminDesigns() async{
    DesignGiftHelper _helper =  await AppUserServices().getMyDesigns(room!.userId);
    setState(() {
      designs = _helper.designs! ;
    });
    if(designs.where((element) => (element.category_id == 4 && element.isDefault == 1)).toList().length > 0){
      String icon = designs.where((element) => (element.category_id == 4 && element.isDefault == 1)).toList()[0].motion_icon ;

      setState(() {
        frame = ASSETSBASEURL + 'Designs/Motion/' + icon +'?raw=true' ;
        print(frame);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(decoration: TextDecoration.none),
      child: SafeArea(
        child: Container(
          padding: EdgeInsetsDirectional.only(top: 10.0 , end: 10.0),
          color: MyColors.darkColor,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                            width: 50.0,
                            height: 50.0,
                            child: SizedBox(),
                            clipBehavior: Clip.antiAliasWithSaveLayer ,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10.0),
                                image: room!.img == ""
                                    ? DecorationImage(image: AssetImage('assets/images/user.png') , fit: BoxFit.cover)
                                    : DecorationImage(image: NetworkImage(room_img) ,fit: BoxFit.cover ) )),
                        SizedBox(width: 10.0,),
                        Column(
                          children: [
                            Text(room!.name , style: TextStyle(color: Colors.white , fontSize: 16.0 ), ),
                            SizedBox(height: 5.0,),
                            Text('ID:' + room!.tag , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 11.0),) ,
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(color: Colors.black26 , borderRadius: BorderRadius.circular(10.0)),
                        child: Row(
                          children: [
                            Image(image: AssetImage('assets/images/chatroom_rank_ic.png') , height: 18.0, width: 18.0, ),
                            SizedBox(width: 5.0,),
                            Text("0" , style: TextStyle(color: Colors.white , fontSize: 13.0),)
                          ],
                        ),
                      ),
                      SizedBox(width: 7.0,),
                      GestureDetector(child: Container( margin: EdgeInsets.symmetric(horizontal: 10.0), child: Icon(FontAwesomeIcons.shareFromSquare , color: Colors.white , size: 20.0, ))),
                      GestureDetector(child: Container( margin: EdgeInsets.symmetric(horizontal: 10.0), child: Icon(FontAwesomeIcons.powerOff , color: Colors.white , size: 20.0, ),)),

                    ],
                  ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 15.0,
                        backgroundImage: getUserAvatar()
                      ),
                      Image(image: AssetImage('assets/images/room_user_small_border.png') , width: 50 , height: 50,)
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(color: Colors.black26 , borderRadius: BorderRadius.circular(10.0)),
                    child: Row(
                      children: [
                        Icon(Icons.people_alt , color: MyColors.primaryColor, size: 20.0,),
                        SizedBox(width: 5.0,),
                        Text(room!.members!.length.toString() , style: TextStyle(color: MyColors.primaryColor , fontSize: 13.0),)
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                              radius: 30.0,
                              backgroundImage: getUserAvatar()
                          ),
                          Container(height: 80.0, width: 80.0, child: frame != "" ? SVGASimpleImage(   resUrl: frame) : null),
                      
                        ],
                      ),
                      Text(room!.admin_name , style: TextStyle(color: Colors.white , fontSize: 15.0),)
                    ],
                  ),
                ],
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: room!.mics!.map((mic ) => micListItem(mic)).toList() ,
                ),
              )


            ],
          ),
        ),
      ),
    );
  }

  ImageProvider getUserAvatar(){
    if(room_img == ''){
       return AssetImage('assets/images/user.png');
    } else {
      return NetworkImage(room_img);
    }
  }
  Widget micListItem(mic) => Column(
    children: [

    ],
  );
}

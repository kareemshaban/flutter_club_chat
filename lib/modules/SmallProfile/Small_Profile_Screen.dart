import 'package:clubchat/helpers/DesigGiftHelper.dart';
import 'package:clubchat/helpers/ExitRoomHelper.dart';
import 'package:clubchat/helpers/MicHelper.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/models/Mall.dart';
import 'package:clubchat/models/Medal.dart';
import 'package:clubchat/modules/InnerProfile/Inner_Profile_Screen.dart';
import 'package:clubchat/modules/Room/Room_Screen.dart';
import 'package:clubchat/modules/chat/chat.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/ChatRoomService.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:svgaplayer_flutter/player.dart';

class SmallProfileModal extends StatefulWidget {
  final AppUser? visitor ;
  final int? type ;
  const SmallProfileModal({super.key , required this.visitor , this.type });

  @override
  State<SmallProfileModal> createState() => _SmallProfileModalState();
}

class _SmallProfileModalState extends State<SmallProfileModal> {
  AppUser? user ;
  AppUser? currentUser ;
  String frame = "" ;
  String bg = "" ;
  int type = 0 ; // 0 from any where 1 from room
  var passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = widget.visitor ;
      currentUser = AppUserServices().userGetter();
      if(widget.type != null){
        type = widget.type! ;
      } else {
        type = 0 ;
      }
    });
    print(type);
    if(user!.vips!.length > 0){
      List<Mall>? vipDesigns = user!.vips![0].designs;

      final b = vipDesigns!.where((element) => int.parse(element.category_id.toString())  == 9).toList()[0].icon;
      setState(() {
        bg = b ;
      });
    }


  }
  getDesigns () async {
    DesignGiftHelper helper = await AppUserServices().getMyDesigns(user!.id);
    setState(() {
      // designs = helper.designs! ;
      // gifts = helper.gifts! ;

    });
    if(helper.designs!.where((element) => (element.category_id == 4 && element.isDefault == 1)).toList().length > 0){
      String icon = helper.designs!.where((element) => (element.category_id == 4 && element.isDefault == 1)).toList()[0].motion_icon ;

      setState(() {
        frame = ASSETSBASEURL + 'Designs/Motion/' + icon +'?raw=true' ;

      });
    }
  }
  Widget getVipProfileFrame(){
    if(user!.vips!.length > 0){
      List<Mall>? vipDesigns = user!.vips![0].designs;
      final profile_frame = vipDesigns!.where((element) => element.category_id == 8).toList()[0].motion_icon;
      return   Transform.translate(
          offset: Offset(0 , -150),
          child: SVGASimpleImage(resUrl:(ASSETSBASEURL + 'Designs/Motion/' + profile_frame)));
    } else {
      return SizedBox();
    }

  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * .35,
          decoration: BoxDecoration(color: Colors.black.withAlpha(210),
              borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(20.0)) ,
              border: Border(top: BorderSide(width: 1.0, color: MyColors.primaryColor),),
              image: bg != "" ? DecorationImage(image: NetworkImage(ASSETSBASEURL + 'Designs/' + bg) , fit: BoxFit.cover ,
              colorFilter:  ColorFilter.mode(Colors.black54, BlendMode.dstATop)) : null
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PopupMenuButton<int>(
                          color: MyColors.darkColor,
                          onSelected: (item) => {
                            if(item == 0){
                              reportUser()
                            } else {
                              blockUser()
                            }
                          },
                          iconColor: Colors.white,
                          iconSize: 25.0,
                          itemBuilder: (context) => [
                            PopupMenuItem<int>(value: 0, child: Row(
                              children: [
                                Icon(Icons.block , color: MyColors.whiteColor , size: 18.0,),
                                SizedBox(width: 5.0,),
                                Text("inner_report".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),)
                              ],
                            )),
                            PopupMenuItem<int>(value: 1, child: Row(
                              children: [
                                Icon(Icons.report , color: MyColors.whiteColor , size: 18.0,),
                                SizedBox(width: 5.0,),
                                Text("inner_block".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),)
                              ],
                            )),
                          ],
                        ),

                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Transform.translate(
                            offset: user!.vips!.length > 0  ? Offset(0,  -60.0) : Offset(0,  -40.0) ,
                            child: Stack(
                              alignment: Alignment.center,

                              children: [
                                CircleAvatar(
                                  backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                  backgroundImage: user?.img != "" ?  NetworkImage(getUserImage()!) : null,
                                  radius: 40,
                                  child: user?.img== "" ?
                                  Text(user!.name.toUpperCase().substring(0 , 1) +
                                      (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                    style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                ),
                                Container(height: 100.0, width: 100.0, child: frame != "" ? SVGASimpleImage(   resUrl: frame) : null),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                       type == 0 ?
                       IconButton(onPressed: (){ openUserProfile();}, icon: Icon(Icons.person  , color: Colors.white,)): SizedBox(width: 45.0,),
                      ],
                    )
                  ],
                ),
                Transform.translate(
                  offset: Offset(0, -30.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(user!.name , style: TextStyle(color: Colors.white , fontSize: 15.0 , fontWeight: FontWeight.bold),),
                          const SizedBox(width: 10.0,),
                          CircleAvatar(
                            backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                            radius: 12.0,
                            child: user!.gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          user!.vips!.length > 0 ?  Image(image: NetworkImage('${ASSETSBASEURL}VIP/${user!.vips![0].icon}') , width: 65,) : Container(),
                          user!.vips!.length > 0 ?  const SizedBox(width: 5.0,):  Container(),
                          Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.share_level_icon}') , width: 50,),
                          const SizedBox(width: 10.0,),
                          Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.karizma_level_icon}') , width: 50,),
                          const SizedBox(width: 10.0, height: 10,),
                          Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.charging_level_icon}') , width: 30,),
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  user!.medals!.map((medal) =>  getMedalItem(medal)).toList()

                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("ID:" + user!.tag , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),),
                              const SizedBox(width: 5.0,),
                              Icon(Icons.copy_outlined , color: MyColors.whiteColor , size: 20.0,)
                            ],
                          ),
                          const SizedBox(width: 15.0,),
                          Row(

                            children: [
                              Text("followers_title".tr, style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),),


                              Icon(Icons.people_outlined , color: MyColors.whiteColor , size: 20.0,),

                              Text(user!.followers!.length.toString(), style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),),

                            ],
                          ),
                          const SizedBox(width: 15.0,),

                        ],
                      ),
                      const SizedBox(height: 5.0,),

                      Text(user!.status !="" ? user!.status  : "Nothing here" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 16.0),),


                      const SizedBox(height: 10.0,),
                      type == 0 ? Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                getFollowBtn()
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: (){openChat();},
                                    child: Image(image: AssetImage('assets/images/message.png') , width: 70.0)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: (){openUserRoom();}, child: Image(image: AssetImage('assets/images/home.png') , width: 70.0)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: (){trackUser();},
                              child: Column(
                                children: [
                                  Image(image: AssetImage('assets/images/tracking.png') , width: 70.0),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ) : Container(),

                    ],
                  ),
                )


              ],
            ),
          )

        ),
        getVipProfileFrame()
      ],
    );
  }

  reportUser() async{
    AppUser? currentUser = AppUserServices().userGetter();
    await AppUserServices().reportUser(currentUser!.id, user!.id);
    Navigator.pop(context);
  }
  blockUser() async{
    AppUser? currentUser = AppUserServices().userGetter();
    await AppUserServices().blockUser(currentUser!.id, user!.id);
    currentUser = await AppUserServices().getUser(currentUser!.id);
    AppUserServices().userSetter(currentUser!);
    Navigator.pop(context);
  }
  String? getUserImage(){
    if(user!.img.startsWith('https')){
      return user!.img.toString() ;
    } else {
      return '${ASSETSBASEURL}AppUsers/${user?.img}' ;
    }
  }
  openUserRoom() async{

    ChatRoom? res = await ChatRoomService().openRoomByAdminId(user!.id);
    if(res != null){
      await checkForSavedRoom(res);
      if(res.state == 0 || res.userId == currentUser!.id){
        ChatRoomService().roomSetter(res);
        Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen(),));
      } else {
        _displayTextInputDialog(context , res);
      }

    } else {
      print('clicked');
      Fluttertoast.showToast(
          msg: 'inner_msg_no_room'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
    }


  }

  checkForSavedRoom(ChatRoom room) async {
    ChatRoom? savedRoom = ChatRoomService().savedRoomGetter();
    if(savedRoom != null){
      if(savedRoom.id == room.id){

      } else {
        // close the savedroom
        ChatRoomService().savedRoomSetter(null);
        await ChatRoomService.engine!.leaveChannel();
        await ChatRoomService.engine!.release();
        MicHelper( user_id:  user!.id , room_id:  savedRoom!.id , mic: 0).leaveMic();
        ExitRoomHelper(user!.id , savedRoom.id);

      }
    }

  }

  Future<void> _displayTextInputDialog(BuildContext context , ChatRoom room) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            backgroundColor: MyColors.darkColor,
            title: Text(
              'room_password_label'.tr,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                  height: 70.0,
                  child: TextField(
                    controller: passwordController,
                    style: TextStyle(color: Colors.white),
                    cursorColor: MyColors.primaryColor,
                    maxLength: 20,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        hintText: "XXXXXXX",
                        hintStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: MyColors.whiteColor)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: MyColors.solidDarkColor,
                    borderRadius: BorderRadius.circular(15.0)),
                child: MaterialButton(
                  child: Text(
                    'edit_profile_cancel'.tr,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: BorderRadius.circular(15.0)),
                child: MaterialButton(
                  child: Text(
                    'OK',
                    style: TextStyle(color: MyColors.darkColor),
                  ),
                  onPressed: () async {
                    if(passwordController.text == room.password){
                      ChatRoomService().roomSetter(room);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen(),));
                    } else {
                      Fluttertoast.showToast(
                          msg: "room_password_wrong".tr,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black26,
                          textColor: Colors.orange,
                          fontSize: 16.0
                      );
                    }

                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getFollowBtn(){
    AppUser? currentUser = AppUserServices().userGetter();
    if(currentUser!.followings!.where((element) => element.follower_id == user!.id).length == 0){
      return  GestureDetector(onTap: () {followUser();},  child: Image(image: AssetImage('assets/images/add-user.png') , width: 70.0,));
    } else {
      return  GestureDetector(onTap: () {unFollowUser();},  child: Image(image: AssetImage('assets/images/remove-user.png') , width: 70.0,));
    }
  }

  followUser() async{
    AppUser? currentUser = AppUserServices().userGetter();
    AppUser? res = await AppUserServices().followUser(currentUser!.id, user!.id);

    AppUserServices().userSetter(res!);
    Fluttertoast.showToast(
        msg: 'inner_msg_followed'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
        fontSize: 16.0
    );
    Navigator.pop(context);
  }
  unFollowUser() async{
    AppUser? currentUser = AppUserServices().userGetter();
    AppUser? res = await AppUserServices().unfollowkUser(currentUser!.id, user!.id);
    AppUserServices().userSetter(res!);
    Fluttertoast.showToast(
        msg: 'inner_msg_unfollowed'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
        fontSize: 16.0
    );
    Navigator.pop(context);
  }

  openChat(){
    print('visitor');
    print(user);

    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(receiverUserEmail: user!.email, receiverUserID: user!.id , receiver: user!,),));
  }

  trackUser() async {
    ChatRoom? res = await ChatRoomService().trackUser(user!.id);
    if(res != null){
      await checkForSavedRoom(res);
      if(res.state == 0 || res.userId == currentUser!.id){
        ChatRoomService().roomSetter(res);
        Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen(),));
      } else {
        _displayTextInputDialog(context , res);
      }

    } else {
      print('clicked');
      Fluttertoast.showToast(
          msg: 'inner_msg_not_any_room'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
    }
  }
  openUserProfile(){
    Navigator.push(context, MaterialPageRoute(builder: (ctx) =>  InnerProfileScreen(visitor_id: user!.id)));
  }

  Widget getMedalItem(Medal medal){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0),
      child: Column(
          children:[
            Image(image: NetworkImage('${ASSETSBASEURL}Badges/${medal.icon}') , width: 30,),

          ]

      ),
    );
  }
}

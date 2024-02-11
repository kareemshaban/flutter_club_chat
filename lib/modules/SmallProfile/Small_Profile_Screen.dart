import 'package:clubchat/helpers/DesigGiftHelper.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/ChatRoom.dart';
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
  const SmallProfileModal({super.key , required this.visitor});

  @override
  State<SmallProfileModal> createState() => _SmallProfileModalState();
}

class _SmallProfileModalState extends State<SmallProfileModal> {
  AppUser? user ;
  String frame = "" ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = widget.visitor ;
    });
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
  @override
  Widget build(BuildContext context) {
    return Container(

      height: MediaQuery.sizeOf(context).height * .35,
      decoration: BoxDecoration(color: Colors.black.withAlpha(210),
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(20.0)) ,
          border: Border(top: BorderSide(width: 1.0, color: MyColors.primaryColor),) ),
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
                        offset: Offset(0, -40.0),
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
                    IconButton(onPressed: (){ openUserProfile();}, icon: Icon(Icons.person  , color: Colors.white,)),
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
                      Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.share_level_icon}') , width: 50,),
                      const SizedBox(width: 10.0,),
                      Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.karizma_level_icon}') , width: 50,),
                      const SizedBox(width: 10.0, height: 10,),
                      Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.charging_level_icon}') , width: 30,),
                    ],
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
                  Row(
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
                  ),
        
                ],
              ),
            )
        
            
          ],
        ),
      )

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
      ChatRoomService().roomSetter(res!);
      Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen(),));
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
      ChatRoomService().roomSetter(res!);
      Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen(),));
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
}

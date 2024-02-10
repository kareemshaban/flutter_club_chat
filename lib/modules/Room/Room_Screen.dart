import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubchat/helpers/DesigGiftHelper.dart';
import 'package:clubchat/helpers/EnterRoomHelper.dart';
import 'package:clubchat/helpers/MicHelper.dart';
import 'package:clubchat/helpers/RoomBasicDataHelper.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/Category.dart';
import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/models/Design.dart';
import 'package:clubchat/models/Emossion.dart';
import 'package:clubchat/models/Gift.dart';
import 'package:clubchat/models/RoomTheme.dart';
import 'package:clubchat/modules/Room/Components/emoj_modal.dart';
import 'package:clubchat/modules/Room/Components/gift_modal.dart';
import 'package:clubchat/modules/Room/Components/menu_modal.dart';
import 'package:clubchat/modules/Room/Components/room_close_modal.dart';
import 'package:clubchat/modules/Room/Components/room_info_modal.dart';
import 'package:clubchat/modules/Room/Components/room_members_modal.dart';
import 'package:clubchat/modules/SmallProfile/Small_Profile_Screen.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/ChatRoomService.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:popover/popover.dart';
import 'package:svgaplayer_flutter/player.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> with TickerProviderStateMixin{
  AppUser? user;
  List<Design> designs = [];
  String frame = "";
  ChatRoom? room;
  String room_img = "";
  List<Emossion> emossions = [];
  List<RoomTheme> themes = [];
  List<Gift> gifts = [];
  List<Category> categories = [];
  TabController? _tabController ;
  List<Widget> giftTabs = [] ;
  List<Widget> giftViews = [] ;
  String sendGiftReceiverType = "";
  int? selectedGift  ;
  String userRole = 'USER';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    setState(() {
      sendGiftReceiverType = "select_one_ore_more";
      user = AppUserServices().userGetter();
      room = ChatRoomService().roomGetter();
      if(user!.id == room!.userId){
        setState(() {
          userRole = 'OWNER';
        });
      } else if(room!.admins!.where((element) => element.user_id == user!.id).length > 0){
        setState(() {
          userRole = 'OWNER';
        });
      } else {
        setState(() {
          userRole = 'USER';
        });
      }
      if (room!.img == room!.admin_img) {
        room_img = '${ASSETSBASEURL}AppUsers/${room?.img}';
      } else {
        room_img = '${ASSETSBASEURL}Rooms/${room?.img}';
      }
    });
    EnterRoomHelper(user!.id , room!.id);
    enterRoomListener();
    exitRoomListener();
    micListener();
    geAdminDesigns();
    getRoomBasicData();
  }

  enterRoomListener(){
    CollectionReference reference = FirebaseFirestore.instance.collection('enterRoom');
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        // Do something with change
        refreshRoom();
      });
    });
  }
  exitRoomListener(){
    CollectionReference reference = FirebaseFirestore.instance.collection('exitRoom');
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        // Do something with change
        refreshRoom();
      });
    });
  }
  micListener(){
    CollectionReference reference = FirebaseFirestore.instance.collection('mic-state');
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        // Do something with change
        refreshRoom();
      });
    });
  }
  refreshRoom() async{
    ChatRoom? res = await ChatRoomService().openRoomById(room!.id);
    setState(() {
      room = res ;
    });
  }

  geAdminDesigns() async {
    DesignGiftHelper _helper =
        await AppUserServices().getMyDesigns(room!.userId);
    setState(() {
      designs = _helper.designs!;
    });
    if (designs
            .where((element) =>
                (element.category_id == 4 && element.isDefault == 1))
            .toList()
            .length >
        0) {
      String icon = designs
          .where(
              (element) => (element.category_id == 4 && element.isDefault == 1))
          .toList()[0]
          .motion_icon;

      setState(() {
        frame = ASSETSBASEURL + 'Designs/Motion/' + icon + '?raw=true';
        print(frame);
      });
    }
  }

  getRoomBasicData() async {
    RoomBasicDataHelper? helper = await ChatRoomService().getRoomBasicData();
    ChatRoomService().roomBasicDataHelperSetter(helper!);
    setState(() {
      emossions = helper!.emossions;
      themes = helper.themes;
      gifts = helper.gifts;
      categories = helper.categories;
      _tabController = new TabController(vsync: this, length: categories.length);
    });
  }
  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(decoration: TextDecoration.none),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(ASSETSBASEURL + 'Themes/' + room!.room_bg!),
                fit: BoxFit.cover)),
        padding: EdgeInsetsDirectional.only(top: 10.0, end: 10.0),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              showModalBottomSheet(
                                  context: context,
                                  builder: (ctx) => RoomInfoBottomSheet());
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
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
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          image: room!.img == ""
                                              ? DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/user.png'),
                                                  fit: BoxFit.cover)
                                              : DecorationImage(
                                                  image: NetworkImage(room_img),
                                                  fit: BoxFit.cover))),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        room!.name,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16.0),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        'ID:' + room!.tag,
                                        style: TextStyle(
                                            color: MyColors.unSelectedColor,
                                            fontSize: 11.0),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Row(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            'assets/images/chatroom_rank_ic.png'),
                                        height: 18.0,
                                        width: 18.0,
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        "0",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.0),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 7.0,
                                ),
                                GestureDetector(
                                    child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Icon(
                                          FontAwesomeIcons.shareFromSquare,
                                          color: Colors.white,
                                          size: 20.0,
                                        ))),
                                GestureDetector(
                                  onTap: (){
                                    showModalBottomSheet(
                                        isScrollControlled: true ,
                                        context: context,
                                        builder: (ctx) => roomCloseModal());
                                  },
                                    child: Container(
                                      margin:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                       child: Icon(
                                    FontAwesomeIcons.powerOff,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async{
                              AppUser? res =  await AppUserServices().getUser(room!.userId);
                              showModalBottomSheet(

                                  context: context,
                                  builder: (ctx) => ProfileBottomSheet(res));
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                    radius: 15.0,
                                    backgroundImage: getUserAvatar()),
                                Image(
                                  image: AssetImage(
                                      'assets/images/room_user_small_border.png'),
                                  width: 50,
                                  height: 50,
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              showModalBottomSheet(
                                  isScrollControlled: true ,
                                  context: context,
                                  builder: (ctx) => roomMembersModal());
                            },
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.people_alt,
                                    color: MyColors.primaryColor,
                                    size: 20.0,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    room!.members!.length.toString(),
                                    style: TextStyle(
                                        color: MyColors.primaryColor,
                                        fontSize: 13.0),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 4,
                        children:
                            room!.mics!.map((mic) => micListItem(mic)).toList(),
                        mainAxisSpacing: 0.0,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Image(
                              image: AssetImage('assets/images/messages.png'),
                              width: 40.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Image(
                              image: AssetImage('assets/images/chats.png'),
                              width: 40.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            GestureDetector(
                              onTap: (){
                                showModalBottomSheet(

                                    context: context,
                                    builder: (ctx) => MenuBottomSheet());
                              },
                              child: Image(
                                image: AssetImage('assets/images/menu.png'),
                                width: 40.0,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Image(
                              image: AssetImage('assets/images/mic_on.png'),
                              width: 40.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            GestureDetector(
                              onTap: (){
                                showModalBottomSheet(

                                    context: context,
                                    builder: (ctx) => EmojBottomSheet());
                              },
                                child: Image(
                              image: AssetImage('assets/images/emoj.png'),
                              width: 40.0,
                            )),
                          ],
                        )
                      ],
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            showModalBottomSheet(

                                context: context,
                                builder: (ctx) => giftBottomSheet());
                          },
                          child: Image(
                            image: AssetImage('assets/images/gift_box.webp'),
                            width: 40.0,
                          ),
                        )
                      ],
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget ProfileBottomSheet( user ) => SmallProfileModal(visitor: user);
  ImageProvider getUserAvatar() {
    if (room_img == '') {
      return AssetImage('assets/images/user.png');
    } else {
      return NetworkImage(room_img);
    }
  }

  Widget micListItem(mic) => GestureDetector(
      onTap: (){
     //   micActionList(mic);
      },
    child: Stack(
      alignment: Alignment.center,
      children: [
        Column(
              children: [
                Image(
                  image: getMicUserImg(mic),
                  width: 60.0,
                  height: 60.0,
                ),
                Text(
                  mic!.mic_user_name == null
                      ? mic!.order.toString()
                      : mic!.mic_user_name,
                  style: TextStyle(color: Colors.white, fontSize: 13.0),
                )
              ],
            ),
        PopupMenuButton(
          position: PopupMenuPosition.under,
          shadowColor: MyColors.unSelectedColor,
          elevation: 4.0,

          color: MyColors.darkColor,
          icon: null,
          onSelected: (int result) {
            if(result == 1){
               //use_mic
            }
            else if(result == 2){
              //lock_mic
              MicHelper( user_id:  user!.id , room_id:  room!.id , mic: mic.order).lockMic();
            }
            else if(result == 3){
              //lock_all_mics
              MicHelper( user_id:  user!.id , room_id:  room!.id , mic: 0).lockMic();
            }
            else if(result == 4){
               //unlock_mic
              MicHelper( user_id:  user!.id , room_id:  room!.id , mic: mic.order).unlockMic();
            }
            else if(result == 5){
              //unlock_all_mic
              MicHelper( user_id:  user!.id , room_id:  room!.id , mic: 0).unlockMic();
            }
            else if(result == 6){
              //remove_from_mic
            }
            else if(result == 7){
              //un_use_mic
            }
            else if(result == 8){
              //mute
            }
          },
          itemBuilder: (BuildContext context) =>  AdminMicListItems(mic)
        ),
      ],
    ),
  );
  ImageProvider getMicUserImg(mic) {
    if (mic!.mic_user_img == null) {
      if(mic.isClosed == 0)
      return AssetImage('assets/images/mic_open.png');
      else
      return AssetImage('assets/images/mic_close.png');
    } else {
      return NetworkImage(ASSETSBASEURL + 'AppUsers/' + mic!.mic_user_img);
    }
  }
  // micActionList(mic) async{
  //   if(userRole == 'OWNER'  || userRole == 'ADMIN'){
  //      //admin actions
  //     showPopover(
  //       context: context,
  //       bodyBuilder: (context) =>  AdminMicListItems(mic),
  //       onPop: () => print('Popover was popped!'),
  //       direction: PopoverDirection.bottom,
  //       width: 200,
  //       height: 400,
  //       arrowHeight: 15,
  //       arrowWidth: 30,
  //     );
  //   } else {
  //     // normal user actions
  //     if( mic.user_id == 0){
  //       if(mic.isClosed == 0 ){
  //         showPopover(
  //           context: context,
  //           bodyBuilder: (context) =>  ListView(
  //             children: [
  //               TextButton(onPressed: (){}, child: Text('use_mic'.tr)) ,
  //             ],
  //           ),
  //           onPop: () => print('Popover was popped!'),
  //           direction: PopoverDirection.bottom,
  //           width: 200,
  //           height: 400,
  //           arrowHeight: 15,
  //           arrowWidth: 30,
  //         );
  //       } else {
  //         Fluttertoast.showToast(
  //             msg: 'mic_closed_msg'.tr,
  //             toastLength: Toast.LENGTH_SHORT,
  //             gravity: ToastGravity.CENTER,
  //             timeInSecForIosWeb: 1,
  //             backgroundColor: Colors.black26,
  //             textColor: Colors.orange,
  //             fontSize: 16.0
  //         );
  //       }
  //
  //     } else {
  //       if(mic.user_id != user!.id){
  //         AppUser? res =  await AppUserServices().getUser(room!.userId);
  //         showModalBottomSheet(
  //
  //             context: context,
  //             builder: (ctx) => ProfileBottomSheet(res));
  //       } else {
  //         showPopover(
  //           context: context,
  //           bodyBuilder: (context) =>  ListView(
  //             children: [
  //               TextButton(onPressed: (){}, child: Text('un_use_mic'.tr)),
  //               TextButton(onPressed: (){}, child: Text('mute'.tr)),
  //             ],
  //           ),
  //           onPop: () => print('Popover was popped!'),
  //           direction: PopoverDirection.bottom,
  //           width: 200,
  //           height: 400,
  //           arrowHeight: 15,
  //           arrowWidth: 30,
  //         );
  //       }
  //
  //     }
  //
  //   }
  // }

  Widget EmojBottomSheet( ) => EmojModal();
  Widget giftBottomSheet() => GiftModal();
  Widget MenuBottomSheet() => MenuModal();
  Widget RoomInfoBottomSheet() => RoomInfoModal();
  Widget roomCloseModal() => RoomCloseModal();
  Widget roomMembersModal() => RoomMembersModal();

  List<PopupMenuEntry<int>> AdminMicListItems(mic) {
    if(mic.user_id == 0){
       //emptyMic => use mic , close/open mic , close/open all misc
      if(mic.isClosed == 0){
        print('Admin Mic Open !');
        return
           [
             PopupMenuItem<int>(
               value: 1,
               child: Text('use_mic'.tr , style: TextStyle(color: Colors.white),),
             ),
             PopupMenuItem<int>(
               value: 2,
               child: Text('lock_mic'.tr , style: TextStyle(color: Colors.white),),
             ),
             PopupMenuItem<int>(
               value: 3,
               child: Text('lock_all_mics'.tr , style: TextStyle(color: Colors.white),),
             ),
          ];

      } else {
        return
          [
            PopupMenuItem<int>(
              value: 4,
              child: Text('unlock_mic'.tr , style: TextStyle(color: Colors.white),),
            ),
            PopupMenuItem<int>(
              value: 5,
              child: Text('unlock_all_mic'.tr , style: TextStyle(color: Colors.white),),
            ),

          ];
      }

    } else {
      //MicWithUSer => delete from mic ,
      if(mic.user_id != user!.id){
        return
          [
            PopupMenuItem<int>(
            value: 6,
            child: Text('remove_from_mic'.tr , style: TextStyle(color: Colors.white),),
          ),


          ];

      } else {
        return
          [
            PopupMenuItem<int>(
              value: 7,
              child: Text('un_use_mic'.tr , style: TextStyle(color: Colors.white),),
            ),
            PopupMenuItem<int>(
              value: 8,
              child: Text('mute'.tr , style: TextStyle(color: Colors.white),),
            ),

          ];

      }
    
    }
  }






  

}

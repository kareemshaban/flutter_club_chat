import 'package:clubchat/helpers/DesigGiftHelper.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      sendGiftReceiverType = "select_one_ore_more";
      user = AppUserServices().userGetter();
      room = ChatRoomService().roomGetter();
      if (room!.img == room!.admin_img) {
        room_img = '${ASSETSBASEURL}AppUsers/${room?.img}';
      } else {
        room_img = '${ASSETSBASEURL}Rooms/${room?.img}';
      }
    });

    geAdminDesigns();
    getRoomBasicData();
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
                          Stack(
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

  ImageProvider getUserAvatar() {
    if (room_img == '') {
      return AssetImage('assets/images/user.png');
    } else {
      return NetworkImage(room_img);
    }
  }

  Widget micListItem(mic) => Column(
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

  Widget EmojBottomSheet( ) => EmojModal();
  Widget giftBottomSheet() => GiftModal();
  Widget MenuBottomSheet() => MenuModal();
  Widget RoomInfoBottomSheet() => RoomInfoModal();
  Widget roomCloseModal() => RoomCloseModal();
  Widget roomMembersModal() => RoomMembersModal();




  

}

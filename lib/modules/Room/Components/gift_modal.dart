
import 'package:clubchat/helpers/RoomBasicDataHelper.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/Category.dart';
import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/models/Gift.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/ChatRoomService.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GiftModal extends StatefulWidget {
  const GiftModal({super.key});

  @override
  State<GiftModal> createState() => _GiftModalState();
}

class _GiftModalState extends State<GiftModal> with TickerProviderStateMixin{
  String sendGiftReceiverType = "";
  AppUser? user ;
  ChatRoom? room ;
  TabController? _tabController ;
  List<Category> categories = [];
  List<Gift> gifts = [] ;
  List<Widget> giftTabs = [] ;
  List<Widget> giftViews = [] ;
  int? selectedGift ;
  int? sendGiftCount ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      sendGiftCount = 1 ;
      sendGiftReceiverType = "select_one_ore_more";
      user = AppUserServices().userGetter();
      room = ChatRoomService().roomGetter();
      RoomBasicDataHelper? helper = ChatRoomService().roomBasicDataHelperGetter();
      categories = helper!.categories ;
      gifts = helper.gifts ;
      selectedGift = gifts.where((element) => element.gift_category_id == categories[0].id).toList()[0].id ;
      _tabController = new TabController(vsync: this, length: categories.length);
      getGiftCatsTabs();
      getGiftViewTabs();

    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(color: Colors.black.withAlpha(180),
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(15.0)) ,
          border: Border(top: BorderSide(width: 3.0, color: MyColors.primaryColor),) ),
      child:  Column(
        children: [
          Container(
            height: 50.0,
            width: double.infinity,
            child: Row(children: [
              PopupMenuButton(
                position: PopupMenuPosition.under,
                shadowColor: MyColors.unSelectedColor,
                elevation: 4.0,

                color: MyColors.darkColor,
                icon: Icon(Icons.expand_circle_down , color: MyColors.primaryColor,),
                onSelected: (String result) {
                  setState(() {
                    sendGiftReceiverType = result ;
                    print(sendGiftReceiverType);
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'select_one_ore_more',
                    child: Text('gift_one_or_more_user'.tr , style: TextStyle(color: Colors.white),),
                  ),
                  PopupMenuItem<String>(
                    value: 'all_mic_users',
                    child: Text('gift_all_mic_users'.tr , style: TextStyle(color: Colors.white),),
                  ),
                  PopupMenuItem<String>(
                    value: 'all_room_members',
                    child: Text('gift_all_room_users'.tr , style: TextStyle(color: Colors.white),),

                  )
                ],
              ),
              Expanded(child:
              sendGiftReceiverType != "all_room_members" ?
              ListView.separated(itemBuilder: (ctx , index) => giftBoxMicUserListItem(index),
                separatorBuilder:  (ctx , index) => giftBoxMicUserSperator() , itemCount: room!.mics!.where((e) => e.user_id >0).length ,
                scrollDirection: Axis.horizontal,) :
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("gift_send_to_all_room_members".tr , style: TextStyle(color: MyColors.primaryColor),)
                ],
              )
              ),
            ],),
          ),
          Container(
            height: 1.0,
            width: double.infinity,
            color: MyColors.lightUnSelectedColor,
          ),
          TabBar(
            dividerColor: MyColors.lightUnSelectedColor,
            tabAlignment: TabAlignment.start,
            isScrollable: true ,
            unselectedLabelColor: MyColors.unSelectedColor,
            labelColor: MyColors.whiteColor,
            indicatorColor: MyColors.primaryColor,
            controller: _tabController,
            labelStyle: const TextStyle(fontSize: 17.0 , fontWeight: FontWeight.w900),
            tabs:  giftTabs,
          ),
          SizedBox(height: 5.0,),
          Expanded(child: TabBarView(children: giftViews ,   controller: _tabController,)),

        ],
      ),
    );
  }

  Widget giftBoxMicUserListItem(index) => CircleAvatar(
    radius: 12.0,
      backgroundImage: getGiftBoxMicUserImage(index) ,

  );
  ImageProvider getGiftBoxMicUserImage(index){
    if(room!.mics![index].mic_user_img != null){
      if(room!.mics![index].mic_user_img != ""){
        return NetworkImage(ASSETSBASEURL + 'AppUsers/' + room!.mics![index].mic_user_img! );
      } else {
        return AssetImage('assets/images/user.png');
      }
    }else {
      return AssetImage('assets/images/user.png');
    }

  }
  Widget giftBoxMicUserSperator() => SizedBox(width: 10.0,);

  getGiftCatsTabs(){
    List<Widget> t = [] ;
    for(var i = 0 ; i < categories.length ; i++){
      Widget tab = Tab(text: categories[i].name);
      t.add(tab);
      setState(() {
        giftTabs = t ;
      });
    }

  }

  getGiftViewTabs() {
    List<Widget> t = [] ;
    for(var i = 0 ; i < categories.length ; i++){
      Widget tab = getGiftViewTab(categories[i].id);
      t.add(tab);
    }
    setState(() {
      giftViews = t ;
    });
  }
  Widget getGiftViewTab(id) =>    Column(
    children: [
      Expanded(
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          childAspectRatio: .8,
          children:
          gifts.where((element) => element.gift_category_id == id).map((gift) => giftListItem(gift)).toList(),
          mainAxisSpacing: 3.0,
          crossAxisSpacing: 3.0,
        ),
      ),
      Container(
        color: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        height: 50.0,
        child: Row(
          children: [
            Column(
              children: [
                 Row(
                  children: [
                    Image(image: AssetImage('assets/images/gold.png') , width: 25.0,),
                    SizedBox(width: 5.0,),
                    Text(user!.gold.toString() , style: TextStyle(color: MyColors.primaryColor , fontSize: 13.0),),
                    IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_outlined , color: MyColors.primaryColor, size: 20.0,)  )
                  ],
                ),
              ],
            ),
            Expanded(
              child: Column(
                 crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 160.0,
                    height: 40.0,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(borderRadius:BorderRadius.circular(22.0) , border: Border.all(color: MyColors.primaryColor , width: 2.0)),
                    child: Row(
                      children: [
                        Container(
                          width: 96.0,
                          child: Row(
                            children: [
                              PopupMenuButton(
                                position: PopupMenuPosition.over,
                                shadowColor: MyColors.unSelectedColor,
                                elevation: 4.0,

                                color: MyColors.darkColor,
                                icon: Icon(Icons.arrow_drop_down , color: MyColors.whiteColor,),
                                onSelected: (int result) {
                                  setState(() {
                                    sendGiftCount = result ;
                                    getGiftViewTabs ();
                                  });
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                                  PopupMenuItem<int>(
                                    value: 1,
                                    child: Text('1' , style: TextStyle(color: Colors.white),),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 7,
                                    child: Text('7' , style: TextStyle(color: Colors.white),),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 17,
                                    child: Text('17' , style: TextStyle(color: Colors.white),),

                                  ),
                                  PopupMenuItem<int>(
                                    value: 77,
                                    child: Text('77' , style: TextStyle(color: Colors.white),),

                                  )
                                ],
                              ),
                              Container( child: Text(sendGiftCount.toString() , style: TextStyle(color: Colors.white , fontSize: 12.0),))
                            ],
                          ),
                        ),
                        Container(
                          width: 60.0,
                          height:40.0,
                          decoration: BoxDecoration(color: MyColors.primaryColor ,
                              borderRadius:BorderRadiusDirectional.only(topEnd: Radius.circular(20.0) , bottomEnd: Radius.circular(20.0))),
                          child: Center(child: Text("gift_send".tr , style: TextStyle(color: MyColors.darkColor , fontSize: 15.0),)),
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    ],
  );

  Widget giftListItem (gift) => GestureDetector(
    onTap: (){
      print(selectedGift);
      setState(() {
        selectedGift = gift.id;
        getGiftViewTabs ();
      });
    },
    child: Container(
      decoration: BoxDecoration(border: gift.id == selectedGift ? Border.all(color: MyColors.primaryColor , width: 1.0) : Border.all(color: Colors.transparent , width: 1.0) ,
        borderRadius: BorderRadius.circular(15.0) ,  ),
      child: Column(
        children: [
          Image(image: NetworkImage(ASSETSBASEURL + 'Designs/' + gift.icon) , width: 70.0,),
          Text(gift.name , style: TextStyle(color: Colors.white , fontSize: 12.0),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/images/gold.png') , width: 20.0,),
              Text(gift!.price , style: TextStyle(color: MyColors.primaryColor , fontSize: 12.0 , fontWeight: FontWeight.bold),)                      ],
          ),

        ],
      ),
    ),
  );
}

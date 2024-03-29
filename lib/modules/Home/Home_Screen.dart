import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:clubchat/helpers/ExitRoomHelper.dart';
import 'package:clubchat/helpers/MicHelper.dart';
import 'package:clubchat/layout/tabs_screen.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/Banner.dart';
import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/models/Country.dart';
import 'package:clubchat/models/FestivalBanner.dart';
import 'package:clubchat/modules/AppCup/app_cup_screen.dart';
import 'package:clubchat/modules/Loading/loadig_screen.dart';
import 'package:clubchat/modules/Room/Room_Screen.dart';
import 'package:clubchat/modules/Search_Screen/SearchScreen.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/BannerServices.dart';
import 'package:clubchat/shared/network/remote/ChatRoomService.dart';
import 'package:clubchat/shared/network/remote/CountryService.dart';
import 'package:clubchat/shared/network/remote/FestivalBannerServices.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {


  //vars
  List<BannerData> banners = [] ;
  List<Country> countries = [] ;
  List<ChatRoom> rooms = [] ;
  List<FestivalBanner> festivalBanners = [] ;
  List<String> chatRoomCats = ['CHAT' , 'FRIENDS' , 'QURAN' , 'GAMES' , 'ENTERTAINMENT'];
  int selectedCountry = 0 ;
  String selectedChatRoomCategory = 'CHAT' ;
  bool loaded = false ;
  bool loading = false ;
  var passwordController = TextEditingController();
  HomeScreenState()  {

  }

   getBanners() async {
    setState(() {
      loading = true ;
     });
    List<BannerData> res = await BannerServices().getAllBanners();
    setState(() {
      banners = res ;
    });
     List<Country> res2 = await CountryService().getAllCountries();
    setState(() {
      countries = res2 ;
      CountryService().countrySetter(countries);
    });
    List<ChatRoom> res3 = await ChatRoomService().getAllChatRooms();
    setState(() {
      rooms = res3 ;
      loaded = true ;
    });
    List<FestivalBanner> res4 = await FestivalBannerService().getAllBanners();
    setState(() {
      festivalBanners = res4 ;
      print('FestivalBanner');

    });
    setState(() {
      loading = false ;
    });
  }
  //var
  AppUser? user ;
  Future<void> _refresh ()async{
    await getBanners() ;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Wakelock.enable();
    setState(() {
      user =  AppUserServices().userGetter();
    });
    getMicPermission();
    getBanners();
  }
  getMicPermission() async{
    await [Permission.microphone].request();
  }
  connectToWs() {

  }
  @override
  Widget build(BuildContext context) {
    return   DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.darkColor,
          title:  TabBar(
           dividerColor: Colors.transparent,
            tabAlignment: TabAlignment.start,
            isScrollable: true ,
            indicatorColor: MyColors.primaryColor,
            labelColor: MyColors.primaryColor,
            unselectedLabelColor: MyColors.unSelectedColor,
            labelStyle: const TextStyle(fontSize: 17.0 , fontWeight: FontWeight.w900),

            tabs:  [
              Tab(text: "home_party".tr ),
              Tab(text: "home_discover".tr,),
            ],
          ) ,
          actions:   [

            GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: const Image(
                  image: AssetImage('assets/images/chatroom_rank_ic.png') , width: 30.0, height: 30.0,),
                  onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AppCupScreen(),));
                  }
            ),
            const SizedBox(width: 20.0,),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: const Image(
                  image: AssetImage('assets/images/voice-message.png') , width: 30.0, height: 30.0,),
                onTap: (){
                  openMyRoom();
                }
            ),
            const SizedBox(width: 20.0,),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: const Image(
                  image: AssetImage('assets/images/search.png') , width: 30.0, height: 30.0,),
                onTap: () =>  Navigator.push(context,  MaterialPageRoute(builder: (ctx) => const SearchScreen()))
            ),

            const SizedBox(width: 10.0,),
          ],
        ),
        body: Container(
          color: MyColors.darkColor,
          width: double.infinity,
          child: loading ? Loading() : TabBarView(
            children: [
              // home
              Skeletonizer(
                enabled: !loaded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0 , vertical: 10.0),

                      child: CarouselSlider(items:
                      banners.map((banner) => Container(

                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0) ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.network('${ASSETSBASEURL}Banners/${banner.img}' , fit: BoxFit.cover, ),
                      )).toList()
                          , options: CarouselOptions( aspectRatio: 3 , autoPlay: true , viewportFraction: 1.0)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      height:40.0,
                      child: ListView.separated(itemBuilder: (ctx , index) => countryListItem(index)  , separatorBuilder: (ctx , index) => countryListSpacer(), itemCount: countries.length , scrollDirection: Axis.horizontal,),

                    ),
                    const SizedBox(height: 10.0,),
                    Expanded(
                      child: RefreshIndicator(
                        color: MyColors.primaryColor,
                        onRefresh: _refresh,
                        child: GridView.count(
                          crossAxisCount: 2,
                          children: rooms.where((element) => element.country_id == selectedCountry || selectedCountry == 0).map((room ) => chatRoomListItem(room)).toList() ,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //discover
              Column(
                children: [
                  festivalBanners.length > 0 ?  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0 , vertical: 10.0),

                    child: CarouselSlider(items:
                    festivalBanners.map((banner) => Container(

                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0) ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network('${ASSETSBASEURL}FestivalBanner/${banner.img}' , fit: BoxFit.cover, ),
                    )).toList()
                        , options: CarouselOptions( aspectRatio: 3 , autoPlay: true , viewportFraction: 1.0)),
                  ) : Container(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    height:40.0,
                    child: ListView.separated(itemBuilder: (ctx , index) => chatRoomCategoryListItem(index)  , separatorBuilder: (ctx , index) => countryListSpacer(), itemCount: chatRoomCats.length , scrollDirection: Axis.horizontal,),

                  ),
                  const SizedBox(height: 10.0,),
                  Expanded(
                    child: RefreshIndicator(
                      color: MyColors.primaryColor,
                      onRefresh: _refresh,
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: rooms.where((element) => element.subject == selectedChatRoomCategory).map((room ) => chatRoomListItem(room)).toList() ,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget countryListItem(index) => countries.isNotEmpty ?  GestureDetector(
   onTap: (){
     setState(() {
       selectedCountry = countries[index].id;
     });
   },
   child: Container(
     padding: const EdgeInsets.all(10.0),
     decoration: BoxDecoration(border: Border.all(color: MyColors.unSelectedColor , width: 1.0 , style: BorderStyle.solid) , borderRadius: BorderRadius.circular(25.0) ,
     color: countries[index].id == selectedCountry ? MyColors.primaryColor : MyColors.lightUnSelectedColor),
     child:  Row(
       mainAxisSize: MainAxisSize.min,
       mainAxisAlignment: MainAxisAlignment.end,
       children: [
     countries[index].id > 0 ? Image(image:  NetworkImage('${ASSETSBASEURL}Countries/${countries[index].icon}')  , width: 30.0,) :
     Image(image:  AssetImage(countries[index].icon)  , width: 30.0,)    ,
         const SizedBox(width: 5.0,),
         Text(countries[index].name , style: TextStyle(color: MyColors.whiteColor , fontSize: 13.0),)
       ],),
   ),
 ) : Container();
 Widget countryListSpacer() => const SizedBox(width: 5.0,);

 Widget chatRoomListItem(room) =>  GestureDetector(
     onTap: (){openRoom(room.id);} ,
     child: Container(
         width: MediaQuery.of(context).size.width / 2 ,
       margin: const EdgeInsets.all(5.0),
       child: Stack(
         alignment: Alignment.topCenter,
         children: [
           Stack(
             alignment: Alignment.bottomCenter,
             children: [
               Container(
               width: MediaQuery.of(context).size.width / 2 ,
               height: MediaQuery.of(context).size.width / 2 ,

               decoration: BoxDecoration( borderRadius: BorderRadius.circular(15.0) ,
               image: DecorationImage(image: getRoomImage(room), fit: BoxFit.cover,
                   colorFilter:  ColorFilter.mode(Colors.grey.withOpacity(.9), BlendMode.dstATop)
               )),),

               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 5.0 , vertical: 10.0),
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [

                      Expanded(child: Text(room.name  , textAlign: TextAlign.end, overflow: TextOverflow.ellipsis ,style: TextStyle(color: MyColors.whiteColor , fontSize: 12.0 , fontWeight: FontWeight.bold , ))),
                      Expanded(child: Text(room.tag , textAlign: TextAlign.end , style: TextStyle(color: MyColors.whiteColor , fontSize: 12.0 , fontWeight: FontWeight.bold))),
                 ],),
               )
             ],
           ),
           Container(
             child: Row(
               mainAxisAlignment: MainAxisAlignment.end,
               mainAxisSize: MainAxisSize.max,
               children: [

                 Container(
                   width: ((MediaQuery.of(context).size.width / 2 ) - 50 ),
                   child: Row(
                     children: [
                       Container(
                         decoration:  BoxDecoration( color: getMyColor(room.subject)

                             , borderRadius: BorderRadiusDirectional.only(bottomEnd: Radius.circular(15.0) , topStart: Radius.circular(15.0))),
                         width: 60.0 ,
                         height: 30.0,
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text(room.subject.toString().toLowerCase(), style: TextStyle(fontSize: 15.0 , color: MyColors.whiteColor),)
                           ],
                         ),
                       ),
                     ],
                   ),
                 ),
                 Container(

                     margin: EdgeInsets.all(5.0),
                     child: Image(image: NetworkImage(ASSETSBASEURL + 'Countries/' + room.flag), width: 30.0, )),
               ],),
           )
         ],
       ),
     ),
 );


  Widget chatRoomCategoryListItem(index) => chatRoomCats.isNotEmpty ?  GestureDetector(
    onTap: (){
      setState(() {
        selectedChatRoomCategory = chatRoomCats[index];
      });
    },
    child: Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.transparent , width: 1.0 , style: BorderStyle.solid) , borderRadius: BorderRadius.circular(25.0) ,
          color: chatRoomCats[index] == selectedChatRoomCategory ? MyColors.primaryColor : MyColors.lightUnSelectedColor),
      child:  Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('#${chatRoomCats[index].toLowerCase()}' , style: TextStyle(color: chatRoomCats[index] == selectedChatRoomCategory ?  MyColors.darkColor : MyColors.whiteColor , fontSize: 15.0),)
        ],),
    ),
  ) : Container();

 void openChatRoom(room){

 }
 void takeBannerAction(index){

 }
 Color getMyColor(String subject){
   if(subject == "CHAT"){
     return MyColors.primaryColor.withOpacity(.8) ;
   } else if(subject == "FRIENDS"){
     return MyColors.successColor.withOpacity(.8) ;
   }else if(subject == "GAMES"){
     return MyColors.blueColor.withOpacity(.8) ;
   }
   else {
     return MyColors.primaryColor.withOpacity(.8) ;
   }

 }

 void openTrendPage() {

 }
 void openMyRoom() async{
   ChatRoom? room =  await ChatRoomService().openMyRoom(user!.id);
   await checkForSavedRoom(room!);
    ChatRoomService().roomSetter(room);
   Navigator.push(context, MaterialPageRoute(builder: (ctx) => const RoomScreen()));
 }
  void openSearch(){
    Navigator.push( context,  MaterialPageRoute(builder: (context) =>  const SearchScreen()));
  }

 void openRoom(id) async{

   ChatRoom? res = await ChatRoomService().openRoomById(id);
   if(res != null){
     await checkForSavedRoom(res);
     if(res.state == 0 || res.userId == user!.id){
       ChatRoomService().roomSetter(res);
       Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen(),));
     } else {

       //showPassword popup
       _displayTextInputDialog(context , res);
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

 ImageProvider getRoomImage(room){
   String room_img = '';
   if(room!.img == room!.admin_img){
       if(room!.admin_img != ""){
         room_img = '${ASSETSBASEURL}AppUsers/${room?.img}' ;
       } else {
         room_img = '${ASSETSBASEURL}Defaults/room_default.png' ;
       }

   } else {
     if(room?.img != ""){
       room_img = '${ASSETSBASEURL}Rooms/${room?.img}' ;
     } else {
       room_img = '${ASSETSBASEURL}Defaults/room_default.png' ;
     }

   }
  return  NetworkImage(room_img);
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



}

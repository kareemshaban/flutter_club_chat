import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:clubchat/layout/tabs_screen.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/Banner.dart';
import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/models/Country.dart';
import 'package:clubchat/models/FestivalBanner.dart';
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
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:skeletonizer/skeletonizer.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  double _xPosition = 1.0;
  double _yPosition = 1.0;

  //vars
  List<BannerData> banners = [] ;
  List<Country> countries = [] ;
  List<ChatRoom> rooms = [] ;
  List<FestivalBanner> festivalBanners = [] ;
  List<String> chatRoomCats = ['CHAT' , 'FRIENDS' , 'QURAN' , 'GAMES' , 'ENTERTAINMENT'];
  int selectedCountry = 0 ;
  String selectedChatRoomCategory = 'CHAT' ;
  bool loaded = false ;
  HomeScreenState()  {

  }

   getBanners() async {
    List<BannerData> res = await BannerServices().getAllBanners();
    setState(() {
      banners = res ;
      print(banners[0].img);
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
      print(FestivalBanner);
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
    //PusherChannelsFlutter pusher =
    setState(() {
      user =  AppUserServices().userGetter();
      print(user!.id);
    });

    getBanners();
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
                  onTap: (){}
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
          child: TabBarView(
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0 , vertical: 10.0),

                    child: CarouselSlider(items:
                    festivalBanners.map((banner) => Container(

                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0) ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network('${ASSETSBASEURL}FestivalBanner/${banner.img}' , fit: BoxFit.cover, ),
                    )).toList()
                        , options: CarouselOptions( aspectRatio: 3 , autoPlay: true , viewportFraction: 1.0)),
                  ),
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
    ChatRoomService().roomSetter(room!);
   print(room);
   Navigator.push(context, MaterialPageRoute(builder: (ctx) => const RoomScreen()));
 }
  void openSearch(){
    Navigator.push( context,  MaterialPageRoute(builder: (context) =>  const SearchScreen()));
  }

 void openRoom(id) async{

   ChatRoom? res = await ChatRoomService().openRoomById(id);
   if(res != null){
     ChatRoomService().roomSetter(res);
     Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen(),));

   }
 }

 ImageProvider getRoomImage(room){
   String room_img = '';
   if(room!.img == room!.admin_img){

     room_img = '${ASSETSBASEURL}AppUsers/${room?.img}' ;
   } else {
     room_img = '${ASSETSBASEURL}Rooms/${room?.img}' ;
   }
  return  NetworkImage(room_img);
 }

}

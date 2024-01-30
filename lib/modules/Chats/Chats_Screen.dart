
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/modules/chat/chat.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/Friends.dart';
import '../../shared/components/Constants.dart';
import '../../shared/styles/colors.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => ChatsScreenState();
}

class ChatsScreenState extends State<ChatsScreen> {
  var userTxt = TextEditingController()  ;
  List<Friends>? friends = [];
  AppUser? user;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
      friends = user!.friends ;
    });
  }

  Future<void> _refresh()async{
    await loadData() ;
  }
  loadData() async {
    AppUser? res = await AppUserServices().getUser(user!.id);
    setState(() {
      user = res;
      friends = user!.friends ;
      AppUserServices().userSetter(user!);
    });
  }
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.darkColor,
          title: TabBar(
            dividerColor: Colors.transparent,
            tabAlignment: TabAlignment.start,
            isScrollable: true ,
            indicatorColor: MyColors.primaryColor,
            labelColor: MyColors.primaryColor,
            unselectedLabelColor: MyColors.unSelectedColor,
            labelStyle: const TextStyle(fontSize: 17.0 , fontWeight: FontWeight.w900),

            tabs:  [
              Tab(text: "chats_massage".tr ),
              Tab(text: "chats_friends".tr,),
            ],
          ) ,
          actions: [
            IconButton(onPressed: (){

            }, icon: const Icon(Icons.cleaning_services_rounded , color: Colors.white , size: 30.0,))
          ],
          ),
        body: Container(
          color: MyColors.darkColor,
          width: double.infinity,
          child: TabBarView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 10.0),
                    child: Row(
                      children: [
                        //SizedBox(width: 8.0,),
                        Expanded(child: Column(
                          children: [
                            Container(
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.deepOrange.withAlpha(180) ,
                                borderRadius: BorderRadius.circular(12.0)
                              ),
                              child: Row(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                         Container(
                                           padding: EdgeInsets.symmetric(horizontal: 8.0)  ,
                                           width: (MediaQuery.of(context).size.width / 3 - 50 ),
                                           child: Text('chats_event_message'.tr , style: TextStyle(color: Colors.white ,
                                               fontSize: 15.0 , fontWeight: FontWeight.bold),),
                                         ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image(image: AssetImage('assets/images/notification-bell.png') , width: 35.0, height: 35.0,),
                                      ],
                                    )
                                  ],
                              )
                            )
                          ],
                        )),
                        SizedBox(width: 5.0,),
                        Expanded(child: Column(
                          children: [
                            Container(
                                height: 70,
                                decoration: BoxDecoration(
                                    color: Colors.blue.withAlpha(180) ,
                                    borderRadius: BorderRadius.circular(12.0)
                                ),
                                child: Row(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8.0)  ,
                                          width: (MediaQuery.of(context).size.width / 3 - 50 ),
                                          child: Text('notification_setting_new_followers'.tr , style: TextStyle(color: Colors.white ,
                                              fontSize: 14.0 , fontWeight: FontWeight.bold),),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image(image: AssetImage('assets/images/users.png') , width: 35.0, height: 35.0,),
                                      ],
                                    )
                                  ],
                                )
                            )
                          ],
                        )),
                        SizedBox(width: 5.0,),
                        Expanded(child: Column(
                          children: [
                            Container(
                                height: 70,
                                decoration: BoxDecoration(
                                    color: Colors.green.withAlpha(180) ,
                                    borderRadius: BorderRadius.circular(12.0)
                                ),
                                child: Row(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8.0)  ,
                                          width: (MediaQuery.of(context).size.width / 3 - 50 ),
                                          child: Text('chats_club_chat_service'.tr , style: TextStyle(color: Colors.white ,
                                              fontSize: 14.0 , fontWeight: FontWeight.bold),),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image(image: AssetImage('assets/images/customer-service.png') , width: 35.0, height: 35.0,),
                                      ],
                                    ),
                                  ],
                                )
                            )
                          ],
                        )),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.black26,
                    padding: EdgeInsets.all(15.0) ,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28.0,backgroundColor: Colors.purple,
                          child: Image(image: AssetImage('assets/images/control-system.png') , width: 35.0, height: 35.0,),
                        ),
                        SizedBox(width: 14.0,),
                        Text("chats_system_massage".tr,style: TextStyle(fontSize: 17.0,color: Colors.white),)
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (ctx,index)=> build_list(ctx),
                      separatorBuilder: (ctx,index)=>SizedBox(height: 1.0,),
                      itemCount: 3
                  ),
                ],
              ),

              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),

                    child: Column(
                      children: [
                        Container(
                          height: 45.0 ,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0) , color: MyColors.lightUnSelectedColor,),
                          child: TextField( controller: userTxt, decoration: InputDecoration(labelText: "chat_search_friend".tr , suffixIcon: IconButton(icon: const Icon(Icons.search , color: Colors.white, size: 25.0,),
                            onPressed: (){searchUsers();},) , fillColor: MyColors.primaryColor, focusColor: MyColors.primaryColor, focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ,
                              borderSide: BorderSide(color: MyColors.whiteColor) ) ,  border: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ) , labelStyle: const TextStyle(color: Colors.white , fontSize: 13.0) ,  ),
                            style: const TextStyle(color: Colors.white , fontSize: 10.0), cursorColor: MyColors.primaryColor,),
                        ),
                        SizedBox(height: 20.0,),
                        // Expanded(
                        //   child: RefreshIndicator(
                        //     onRefresh: _refresh,
                        //     color: MyColors.primaryColor,
                        //     child: ListView.separated(shrinkWrap: true,  itemBuilder: (ctx , index) =>itemListBuilder(index) ,
                        //         separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: friends!.length),
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],

              )
            ],

          ),
        ),
        ),
      );
  }

  Widget build_list(ctx) => GestureDetector(
  onTap: (){
    Navigator.push(ctx, MaterialPageRoute(builder:(context) => ChatScreen(
        receiverUserEmail: 'receiverUserEmail',
        receiverUserID: 'receiverUserID'
    ),));
  },
    child: Container(
      color: Colors.black26,
      padding: EdgeInsets.all(15.0) ,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 28.0,
                backgroundImage: AssetImage('assets/images/user.png') ,
                backgroundColor: Colors.black26,
              ),
            ],
          ),
          SizedBox(width: 15.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Mohamed Yousri' , style: TextStyle(color: Colors.white , fontSize: 16.0),),
              SizedBox(height: 5.0,),
              Text('Hello World!!', style: TextStyle(color: Colors.grey[600]),),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text('Yesterday', style: TextStyle(color: Colors.grey[600]),),
                    SizedBox(width: 5.0),
                    Text('03:02', style: TextStyle(color: Colors.grey[600]),),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );

  Widget itemListBuilder(index) => Column(
    children: [
      Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: friends![index].follower_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,

                  backgroundImage: friends![index].follower_img != "" ?
                  NetworkImage('${ASSETSBASEURL}AppUsers/${friends![index].follower_img}') : null,
                  radius: 30,
                  child: friends![index].follower_img == "" ?
                  Text(friends![index].follower_name.toUpperCase().substring(0 , 1) +
                      (friends![index].follower_name.contains(" ") ? friends![index].follower_name.substring(friends![index].follower_name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                    style: const TextStyle(color: Colors.white , fontSize: 24.0 , fontWeight: FontWeight.bold),) : null,
                )
              ],
            ),
            const SizedBox(width: 10.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(friends![index].follower_name , style: TextStyle(color: MyColors.whiteColor , fontSize: 18.0),),
                    const SizedBox(width: 5.0,),
                    CircleAvatar(
                      backgroundColor: friends![index].follower_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                      radius: 10.0,
                      child: friends![index].follower_gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                    )
                  ],
                ),
                Row(

                  children: [
                    Image(image: NetworkImage(ASSETSBASEURL + 'Levels/' + friends![index].share_level_img) , width: 40,),
                    const SizedBox(width: 10.0,),
                    Image(image: NetworkImage(ASSETSBASEURL + 'Levels/' + friends![index].karizma_level_img) , width: 40,),
                    const SizedBox(width: 10.0,),
                    Image(image: NetworkImage(ASSETSBASEURL + 'Levels/' + friends![index].charging_level_img) , width: 30,),

                  ],
                ),

                Text("ID:${friends![index].follower_tag}" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 13.0),),


              ],

            ),

          ]),
      Container(
        width: double.infinity,
        height: 1.0,
        color: MyColors.lightUnSelectedColor,
        margin: EdgeInsetsDirectional.only(start: 50.0),
        child: const Text(""),
      )
    ],
  );

  Widget itemSperatorBuilder() => SizedBox(height: 5.0,);

  void searchUsers() {}
}



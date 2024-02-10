

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/Chat.dart';
import 'package:clubchat/modules/CustomerService/customer_service_screen.dart';
import 'package:clubchat/modules/EventMessage/event_message_screen.dart';
import 'package:clubchat/modules/Followers/Followers_Screen.dart';
import 'package:clubchat/modules/SystemMessage/system_message_screen.dart';
import 'package:clubchat/modules/chat/chat.dart';
import 'package:clubchat/modules/chat_service/chat_service.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/ChatServic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/Friends.dart';
import '../../shared/components/Constants.dart';
import '../../shared/styles/colors.dart';
import '../Loading/loadig_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => ChatsScreenState();
}

class ChatsScreenState extends State<ChatsScreen> {
  bool isloading = false ;
  var userTxt = TextEditingController()  ;
  List<Friends>? friends = [];
  List<Chat> chats = [] ;
  AppUser? user;
  AppUser? reciver ;
  final FirebaseAuth _auth = FirebaseAuth.instance ;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
      friends = user!.friends ;
    });
    getUserChats();
  }
  getUserChats() async {
     setState(() {
       isloading = true ;
     });
     List<Chat> res = await ChatApiService().getuserChats(user!.id);
     print(res);
     setState(() {
       chats = res ;
     });
     setState(() {
       isloading = false ;
     });
  }
  Future<void> _refresh()async{
    await loadData() ;
  }
  loadData() async {
    AppUser? res = await AppUserServices().getUser(user!.id);
    await getUserChats();
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
            IconButton(onPressed: () async{
              showDialog(
                context: context,
                builder: (BuildContext context){
                  context = context;
                  return const Loading();
                },
              );
              await Future.delayed(Duration(milliseconds: 3000));
              Navigator.pop(context);

              Fluttertoast.showToast(
                  msg: 'chats_update_data_msg'.tr,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black26,
                  textColor: Colors.orange,
                  fontSize: 16.0
              );

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
                                         GestureDetector(
                                           behavior: HitTestBehavior.opaque,
                                           onTap: (){
                                             Navigator.push(context, MaterialPageRoute(builder: (ctx) => const EventMessage(),),);
                                           },
                                           child: Container(
                                             padding: EdgeInsets.symmetric(horizontal: 8.0)  ,
                                             width: (MediaQuery.of(context).size.width / 3 - 50 ),
                                             child: Text('chats_event_message'.tr , style: TextStyle(color: Colors.white ,
                                                 fontSize: 15.0 , fontWeight: FontWeight.bold),),
                                           ),
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
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (ctx) => const FollowersScreen(),),);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8.0)  ,
                                            width: (MediaQuery.of(context).size.width / 3 - 50 ),
                                            child: Text('notification_setting_new_followers'.tr , style: TextStyle(color: Colors.white ,
                                                fontSize: 14.0 , fontWeight: FontWeight.bold),),
                                          ),
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
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (ctx) => const CustomerService(),),);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8.0)  ,
                                            width: (MediaQuery.of(context).size.width / 3 - 50 ),
                                            child: Text('chats_club_chat_service'.tr , style: TextStyle(color: Colors.white ,
                                                fontSize: 14.0 , fontWeight: FontWeight.bold),),
                                          ),
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
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SystemMessage())) ;
                    },
                    child: Container(
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
                  ),
                  SizedBox(height: 10.0),
                  isloading ? Loading() : Container() ,
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context,index) =>build_list_chats(chats[index]),
                        separatorBuilder: (context,index) =>Padding(
                          padding: const EdgeInsetsDirectional.only(start: 10.0),
                          child: Container(
                            color: Colors.grey,
                            height: 1,
                            width: double.infinity,
                          ),
                        ),
                        itemCount: chats.length
                    ),
                  ),
                ],
              ),
              Column(
                children: [],
              )

            ],

          ),
        ),
        ),
      );
  }
  // build a list of users except for the current logged in user
  Widget _buildUserList(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chat_rooms').snapshots(),
      builder: (context,snapshot){
        if(snapshot.hasError){
          return const Text('error') ;
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text('loading') ;
        }
        return Expanded(
          child: ListView(
              children:
              snapshot.data!.docs
                  .map<Widget>((doc) => _buildUserListItem(doc),
              ).toList()
          ),
        );
      },
    );
  }
//build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document){
    Map<String , dynamic> data = document.data()! as Map<String,dynamic>;
    //display all users except current user
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0 , horizontal: 5.0),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Center(
            child: ListTile(
              title: Text(document.id, style: TextStyle(color: Colors.white),),
              onTap: (){
                // pass the clicked user's UID to the chat page
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => ChatScreen(
                //         receiverUserEmail: data['email'],
                //         receiverUserID: data['uid'],
                //         receiver: user!,
                //       ),
                //     )
                // );
              },
            ),
          ),
        ),
      );

  }

  Widget build_list_chats(Chat article) =>  GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () async{
      AppUser? rec = await AppUserServices().getUser(article.reciver_id);
      Navigator.push(context, MaterialPageRoute(builder: (ctx) =>  ChatScreen(
        receiverUserEmail:  rec!.email ,
        receiverUserID: article.reciver_id,
        receiver: rec,
      )
      )
      );
    },
    child: Container(
      color: Colors.black26,
      padding: EdgeInsets.all(15.0) ,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:  MyColors.primaryColor,
            backgroundImage: getChatItemImg(article),
            radius: 30,
            child: getUserIntial(article),
          ),
          SizedBox(width: 14.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getUserName(article),style: TextStyle(fontSize: 17.0,color: Colors.white),),
              SizedBox(height: 5.0,),
              Container( width: 80.0, child: Text((article.last_message ),style: TextStyle(fontSize: 15.0,color: Colors.white), overflow: TextOverflow.ellipsis,)),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(formattedDate(article.last_action_date) ,style: TextStyle(color: Colors.white),),
                    SizedBox(width: 5.0,),
                    Text(formattedTime(article.last_action_date) ,style: TextStyle(color: Colors.white),),


                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );

  ImageProvider getChatItemImg(chat){
     if(chat.sender_id == user!.id){
       return NetworkImage('${ASSETSBASEURL}AppUsers/${chat.receiver_img}') ;
     } else {
       return NetworkImage('${ASSETSBASEURL}AppUsers/${chat.sender_img}') ;
     }

  }
  Widget getUserIntial(chat){
    String user_img = chat.sender_id == user!.id ? chat.receiver_img : chat.sender_img ;
    String user_name = chat.sender_id == user!.id ? chat.receiver_name : chat.sender_name ;

    return user_img== "" ?
    Text(user_name.toUpperCase().substring(0 , 1) +
        (user_name.contains(" ") ? user_name.substring(user_name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : Container();
  }
  String getUserName(chat){
    String user_name = chat.sender_id == user!.id ? chat.receiver_name : chat.sender_name ;
     return user_name ;
  }

  String formattedDate(dateTime) {
    const DATE_FORMAT = 'dd/MM/yyyy';
    print('dateTime ($dateTime)');
    return DateFormat(DATE_FORMAT).format(DateTime.parse(dateTime) );
  }

  String formattedTime(dateTime) {
    const DATE_FORMAT = 'hh:mm';
    print('dateTime ($dateTime)');
    return DateFormat(DATE_FORMAT).format(DateTime.parse(dateTime) );
  }

}



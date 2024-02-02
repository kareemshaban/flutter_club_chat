
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/modules/CustomerService/customer_service_screen.dart';
import 'package:clubchat/modules/EventMessage/event_message_screen.dart';
import 'package:clubchat/modules/Followers/Followers_Screen.dart';
import 'package:clubchat/modules/SystemMessage/system_message_screen.dart';
import 'package:clubchat/modules/chat/chat.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

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
  var userTxt = TextEditingController()  ;
  List<Friends>? friends = [];
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
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const SystemMessage()));
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
                  _buildUserList(),
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
}



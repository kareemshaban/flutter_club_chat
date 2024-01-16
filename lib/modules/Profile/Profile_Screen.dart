import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/modules/AddStatus/Add_Status_Screen.dart';
import 'package:clubchat/modules/EditProfile/Edit_Profile_Screen.dart';
import 'package:clubchat/modules/Followers/Followers_Screen.dart';
import 'package:clubchat/modules/FollowingScreen/Following_Screen.dart';
import 'package:clubchat/modules/FriendsScreen/Friends_Screen.dart';
import 'package:clubchat/modules/Gifts/Gifts_Screen.dart';
import 'package:clubchat/modules/InnerProfile/Inner_Profile_Screen.dart';
import 'package:clubchat/modules/Level/Level_Screen.dart';
import 'package:clubchat/modules/Mall/Mall_Screen.dart';
import 'package:clubchat/modules/Room/Room_Screen.dart';
import 'package:clubchat/modules/Setting/Setting_Screen.dart';
import 'package:clubchat/modules/VIP/Vip_Screen.dart';
import 'package:clubchat/modules/VisitorsScreen/Visitors_Screen.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  AppUser? user = AppUserServices().userGetter();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(85.0),
        child: AppBar(
          toolbarHeight: 85.0,
          backgroundColor: MyColors.darkColor,
          title: Row(
            children: [
              SizedBox(width: 10.0,),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CircleAvatar(
                    backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                    backgroundImage: user?.img != "" ?  NetworkImage('${ASSETSBASEURL}AppUsers/${user?.img}') : null,
                    radius: 30,
                    child: user?.img== "" ?
                    Text(user!.name.toUpperCase().substring(0 , 1) +
                        (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const EditProfileScreen()));
                    },
                    child: CircleAvatar(
                      radius: 12.0,
                      backgroundColor: Colors.black54 ,
                      child: Icon(Icons.edit_outlined ,color: Colors.white, size: 15,),
                    ),
                  )
                ],
              ),
              SizedBox(width: 25.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Text(user!.name , style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                      const SizedBox(width: 10.0,),
                      CircleAvatar(
                        backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                        radius: 12.0,
                        child: user!.gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                      )
                    ],
                  ),
                  SizedBox(height: 3.0,),
                  Row(
                    children: [
                      Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.share_level_icon}') , width: 50,),
                      const SizedBox(width: 10.0,),
                      Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.karizma_level_icon}') , width: 50,),
                      const SizedBox(width: 10.0, height: 10,),
                      Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.charging_level_icon}') , width: 30,),
                    ],
                  ),
                  SizedBox(height: 5.0,),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async{
                      await Clipboard.setData(ClipboardData(text: user!.tag));
                      Fluttertoast.showToast(
                          msg: 'User ID Copied !',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black26,
                          textColor: Colors.orange,
                          fontSize: 16.0
                      );
                    },
                    child: Row(
                      children: [
                        Text("ID:" + user!.tag , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 12.0),),
                        const SizedBox(width: 5.0,),
                        Icon(Icons.copy_outlined , color: MyColors.unSelectedColor , size: 20.0,)
                      ],
                    ),
                  )

                ],
              ),
            ],
          ),
          actions: [
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const InnerProfileScreen()));
            }, icon:Icon( Icons.arrow_forward_ios , color: MyColors.unSelectedColor , size: 25.0,))
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: MyColors.darkColor,
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          print('clicked');
                          Navigator.push(context, MaterialPageRoute(builder: (ctx) => const FollowersScreen()));
                          },
                        child: Column(
                          children: [
                            Text(user!.followers!.length.toString() ,
                              style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                            Text("Followers" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (ctx) => const FollowingScreen()));},
                      child: Column(
                        children: [
                          Text(user!.followings!.length.toString() ,
                            style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                          Text("Following" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (ctx) => const FriendsScreen()));},
                      child: Column(
                        children: [
                          Text(user!.friends!.length.toString() ,
                            style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                          Text("Friends" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (ctx) => const VisitorsScreen()));},
                      child: Column(
                        children: [
                          Text(user!.visitors!.length.toString() ,
                            style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                          Text("Visitors" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
              GestureDetector(
                onTap: (){},
                child: Container(
                  height: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(image: AssetImage('assets/images/first_charge_banar.png'), fit: BoxFit.cover
                  ),
                ),
                ),
              ),
              SizedBox(height: 10.0,),

              Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const VipScreen()));
                    },
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                            image: DecorationImage(image: AssetImage('assets/images/vip-bar.png'), fit: BoxFit.cover
                            ),
                          ),
                        ),
                        Shimmer(
                          color: Colors.white,
                          //Default value
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.0 , vertical: 8.0),
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: MyColors.solidDarkColor,
                              borderRadius: BorderRadius.circular(20.0)
                            ),
                            child: Text('Purchase' , style: TextStyle(color: Colors.white , fontSize: 13.0),),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(image: AssetImage('assets/images/Gold-bag.png'), fit: BoxFit.cover
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Gold" , style: TextStyle(color: MyColors.primaryColor , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                              SizedBox(height: 10.0,),
                              Row(
                                children: [
                                  Image(image: AssetImage('assets/images/gold.png') , width: 30.0, height: 30.0,),
                                  SizedBox(width: 5.0,),
                                  Text(user!.gold , style: TextStyle(color: MyColors.primaryColor , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.0,),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(image: AssetImage('assets/images/diamond-bag.png'), fit: BoxFit.cover
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Diamond" , style: TextStyle(color: MyColors.blueColor.withOpacity(.9) , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                              SizedBox(height: 10.0,),
                              Row(
                                children: [
                                  Image(image: AssetImage('assets/images/diamond.png') , width: 27.0, height: 27.0,),
                                  SizedBox(width: 5.0,),
                                  Text(user!.diamond , style: TextStyle(color: MyColors.blueColor.withOpacity(.9) , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.0,),
              Container(
                height: 70.0,
                decoration: BoxDecoration(color: MyColors.unSelectedColor.withAlpha(80),
                borderRadius: BorderRadius.circular(15.0)),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image(image: AssetImage('assets/images/Room.png') , width: 45.0,),

                          Text("Room" , style: TextStyle(color: MyColors.whiteColor , fontSize: 12.0 ),)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image(image: AssetImage('assets/images/mall.png') , width: 45.0,),
                          Text("Mall" , style: TextStyle(color: MyColors.whiteColor , fontSize: 12.0 ),)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image(image: AssetImage('assets/images/gIFT.png') , width: 45.0,),
                          Text("Gifts" , style: TextStyle(color: MyColors.whiteColor , fontSize: 12.0 ),)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image(image: AssetImage('assets/images/LV.png') , width: 45.0,),
                          Text("Level" , style: TextStyle(color: MyColors.whiteColor , fontSize: 12.0 ),)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0,),
              Container(
                decoration: BoxDecoration(color: MyColors.unSelectedColor.withAlpha(80),
                borderRadius: BorderRadius.circular(15.0)),
                width: double.infinity,
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                         Image(image: AssetImage('assets/images/POST.png') , width: 40.0, height: 40.5,),
                         SizedBox(width: 10.0,),
                         Text("My Posts" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 16.0),),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.end,
                             children: [
                               Icon(Icons.arrow_forward_ios , size: 22.0, color: MyColors.unSelectedColor,)
                             ],
                           ),
                         )
                      ],
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(start: 50.0 , end: 10.0),
                      width: double.infinity,
                      height: 1.0,
                      color: MyColors.darkColor.withAlpha(120),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const AddStatusScreen()));
                      },
                      child: Row(
                        children: [
                          Image(image: AssetImage('assets/images/Status.png') , width: 40.0, height: 40.5,),
                          SizedBox(width: 10.0,),
                          Text("My Status" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 16.0),),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_forward_ios , size: 22.0, color: MyColors.unSelectedColor,)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(start: 50.0 , end: 10.0),
                      width: double.infinity,
                      height: 1.0,
                      color: MyColors.darkColor.withAlpha(120),
                    ),
                    Row(
                      children: [
                        Image(image: AssetImage('assets/images/INVIT.png') , width: 40.0, height: 40.5,),
                        SizedBox(width: 10.0,),
                        Text("Invite Friends" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 16.0),),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_forward_ios , size: 22.0, color: MyColors.unSelectedColor,)
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(start: 50.0 , end: 10.0),
                      width: double.infinity,
                      height: 1.0,
                      color: MyColors.darkColor.withAlpha(120),
                    ),
                    Row(
                      children: [
                        Image(image: AssetImage('assets/images/badge.png') , width: 40.0, height: 40.5,),
                        SizedBox(width: 10.0,),
                        Text("Medals" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 16.0),),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_forward_ios , size: 22.0, color: MyColors.unSelectedColor,)
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0,),
              Container(
                decoration: BoxDecoration(color: MyColors.unSelectedColor.withAlpha(80),
                    borderRadius: BorderRadius.circular(15.0)),
                width: double.infinity,
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image(image: AssetImage('assets/images/contact.png') , width: 40.0, height: 40.5,),
                        SizedBox(width: 10.0,),
                        Text("Contact Us" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 16.0),),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_forward_ios , size: 22.0, color: MyColors.unSelectedColor,)
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(start: 50.0 , end: 10.0),
                      width: double.infinity,
                      height: 1.0,
                      color:MyColors.darkColor.withAlpha(120),
                    ),
                    Row(
                      children: [
                        Image(image: AssetImage('assets/images/Policy.png') , width: 40.0, height: 40.5,),
                        SizedBox(width: 10.0,),
                        Text("Terms of Use" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 16.0),),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_forward_ios , size: 22.0, color: MyColors.unSelectedColor,)
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(start: 50.0 , end: 10.0),
                      width: double.infinity,
                      height: 1.0,
                      color: MyColors.darkColor.withAlpha(120),
                    ),
                    GestureDetector(

                      child: Row(
                        children: [
                          Image(image: AssetImage('assets/images/Userpolicy.png') , width: 40.0, height: 40.5,),
                          SizedBox(width: 10.0,),
                          Text("Privacy Policy" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 16.0),),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_forward_ios , size: 22.0, color: MyColors.unSelectedColor,)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0,),
              Container(
                decoration: BoxDecoration(color: MyColors.unSelectedColor.withAlpha(80),
                    borderRadius: BorderRadius.circular(15.0)),
                width: double.infinity,
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const SettingScreen()));
                      },
                      child: Row(
                        children: [
                          Image(image: AssetImage('assets/images/SETTING.png') , width: 40.0, height: 40.5,),
                          SizedBox(width: 10.0,),
                          Text("Account Settings" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 16.0),),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_forward_ios , size: 22.0, color: MyColors.unSelectedColor,)
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
          ),
        ),
      ),
    );
  }
}

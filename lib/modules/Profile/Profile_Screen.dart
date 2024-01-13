import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/modules/Followers/Followers_Screen.dart';
import 'package:clubchat/modules/FollowingScreen/Following_Screen.dart';
import 'package:clubchat/modules/FriendsScreen/Friends_Screen.dart';
import 'package:clubchat/modules/Gifts/Gifts_Screen.dart';
import 'package:clubchat/modules/InnerProfile/Inner_Profile_Screen.dart';
import 'package:clubchat/modules/Level/Level_Screen.dart';
import 'package:clubchat/modules/Mall/Mall_Screen.dart';
import 'package:clubchat/modules/Room/Room_Screen.dart';
import 'package:clubchat/modules/VisitorsScreen/Visitors_Screen.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        backgroundColor: MyColors.darkColor,
        title: Row(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CircleAvatar(
                  backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                  backgroundImage: user?.img != "" ?  NetworkImage('${ASSETSBASEURL}AppUsers/${user?.img}') : null,
                  radius: 25,
                  child: user?.img== "" ?
                  Text(user!.name.toUpperCase().substring(0 , 1) +
                      (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                    style: const TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),) : null,
                ),
                CircleAvatar(
                  backgroundColor: Colors.black54 ,
                  child: Icon(Icons.edit_outlined ,color: Colors.white, size: 15,),
                )
              ],
            ),
            Column(
              children: [

                Row(
                  children: [
                    Text(user!.name , style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                    const SizedBox(width: 10.0,),
                    CircleAvatar(
                      backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                      radius: 10.0,
                      child: user!.gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                    )
                  ],
                ),
                Row(
                  children: [
                    Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.share_level_icon}') , width: 35,),
                    const SizedBox(width: 10.0,),
                    Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.karizma_level_icon}') , width: 35,),
                    const SizedBox(width: 10.0,),
                    Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.charging_level_icon}') , width: 25,),
                  ],
                ),
                Row(
                  children: [
                    Text("ID:" + user!.tag , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 12.0),),
                    const SizedBox(width: 5.0,),
                    Icon(Icons.copy_outlined , color: MyColors.unSelectedColor , size: 20.0,)
                  ],
                )
                
              ],
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (ctx) => const InnerProfileScreen()));
          }, icon:Icon( Icons.arrow_forward_ios , color: MyColors.unSelectedColor , size: 20.0,))
        ],
      ),
      body: Container(
        width: double.infinity,
        color: MyColors.darkColor,
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const FollowersScreen()));
                    },
                    child: Column(
                      children: [
                        Text(user!.followers!.length.toString() ,
                          style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                        Text("Followers" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 13.0),)
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const FollowingScreen()));
                    },
                    child: Column(
                      children: [
                        Text(user!.followings!.length.toString() ,
                          style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                        Text("Following" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 13.0),)
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const FriendsScreen()));
                    },
                    child: Column(
                      children: [
                        Text(user!.friends!.length.toString() ,
                          style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                        Text("Friends" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 13.0),)
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const VisitorsScreen()));
                    },
                    child: Column(
                      children: [
                        Text(user!.visitors!.length.toString() ,
                          style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                        Text("Visitors" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 13.0),)
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: (){},
                child: Container(
                  height: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(image: AssetImage('assets/images/first_charge_banar.png'), fit: BoxFit.cover
                  ),
                ),
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                        image: DecorationImage(image: AssetImage('assets/images/vip-bar.png'), fit: BoxFit.cover
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0 , vertical: 8.0),
                      decoration: BoxDecoration(
                        color: MyColors.solidDarkColor,
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Text('Purchase' , style: TextStyle(color: Colors.white , fontSize: 18.0),),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                      image: DecorationImage(image: AssetImage('assets/images/Gold-bag.png'), fit: BoxFit.cover
                      ),
                    ),
                    child: Expanded(child: Column(
                      children: [
                        Text("Gold" , style: TextStyle(color: MyColors.primaryColor , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                        SizedBox(height: 10.0,),
                        Row(
                          children: [
                            Image(image: AssetImage('assets/images/gold.png') , width: 25.0, height: 25.0,),
                            SizedBox(width: 5.0,),
                            Text(user!.gold , style: TextStyle(color: MyColors.primaryColor , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                          ],
                        )
                      ],
                    )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                      image: DecorationImage(image: AssetImage('assets/images/diamond-bag.png'), fit: BoxFit.cover
                      ),
                    ),
                    child: Expanded(child: Column(
                      children: [
                        Text("Diamond" , style: TextStyle(color: MyColors.primaryColor , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                        SizedBox(height: 10.0,),
                        Row(
                          children: [
                            Image(image: AssetImage('assets/images/diamond-bag.png') , width: 25.0, height: 25.0,),
                            SizedBox(width: 5.0,),
                            Text(user!.diamond , style: TextStyle(color: MyColors.primaryColor , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                          ],
                        )
                      ],
                    )),
                  ),
                ],
              ),
              SizedBox(height: 5.0,),
              Container(
                height: 80.0,
                color: MyColors.darkColor.withOpacity(.8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const RoomScreen()));
                      },
                      child: Expanded(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 15.0,
                              backgroundColor: Colors.blueAccent.withOpacity(.8),
                              child: Image(image: AssetImage('') , width: 25.0,),
                            ),
                            Text("My Room" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0 ),)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const MallScreen()));
                      },
                      child: Expanded(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 15.0,
                              backgroundColor: Colors.orangeAccent.withOpacity(.8),
                              child: Image(image: AssetImage('') , width: 25.0,),
                            ),
                            Text("Mall" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0 ),)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const GiftsScreen()));

                      },
                      child: Expanded(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 15.0,
                              backgroundColor: Colors.deepPurpleAccent.withOpacity(.8),
                              child: Image(image: AssetImage('') , width: 25.0,),
                            ),
                            Text("Gifts" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0 ),)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const LevelScreen()));

                      },
                      child: Expanded(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 15.0,
                              backgroundColor: Colors.indigoAccent.withOpacity(.8),
                              child: Image(image: AssetImage('') , width: 25.0,),
                            ),
                            Text("Level" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0 ),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: MyColors.darkColor.withOpacity(.8),
                child: Column(
                  children: [
                    Row(
                      children: [

                      ],
                    )
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

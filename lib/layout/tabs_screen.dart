import 'package:clubchat/modules/Chats/Chats_Screen.dart';
import 'package:clubchat/modules/Home/Home_Screen.dart';
import 'package:clubchat/modules/Moments/Moments_Screen.dart';
import 'package:clubchat/modules/Profile/Profile_Screen.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => TabsScreenState();
}

class TabsScreenState extends State<TabsScreen> {
  //vars
     int activeIndex = 0 ;
     List<Widget> tabs = [HomeScreen() , MomentsScreen() , ChatsScreen() , ProfileScreen()];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: tabs[activeIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: MyColors.solidDarkColor,
        fixedColor: MyColors.primaryColor,
        unselectedItemColor: MyColors.unSelectedColor,
        showUnselectedLabels: false,

        type: BottomNavigationBarType.fixed,
        currentIndex: activeIndex,
        onTap: (index){
         setState(() {
           activeIndex = index ;
         });
        },
        items:  [
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.homeAlt) , label: ""),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.globe) , label: ""),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.commentDots) , label: ""),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.user) , label: ""),
      ],),
    );
  }
}

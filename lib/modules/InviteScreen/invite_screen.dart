import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({super.key});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.darkColor,
        title: Text('profile_invite_friends'.tr , style: TextStyle(color: Colors.white ),),
      ),
      body: Container(
        width: double.infinity,
        color: MyColors.darkColor,
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image(image: AssetImage('assets/images/logo_blue.png') , width: 100.0, height: 100.0,)),
            SizedBox(height: 5.0,),
            Text("Club chat",style: TextStyle(color: MyColors.whiteColor,fontSize: 18.0)),
            SizedBox(height: 25.0,),
            Container(
              child:
              Text("invite_invite_friends ".tr, textAlign: TextAlign.center, style: TextStyle(color: MyColors.whiteColor,fontSize: 18.0)),
            ),
            SizedBox(height: 25.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('invite_copy'.tr ,
                  textAlign: TextAlign.center, style: TextStyle(color: MyColors.primaryColor , fontSize: 20) ,),
                SizedBox(width: 10.0,),
               Icon(Icons.copy_outlined , color: MyColors.primaryColor, size: 30.0,)


              ],
            )

          ],
        ),
      ),
    );
  }
}

import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/Follower.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  List<Follower>? followings = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppUser? user = AppUserServices().userGetter();
    followings = user!.followings ;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.darkColor,
        title: Text("following_title".tr , style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder(index) ,
                  separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: followings!.length),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemListBuilder(index) => Column(
    children: [
      Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: followings![index].follower_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,

                  backgroundImage: followings![index].follower_img != "" ?
                  NetworkImage('${ASSETSBASEURL}AppUsers/${followings![index].follower_img}') : null,
                  radius: 30,
                  child: followings![index].follower_img == "" ?
                  Text(followings![index].follower_name.toUpperCase().substring(0 , 1) +
                      (followings![index].follower_name.contains(" ") ? followings![index].follower_name.substring(followings![index].follower_name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
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
                    Text(followings![index].follower_name , style: TextStyle(color: MyColors.whiteColor , fontSize: 18.0),),
                    const SizedBox(width: 5.0,),
                    CircleAvatar(
                      backgroundColor: followings![index].follower_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                      radius: 10.0,
                      child: followings![index].follower_gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                    )
                  ],
                ),
                Row(

                  children: [
                    Image(image: NetworkImage(ASSETSBASEURL + 'Levels/' + followings![index].share_level_img) , width: 40,),
                    const SizedBox(width: 10.0,),
                    Image(image: NetworkImage(ASSETSBASEURL + 'Levels/' + followings![index].karizma_level_img) , width: 40,),
                    const SizedBox(width: 10.0,),
                    Image(image: NetworkImage(ASSETSBASEURL + 'Levels/' + followings![index].charging_level_img) , width: 30,),

                  ],
                ),

                Text("ID:${followings![index].follower_tag}" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 13.0),),


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
}

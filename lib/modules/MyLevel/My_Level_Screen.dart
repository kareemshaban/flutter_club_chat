import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/DesignServices.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MyLevelScreen extends StatefulWidget {
  const MyLevelScreen({super.key});

  @override
  State<MyLevelScreen> createState() => _MyLevelScreenState();
}

class _MyLevelScreenState extends State<MyLevelScreen> {
  AppUser? user;
  double share_level_progress = .3;
  double karizma_level_progress = .7;
  double charging_level_progress = .6;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() {
    setState(() {
      user = AppUserServices().userGetter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.whiteColor, //change your color here
          ),
          backgroundColor: MyColors.darkColor,
          title: TabBar(
            dividerColor: Colors.transparent,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicatorColor: MyColors.primaryColor,
            labelColor: MyColors.primaryColor,
            unselectedLabelColor: MyColors.unSelectedColor,
            labelStyle:
                const TextStyle(fontSize: 17.0, fontWeight: FontWeight.w900),
            tabs:  [
              Tab(
                child: Text(
                  "my_level_wealth".tr,
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              Tab(
                child: Text(
                  "my_level_karizma".tr,
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              Tab(
                child: Text(
                  "my_level_charging".tr,
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.sync,
                  color: Colors.white,
                  size: 30.0,
                ))
          ],
        ),
        body: Container(
          color: MyColors.darkColor,
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(top: 60.0),
          child: TabBarView(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              children: [
                                Container(
                                  child: CircleAvatar(
                                    backgroundColor: user!.gender == 0
                                        ? MyColors.blueColor
                                        : MyColors.pinkColor,
                                    backgroundImage: user?.img != ""
                                        ? NetworkImage(
                                            '${ASSETSBASEURL}AppUsers/${user?.img}')
                                        : null,
                                    radius: 60,
                                    child: user?.img == ""
                                        ? Text(
                                            user!.name
                                                    .toUpperCase()
                                                    .substring(0, 1) +
                                                (user!.name.contains(" ")
                                                    ? user!.name
                                                        .substring(user!.name
                                                            .indexOf(" "))
                                                        .toUpperCase()
                                                        .substring(1, 2)
                                                    : ""),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            RotationTransition(
                              turns: new AlwaysStoppedAnimation(180 / 360),
                              child: new CircularPercentIndicator(
                                radius: 90.0,
                                lineWidth: 10.0,
                                percent: share_level_progress,
                                animation: true,
                                animationDuration: 3000,
                                arcType: ArcType.FULL_REVERSED,
                                arcBackgroundColor: MyColors.unSelectedColor,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: MyColors.primaryColor,
                              ),
                            )
                          ],
                        ),
                        Image(
                          image: NetworkImage(
                              '${ASSETSBASEURL}Levels/${user!.share_level_icon}'),
                          width: 60,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "my_level_current_points".tr,
                                style: TextStyle(
                                    color: MyColors.unSelectedColor,
                                    fontSize: 16.0),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "2500",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 50.0,
                          width: 2,
                          color: MyColors.unSelectedColor,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "my_level_next_level".tr,
                                style: TextStyle(
                                    color: MyColors.unSelectedColor,
                                    fontSize: 16.0),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "5000",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 10.0,
                      width: double.infinity,
                      color: MyColors.solidDarkColor,
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          width: double.infinity,
                          child: Container(
                            margin: EdgeInsets.only(top: 70.0),
                            child: Column(

                              children: [
                                Text(
                                  "my_level_ways_to_level_up".tr,
                                  style: TextStyle(
                                      color: MyColors.primaryColor,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Image(image: AssetImage('assets/images/gift_box.png') , width:30, height: 30,),
                                      SizedBox(width: 30.0,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("my_level_send_gift".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 16.0),),
                                          Text("my_level_gold_point".tr, style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),),
                                          SizedBox(height: 10.0,),
                                          Container(color: MyColors.unSelectedColor,
                                            height: 1.0 , child: null, width: ( MediaQuery.of(context).size.width - 100),)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.all(15.0),
                                //   child: Row(
                                //     children: [
                                //       Image(image: AssetImage('assets/images/frame.png') , width:40, height: 40,),
                                //       SizedBox(width: 20.0,),
                                //       Column(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         children: [
                                //           Text("Buy a Frame From Mall" , style: TextStyle(color: MyColors.whiteColor , fontSize: 16.0),),
                                //           Text("1 Gold = 1 Point" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),),
                                //           SizedBox(height: 10.0,),
                                //           Container(color: MyColors.unSelectedColor,
                                //             height: 1.0 , child: null, width: ( MediaQuery.of(context).size.width - 100),)
                                //         ],
                                //       )
                                //     ],
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.all(15.0),
                                //   child: Row(
                                //     children: [
                                //       Image(image: AssetImage('assets/images/mall_icon.png') , width:45, height: 45,),
                                //       SizedBox(width: 15.0,),
                                //       Column(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         children: [
                                //           Text("Buy a Car From Mall" , style: TextStyle(color: MyColors.whiteColor , fontSize: 16.0),),
                                //           Text("1 Gold = 1 Point" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),),
                                //           SizedBox(height: 10.0,),
                                //           Container(color: MyColors.unSelectedColor,
                                //             height: 1.0 , child: null, width: ( MediaQuery.of(context).size.width - 100),)
                                //         ],
                                //       )
                                //     ],
                                //   ),
                                // ),

                              ],
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0, -20.0),
                          child: Container(
                            width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Image(
                                  image: AssetImage('assets/images/rgb.png'))),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 10.0,
                      width: double.infinity,
                      color: MyColors.solidDarkColor,
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              children: [
                                Container(
                                  child: CircleAvatar(
                                    backgroundColor: user!.gender == 0
                                        ? MyColors.blueColor
                                        : MyColors.pinkColor,
                                    backgroundImage: user?.img != ""
                                        ? NetworkImage(
                                            '${ASSETSBASEURL}AppUsers/${user?.img}')
                                        : null,
                                    radius: 60,
                                    child: user?.img == ""
                                        ? Text(
                                            user!.name
                                                    .toUpperCase()
                                                    .substring(0, 1) +
                                                (user!.name.contains(" ")
                                                    ? user!.name
                                                        .substring(user!.name
                                                            .indexOf(" "))
                                                        .toUpperCase()
                                                        .substring(1, 2)
                                                    : ""),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            RotationTransition(
                              turns: new AlwaysStoppedAnimation(180 / 360),
                              child: new CircularPercentIndicator(
                                radius: 90.0,
                                lineWidth: 10.0,
                                percent: karizma_level_progress,
                                animation: true,
                                animationDuration: 3000,
                                arcType: ArcType.FULL_REVERSED,
                                arcBackgroundColor: MyColors.unSelectedColor,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: MyColors.primaryColor,
                              ),
                            )
                          ],
                        ),
                        Image(
                          image: NetworkImage(
                              '${ASSETSBASEURL}Levels/${user!.karizma_level_icon}'),
                          width: 60,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "my_level_current_points".tr,
                                style: TextStyle(
                                    color: MyColors.unSelectedColor,
                                    fontSize: 16.0),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "2500",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 50.0,
                          width: 2,
                          color: MyColors.unSelectedColor,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "my_level_next_level".tr,
                                style: TextStyle(
                                    color: MyColors.unSelectedColor,
                                    fontSize: 16.0),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "5000",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 10.0,
                      width: double.infinity,
                      color: MyColors.solidDarkColor,
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          width: double.infinity,
                          child: Container(
                            margin: EdgeInsets.only(top: 70.0),
                            child: Column(

                              children: [
                                Text(
                                  "my_level_ways_to_level_up".tr,
                                  style: TextStyle(
                                      color: MyColors.primaryColor,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Image(image: AssetImage('assets/images/gift_box.png') , width:30, height: 30,),
                                      SizedBox(width: 30.0,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("my_level_receive".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 16.0),),
                                          Text("my_level_gold_point".tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),),
                                          SizedBox(height: 10.0,),
                                          Container(color: MyColors.unSelectedColor,
                                            height: 1.0 , child: null, width: ( MediaQuery.of(context).size.width - 100),)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.all(15.0),
                                //   child: Row(
                                //     children: [
                                //       Image(image: AssetImage('assets/images/frame.png') , width:40, height: 40,),
                                //       SizedBox(width: 20.0,),
                                //       Column(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         children: [
                                //           Text("Receive a Frame From Friend" , style: TextStyle(color: MyColors.whiteColor , fontSize: 16.0),),
                                //           Text("1 Gold = 1 Point" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),),
                                //           SizedBox(height: 10.0,),
                                //           Container(color: MyColors.unSelectedColor,
                                //             height: 1.0 , child: null, width: ( MediaQuery.of(context).size.width - 100),)
                                //         ],
                                //       )
                                //     ],
                                //   ),
                                // ),

                                // Padding(
                                //   padding: const EdgeInsets.all(15.0),
                                //   child: Row(
                                //     children: [
                                //       Image(image: AssetImage('assets/images/mall_icon.png') , width:45, height: 45,),
                                //       SizedBox(width: 15.0,),
                                //       Column(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         children: [
                                //           Text("Receive a Car From Friend" , style: TextStyle(color: MyColors.whiteColor , fontSize: 16.0),),
                                //           Text("1 Gold = 1 Point" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),),
                                //           SizedBox(height: 10.0,),
                                //           Container(color: MyColors.unSelectedColor,
                                //             height: 1.0 , child: null, width: ( MediaQuery.of(context).size.width - 100),)
                                //         ],
                                //       )
                                //     ],
                                //   ),
                                // ),

                              ],
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0, -20.0),
                          child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Image(
                                  image: AssetImage('assets/images/rrgb.png'))),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 10.0,
                      width: double.infinity,
                      color: MyColors.solidDarkColor,
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              children: [
                                Container(
                                  child: CircleAvatar(
                                    backgroundColor: user!.gender == 0
                                        ? MyColors.blueColor
                                        : MyColors.pinkColor,
                                    backgroundImage: user?.img != ""
                                        ? NetworkImage(
                                            '${ASSETSBASEURL}AppUsers/${user?.img}')
                                        : null,
                                    radius: 60,
                                    child: user?.img == ""
                                        ? Text(
                                            user!.name
                                                    .toUpperCase()
                                                    .substring(0, 1) +
                                                (user!.name.contains(" ")
                                                    ? user!.name
                                                        .substring(
                                                            user!.name.indexOf(" "))
                                                        .toUpperCase()
                                                        .substring(1, 2)
                                                    : ""),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            RotationTransition(
                              turns: new AlwaysStoppedAnimation(180 / 360),
                              child: new CircularPercentIndicator(
                                radius: 90.0,
                                lineWidth: 10.0,
                                percent: charging_level_progress,
                                animation: true,
                                animationDuration: 3000,
                                arcType: ArcType.FULL_REVERSED,
                                arcBackgroundColor: MyColors.unSelectedColor,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: MyColors.primaryColor,
                              ),
                            )
                          ],
                        ),
                        Image(
                          image: NetworkImage(
                              '${ASSETSBASEURL}Levels/${user!.charging_level_icon}'),
                          width: 35,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "my_level_current_points".tr,
                                style: TextStyle(
                                    color: MyColors.unSelectedColor,
                                    fontSize: 16.0),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "2500",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 50.0,
                          width: 2,
                          color: MyColors.unSelectedColor,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "my_level_next_level".tr,
                                style: TextStyle(
                                    color: MyColors.unSelectedColor,
                                    fontSize: 16.0),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "5000",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 10.0,
                      width: double.infinity,
                      color: MyColors.solidDarkColor,
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          width: double.infinity,
                          child: Container(
                            margin: EdgeInsets.only(top: 70.0),
                            child: Column(

                              children: [
                                Text(
                                  "my_level_ways_to_level_up".tr,
                                  style: TextStyle(
                                      color: MyColors.primaryColor,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0 , bottom: 15.0 , right: 15.0),
                                  child: Row(
                                    children: [
                                      Image(image: AssetImage('assets/images/coins.png') , width:60, height: 60,),
                                      SizedBox(width: 15.0,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("my_level_charge_your_gold".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 16.0),),
                                          Text("my_level_gold_point".tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),),
                                          SizedBox(height: 10.0,),
                                          Container(color: MyColors.unSelectedColor,
                                            height: 1.0 , child: null, width: ( MediaQuery.of(context).size.width - 120),)
                                        ],
                                      )


                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0, -20.0),
                          child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Image(
                                  image: AssetImage('assets/images/rrrgb.png'))),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 10.0,
                      width: double.infinity,
                      color: MyColors.solidDarkColor,
                    ),
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

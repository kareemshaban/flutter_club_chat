import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/styles/colors.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  AppUser? user ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
    });
  }
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.unSelectedColor, //change your color here
          ),
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
              Tab(text: "profile_gold".tr ),
              Tab(text: "profile_diamond".tr,),
            ],
          ) ,
          actions: [
            Text('Details',style: TextStyle(color: MyColors.unSelectedColor,fontSize: 15.0)),
            SizedBox(width: 10.0,)
          ],
        ),
        body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
          child: TabBarView(
            children: [
              Column(
                children: [
                  Container(
                  height: 180.0,
                  width: 400.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/Gold-bag.png'),
                        fit: BoxFit.cover,

                      )
                  ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50.0 , horizontal: 150.0),
                      child: Stack(
                        children: [
                          Text('Current Gold'),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              children: [
                                Image(image: AssetImage('assets/images/gold.png') , width: 40.0, height: 40.0,),
                                Text('800',style: TextStyle(color: MyColors.darkColor , fontSize: 20.0 , fontWeight: FontWeight.bold),),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                ],
              ),
              Column(),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubchat/helpers/AgencyMemberIncomeHelper.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/HostAgency.dart';
import 'package:clubchat/modules/Loading/loadig_screen.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/HostAgencyService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/styles/colors.dart';

class AgencyIncome extends StatefulWidget {
  const AgencyIncome({super.key});

  @override
  State<AgencyIncome> createState() => _AgencyIncomeState();
}

class _AgencyIncomeState extends State<AgencyIncome> {
  AppUser? user ;
  HostAgency? agency ;
  AgencyMemberIncomeHelper? helper ;
  bool loading = false ;
  int totalPoints = 0 ;
  int needTotalPoints = 0 ;
  int totalMinues = 0 ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
    });
     getMyStatics();


  }

  getMyStatics() async {
    AgencyMemberIncomeHelper? res = await HostAgencyService().getMemberStatics(user!.id);
    setState(() {
      helper = res ;
    });
    getUserAgency();
    int ps = 0 ;
    for(int i = 0 ; i < helper!.points.length ; i++ ){
      ps += helper!.points[i].points ;
    }
    for(int i = 0 ; i < helper!.statics.length ; i++ ){
      totalMinues += double.parse( helper!.statics[i].net_hours).floor() ;
    }



    setState(() {
      totalPoints = ps ;
      needTotalPoints = double.parse(helper!.nextTarget!.gold).floor()   - ps ;
    });
  }
  getUserAgency() async {
    HostAgency? res = await AppUserServices().checkUserISAgencyMember(user!.id);
    setState(() {
      agency = res ;
      loading = true ;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.unSelectedColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.darkColor,
        title: Text(
          "agency_income_title".tr,
          style: TextStyle(color: MyColors.unSelectedColor, fontSize: 20.0),
        ),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: loading ?  SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.calendar_month ,size: 50.0,color: Colors.white,),
                    SizedBox(width: 30.0,),
                    Text(helper!.member!.joining_date,style: TextStyle(fontSize: 18.0,color: Colors.white),
                    )
                  ],
                ),
                SizedBox(height: 30.0,),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text( helper!.currentTarget != null ? 'Current Target : ' + helper!.currentTarget!.order : "Current Target: (NON)" ,style: TextStyle(fontSize: 20.0,color: Colors.green,fontWeight: FontWeight.bold ),),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Next Target : ' + helper!.nextTarget!.order ,style: TextStyle(fontSize: 20.0,color: Colors.red,fontWeight: FontWeight.bold ),),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 1.0,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 30.0,),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('agency_income_work_points'.tr,style: TextStyle(fontSize: 14.0,color: Colors.white),),
                              SizedBox(height: 40.0,),
                              Text(totalPoints.toString(),style: TextStyle(fontSize: 20.0,color: Colors.white),),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.0,),
                        Container(
                          width: 1.0 ,
                          height: MediaQuery.of(context).size.width / 2.5 ,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 10.0,),
                        Expanded(
                          child: Column(
                            children: [
                              Text('agency_income_next_achieve_target'.tr,style: TextStyle(fontSize: 14.0,color: Colors.white), textAlign: TextAlign.center,),
                              SizedBox(height: 20.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(needTotalPoints.toString(),style: TextStyle(fontSize: 20.0,color: Colors.white),),
                                ],
                              ),
                              SizedBox(height: 20.0,),
            
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30.0,),
                Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey,
                ),
                SizedBox(height: 30.0,),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Total Work Minutes : ' + totalMinues.toString() ,style: TextStyle(fontSize: 20.0,color: Colors.green,fontWeight: FontWeight.bold ),),

                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Total Work Hours : ' + (totalMinues > 0 ? (totalMinues / 60).toString() : "0")  ,style: TextStyle(fontSize: 20.0,color: Colors.red,fontWeight: FontWeight.bold ),),
                      ],
                    ),


                  ],
                ),
              ],
            ),
          ) : Loading(),
        ),
      ),
    );
  }
}

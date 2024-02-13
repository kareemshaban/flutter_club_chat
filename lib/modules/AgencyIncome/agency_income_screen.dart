import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/styles/colors.dart';

class AgencyIncome extends StatefulWidget {
  const AgencyIncome({super.key});

  @override
  State<AgencyIncome> createState() => _AgencyIncomeState();
}

class _AgencyIncomeState extends State<AgencyIncome> {
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.calendar_month ,size: 50.0,color: Colors.white,),
                  SizedBox(width: 30.0,),
                  Text('2/12/2023',style: TextStyle(fontSize: 18.0,color: Colors.white),
                  )
                ],
              ),
              SizedBox(height: 30.0,),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('agency_income_target'.tr,style: TextStyle(fontSize: 20.0,color: Colors.white,fontWeight: FontWeight.bold ),),
                      SizedBox(width: 20.0,),
                      Text('1',style: TextStyle(fontSize: 20.0,color: Colors.white,fontWeight: FontWeight.bold),)
                    ],
                  ),
                  SizedBox(height: 10.0,),
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
                            Text('0',style: TextStyle(fontSize: 20.0,color: Colors.white),),
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
                            Text('agency_income_work_hour'.tr,style: TextStyle(fontSize: 14.0,color: Colors.white),),
                            SizedBox(height: 20.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('agency_income_hour'.tr,style: TextStyle(fontSize: 17.0,color: Colors.white),),
                                Text('0',style: TextStyle(fontSize: 20.0,color: Colors.white),),
                              ],
                            ),
                            SizedBox(height: 20.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('agency_income_day'.tr,style: TextStyle(fontSize: 17.0,color: Colors.white),),
                                Text('0',style: TextStyle(fontSize: 20.0,color: Colors.white),),
                              ],
                            ),
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
              Column(
                children: [
                  SizedBox(height: 30.0,),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text('agency_income_next_achieve_target'.tr,style: TextStyle(fontSize: 14.0,color: Colors.white),),
                            SizedBox(height: 60.0,),
                            Text('0',style: TextStyle(fontSize: 20.0,color: Colors.white),),
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
                            Text('agency_income_next_target'.tr,style: TextStyle(fontSize: 14.0,color: Colors.white),),
                            SizedBox(height: 20.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('agency_income_hour'.tr,style: TextStyle(fontSize: 17.0,color: Colors.white),),
                                Text('0',style: TextStyle(fontSize: 20.0,color: Colors.white),),
                              ],
                            ),
                            SizedBox(height: 20.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('agency_income_day'.tr,style: TextStyle(fontSize: 17.0,color: Colors.white),),
                                Text('0',style: TextStyle(fontSize: 20.0,color: Colors.white),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

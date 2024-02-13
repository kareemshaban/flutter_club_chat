import 'package:clubchat/modules/AgencyChargeOperations/agency_charge_operations_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../models/AppUser.dart';
import '../../shared/styles/colors.dart';

class AgencyCharge extends StatefulWidget {
  const AgencyCharge({super.key});

  @override
  State<AgencyCharge> createState() => _AgencyChargeState();
}

class _AgencyChargeState extends State<AgencyCharge> {

   bool ShowUser = false;

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
          "agency_charge_title".tr,
          style: TextStyle(color: MyColors.unSelectedColor, fontSize: 20.0),
        ),
        actions: [
          IconButton(icon: Icon(FontAwesomeIcons.circleQuestion , color: Colors.white,) , onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (ctx) => AgencyChargeOperations()));
          },
          )
        ],
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
                children: [
                  Text('ID',style: TextStyle(fontSize: 25.0 , color: Colors.white),),
                  SizedBox(width: 10.0,),
                  Container(
                    width: 220.0,
                    height: 45.0,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(width: 10.0,),
                  Container(
                    height: 45.0,
                    width: 80,
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: MaterialButton(onPressed: ()
                    {
                      setState(() {
                        ShowUser = true ;
                      });
                    } ,
                      child: Text("agency_charge_search".tr , style: TextStyle(color: Colors.white , fontSize: 14.0),),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0,),
             ShowUser ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('agency_charge_user_data'.tr,style: TextStyle(color: Colors.white , fontSize: 22.0)),
                    ],
                  ),
                  SizedBox(height: 20.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 28.0,
                          ),
                        ],
                      ),
                      SizedBox(width: 15.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('name',style: TextStyle(color: Colors.white , fontSize: 18.0)),
                          Text('ID : ',style: TextStyle(color: Colors.white , fontSize: 18.0)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20.0,),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Text('profile_gold'.tr,style: TextStyle(fontSize: 25.0 , color: Colors.white),),
                        SizedBox(width: 20.0,),
                        Container(
                          width: 100.0,
                          height: 40.0,
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60.0,
                        width: 90.0,
                        decoration: BoxDecoration(
                          color: MyColors.primaryColor,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: MaterialButton(onPressed: (){} ,
                          child: Text("agency_charge_charge".tr , style: TextStyle(color: Colors.white , fontSize: 18.0),),
                        ),
                      )
                    ],
                  ),
                ],
              ) : Container()


            ],
          ),
        ),
      ),
    );
  }
}

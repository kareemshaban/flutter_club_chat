import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/HostAgency.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/HostAgencyService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/styles/colors.dart';

class JoinHostAgency extends StatefulWidget {
  const JoinHostAgency({super.key});

  @override
  State<JoinHostAgency> createState() => _JoinHostAgencyState();
}

class _JoinHostAgencyState extends State<JoinHostAgency> {
  AppUser? user ;
  HostAgency? agency ;
  bool showAgency = false ;
  final TextEditingController agencyTagController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
    });
  }
  getAgency() async {
    HostAgency? res = await HostAgencyService().getAgencyByTag(agencyTagController.text);
    if(res != null){
      setState(() {
        agency = res ;
        if(agency!.id > 0){
          setState(() {
            showAgency = true ;
          });
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.unSelectedColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.darkColor,
        title: Text(
          'join_host_title'.tr,
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
                children: [
                  Text('ID',style: TextStyle(fontSize: 25.0 , color: Colors.white),),
                  SizedBox(width: 10.0,),
                  Container(
                    width: 220.0,
                    height: 45.0,
                    child: TextFormField(
                      controller: agencyTagController,
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

                    } ,
                      child: Text("agency_charge_search".tr , style: TextStyle(color: Colors.white , fontSize: 14.0),),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0,),
           showAgency ?   Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('join_host_data'.tr,style: TextStyle(color: Colors.white , fontSize: 22.0)),
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
                  SizedBox(height: 30.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60.0,
                        width: 190.0,
                        decoration: BoxDecoration(
                          color: MyColors.primaryColor,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: MaterialButton(onPressed: (){} ,
                          child: Text("join_host_request".tr , style: TextStyle(color: Colors.white , fontSize: 18.0),),
                        ),
                      )
                    ],
                  ),
                ],
              ) : Container(),


            ],
          ),
        ),
      ),
    );
  }
}

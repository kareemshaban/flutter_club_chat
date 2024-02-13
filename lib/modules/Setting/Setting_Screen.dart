import 'package:clubchat/modules/About/About_Screen.dart';
import 'package:clubchat/modules/AccountManagement/Account_Management_Screen.dart';
import 'package:clubchat/modules/AgencyCharge/agency_charge_screen.dart';
import 'package:clubchat/modules/AgencyIncome/agency_income_screen.dart';
import 'package:clubchat/modules/Agreement/Agreement_Screen.dart';
import 'package:clubchat/modules/BlockList/block_list_screen.dart';
import 'package:clubchat/modules/EditLanguage/Edit_Language_Screen.dart';
import 'package:clubchat/modules/NetworkDiagnosis/Network_Diagnosis_screen.dart';
import 'package:clubchat/modules/NotificationSetting/Notification_Setting_Screen.dart';
import 'package:clubchat/modules/PrivacyPolicy/Privacy_Policy_Screen.dart';
import 'package:clubchat/modules/Verification/verification_screen.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../models/AppUser.dart';
import '../JoinHostAgency/join_host_agency_screen.dart';
import '../Loading/loadig_screen.dart';



class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}


class _SettingScreenState extends State<SettingScreen> {

  AppUser? user ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = AppUserServices().userGetter();
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
        title: Text("setting_title".tr , style: TextStyle(color: MyColors.unSelectedColor,fontSize: 20.0) ,),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.black26,
                padding: EdgeInsets.all(15.0) ,
                margin: EdgeInsetsDirectional.only(bottom: 10.0),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const EditLanguageScreen(),),);
                  },
                  child: Row(
                    children: [
                      Text("setting_language".tr ,style:TextStyle(color: MyColors.unSelectedColor,fontSize: 15.0) ,),
                      Expanded(
                        child:Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.arrow_forward_ios_outlined , color: MyColors.unSelectedColor , size: 20.0,)
                        ]
                          //change your color here
                        ),
                  ),
                              ],

                                ),
                ),
            ),
              Container(
                color: Colors.black26,
                padding: EdgeInsets.all(15.0) ,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const NotificationSettingScreen()));
                  },
                  child: Row(
                    children: [
                      Text("setting_notification".tr ,style:TextStyle(color: MyColors.unSelectedColor,fontSize: 15.0) ,),
                      Expanded(
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_forward_ios_outlined , color: MyColors.unSelectedColor , size: 20.0,)
                            ]
                          //change your color here
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.black45,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => const BlockListScreen()));
                },
                child: Container(
                  color: Colors.black26,
                  padding: EdgeInsets.all(15.0) ,
                  child: Row(
                    children: [
                      Text("setting_blocked_list".tr ,style:TextStyle(color: MyColors.unSelectedColor,fontSize: 15.0) ,),
                      Expanded(
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_forward_ios_outlined , color: MyColors.unSelectedColor, size: 20.0,)
                            ]
                          //change your color here
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.black45,
              ),
              // Container(
              //   color: Colors.black26,
              //   padding: EdgeInsets.all(15.0) ,
              //   child : GestureDetector(
              //     behavior: HitTestBehavior.opaque,
              //     onTap: (){
              //       Navigator.push(context, MaterialPageRoute(builder: (ctx) => const Verification(),),);
              //     },
              //   child: Row(
              //     children: [
              //       Text("setting_identity_verification".tr ,style:TextStyle(color: MyColors.unSelectedColor,fontSize: 15.0) ,),
              //       Expanded(
              //         child:Row(
              //             mainAxisAlignment: MainAxisAlignment.end,
              //             children: [
              //               Icon(Icons.arrow_forward_ios_outlined , color: MyColors.unSelectedColor , size: 20.0,)
              //             ]
              //           //change your color here
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // ),
              Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.black45,
              ),
              Container(
                color: Colors.black26,
                padding: EdgeInsets.all(15.0) ,
                margin: EdgeInsetsDirectional.only(bottom: 10.0),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const About_Screen()));
                  },
                  child: Row(
                    children: [
                      Text("about_us_title".tr ,style:TextStyle(color: MyColors.unSelectedColor,fontSize: 15.0) ,),
                      Expanded(
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_forward_ios_outlined , color: MyColors.unSelectedColor , size: 20.0,)
                            ]
                          //change your color here
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.black26,
                padding: EdgeInsets.all(15.0) ,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const Agreement_Screen()));
                  },
                  child: Row(
                    children: [
                      Text("agreement_title".tr ,style:TextStyle(color: MyColors.unSelectedColor,fontSize: 15.0) ,),
                      Expanded(
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_forward_ios_outlined , color: MyColors.unSelectedColor , size: 20.0,)
                            ]
                          //change your color here
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.black45,
              ),
              Container(
                color: Colors.black26,
                padding: EdgeInsets.all(15.0) ,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const Privacy_Policy_Screen()));
                  },
                  child: Row(
                    children: [
                      Text("privacy_policy_title".tr ,style:TextStyle(color: MyColors.unSelectedColor,fontSize: 15.0) ,),
                      Expanded(
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_forward_ios_outlined , color: MyColors.unSelectedColor , size: 20.0,)
                            ]
                          //change your color here
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.black45,
              ),
              Container(

                color: Colors.black26,
                padding: EdgeInsets.all(15.0) ,
                margin: EdgeInsetsDirectional.only(bottom: 10.0),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const Network_Diagnosis_Screen()));
                  },
                  child: Row(
                    children: [
                      Text("network_title".tr ,style:TextStyle(color: MyColors.unSelectedColor,fontSize: 15.0) ,),
                      Expanded(
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_forward_ios_outlined , color: MyColors.unSelectedColor , size: 20.0,)
                            ]
                          //change your color here
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.black26,
                padding: EdgeInsets.all(15.0) ,
                margin: EdgeInsetsDirectional.only(bottom: 10.0),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async{
                    showDialog(
                        context: context,
                      builder: (BuildContext context){
                          context = context;
                          return const Loading();
                        },
                    );
                    await Future.delayed(Duration(milliseconds: 3000));
                    Navigator.pop(context);

                    Fluttertoast.showToast(
                        msg: 'clear_cash_msg'.tr,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black26,
                        textColor: Colors.orange,
                        fontSize: 16.0
                    );
                    
                  },
                child: Row(
                  children: [
                    Text("setting_clear_cache".tr ,style:TextStyle(color: MyColors.unSelectedColor,fontSize: 15.0) ,),
                    Expanded(
                      child:Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.arrow_forward_ios_outlined , color: MyColors.unSelectedColor , size: 20.0,)
                          ]
                        //change your color here
                      ),
                    ),
                  ],
                ),
              ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => const Account_Management_Screen()));
                },
                child: Container(
                  color: Colors.black26,
                  padding: EdgeInsets.all(15.0) ,
                  child: Row(
                    children: [
                      Text("account_management_title".tr ,style:TextStyle( color: MyColors.unSelectedColor,fontSize: 15.0) ,),
                      Expanded(
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_forward_ios_outlined , color: MyColors.unSelectedColor , size: 20.0,)
                            ]
                          //change your color here
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
               user!.isChargingAgent == 1 ? GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => const AgencyCharge()));
                },
                child: Container(
                  color: Colors.black26,
                  padding: EdgeInsets.all(15.0) ,
                  child: Row(
                    children: [
                      Text("agency_charge_title".tr ,style:TextStyle( color: MyColors.unSelectedColor,fontSize: 15.0) ,),
                      Expanded(
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_forward_ios_outlined , color: MyColors.unSelectedColor , size: 20.0,)
                            ]
                          //change your color here
                        ),
                      ),
                    ],
                  ),
                ),
              ): Container(),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const JoinHostAgency()));
            },
            child: Container(
              color: Colors.black26,
              padding: EdgeInsets.all(15.0) ,
              child: Row(
                children: [
                  Text("join_host_title".tr ,style:TextStyle( color: MyColors.unSelectedColor,fontSize: 15.0) ,),
                  Expanded(
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.arrow_forward_ios_outlined , color: MyColors.unSelectedColor , size: 20.0,)
                        ]
                      //change your color here
                    ),
                  ),
                ],
              ),
            ),
          ),
              SizedBox(height: 10.0,),

              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => const AgencyIncome()));
                },
                child: Container(
                  color: Colors.black26,
                  padding: EdgeInsets.all(15.0) ,
                  child: Row(
                    children: [
                      Text("agency_income_title".tr ,style:TextStyle( color: MyColors.unSelectedColor,fontSize: 15.0) ,),
                      Expanded(
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_forward_ios_outlined , color: MyColors.unSelectedColor , size: 20.0,)
                            ]
                          //change your color here
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );

  }
}

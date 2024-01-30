import 'package:clubchat/modules/About/About_Screen.dart';
import 'package:clubchat/modules/AccountManagement/Account_Management_Screen.dart';
import 'package:clubchat/modules/Agreement/Agreement_Screen.dart';
import 'package:clubchat/modules/BlockList/block_list_screen.dart';
import 'package:clubchat/modules/EditLanguage/Edit_Language_Screen.dart';
import 'package:clubchat/modules/NetworkDiagnosis/Network_Diagnosis_screen.dart';
import 'package:clubchat/modules/NotificationSetting/Notification_Setting_Screen.dart';
import 'package:clubchat/modules/PrivacyPolicy/Privacy_Policy_Screen.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
              Container(
                color: Colors.black26,
                padding: EdgeInsets.all(15.0) ,
                child: Row(
                  children: [
                    Text("setting_identity_verification".tr ,style:TextStyle(color: MyColors.unSelectedColor,fontSize: 15.0) ,),
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
            ],
          
          
          ),
        ),
      ),
    );
  }
}

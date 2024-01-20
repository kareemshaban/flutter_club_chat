import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/styles/colors.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() => _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool _ChatValue = true;
  bool _FollowersValue = true;
  bool _MessageValue = true;
  bool _MomentsValue = true;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.unSelectedColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.darkColor,
        title: Text("Notification" , style: TextStyle(color: MyColors.unSelectedColor,fontSize: 20.0) ,),
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
                margin: EdgeInsetsDirectional.only(bottom: 5.0),
                child: Row(
                  children: [
                    Text("Private chat" ,style:TextStyle(color: MyColors.unSelectedColor,fontSize: 15.0) ,),
                    Expanded(
                      child:Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CupertinoSwitch(activeColor: MyColors.primaryColor,value: _ChatValue,
                            onChanged: (value) {
                              setState(() {
                                _ChatValue = value;
                              });
                            },
                          ),
                        ],
                        //change your color here
                      ),
                    ),
                  ],

                ),
              ),
              Container(
                color: Colors.black26,
                padding: EdgeInsets.all(15.0) ,
                margin: EdgeInsetsDirectional.only(bottom: 5.0),
                child: Row(
                  children: [
                    Text("New followers" ,style:TextStyle(color: MyColors.unSelectedColor,fontSize: 15.0) ,),
                    Expanded(
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CupertinoSwitch(activeColor: MyColors.primaryColor,value: _FollowersValue,
                            onChanged: (value) {
                              setState(() {
                                _FollowersValue = value;
                              });
                            },
                          ),
                        ],
                        //change your color here
                      ),
                    ),
                  ],

                ),
              ),
              Container(
                color: Colors.black26,
                padding: EdgeInsets.all(15.0) ,
                margin: EdgeInsetsDirectional.only(bottom: 5.0),
                child: Row(
                  children: [
                    Text("Invitation message" ,style:TextStyle(color: MyColors.unSelectedColor,fontSize: 15.0) ,),
                    Expanded(
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CupertinoSwitch(activeColor: MyColors.primaryColor,value: _MessageValue,
                            onChanged: (value) {
                              setState(() {
                                _MessageValue = value;
                              });
                            },
                          ),
                        ],
                        //change your color here
                      ),
                    ),
                  ],

                ),
              ),
              Container(
                color: Colors.black26,
                padding: EdgeInsets.all(15.0) ,
                margin: EdgeInsetsDirectional.only(bottom: 5.0),
                child: Row(
                  children: [
                    Text("Moments notification" ,style:TextStyle(color: MyColors.unSelectedColor,fontSize: 15.0) ,),
                    Expanded(
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CupertinoSwitch(activeColor: MyColors.primaryColor,value: _MomentsValue,
                            onChanged: (value) {
                              setState(() {
                                _MomentsValue = value;
                              });
                            },
                          ),
                        ],
                        //change your color here
                      ),
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

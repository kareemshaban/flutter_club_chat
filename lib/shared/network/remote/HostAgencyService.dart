import 'dart:convert';

import 'package:clubchat/helpers/AgencyMemberIncomeHelper.dart';
import 'package:clubchat/models/AgencyMember.dart';
import 'package:clubchat/models/AgencyMemberPoints.dart';
import 'package:clubchat/models/AgencyMemberStatics.dart';
import 'package:clubchat/models/AgencyTarget.dart';
import 'package:clubchat/models/HostAgency.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HostAgencyService {

  Future<HostAgency?> getAgencyByTag(tag) async {
    final response = await http.get(Uri.parse('${BASEURL}hostAgency/getAgencyByTag/${tag}'));
    HostAgency agency ;
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if( jsonData['agency'] != null){
        agency = HostAgency.fromJson(jsonData['agency'] );
        return agency ;
      } else {
        Fluttertoast.showToast(
            msg: 'sorry we can not find the agency',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
         return null ;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

  Future<void> JoinAgencyRequest(agency_id , user_id) async {
    var response = await http.post(
      Uri.parse('${BASEURL}hostAgency/JoinAgencyRequest'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'agency_id': agency_id.toString(),
        'user_id': user_id.toString(),
      }),
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: 'request_process'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
      } else {
        Fluttertoast.showToast(
            msg: 'sorry we can not find the agency',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
      }

  }


  Future<AgencyMemberIncomeHelper?> getMemberStatics(user_id) async {
    final response = await http.get(Uri.parse('${BASEURL}hostAgency/getAgencyMemberStatics/${user_id}'));
    AgencyMember? member ;
    List<AgencyMemberStatics> statics  = [];
    List<AgencyMemberPoints> points = [] ;
    AgencyTarget? currentTarget ;
    AgencyTarget? nextTarget ;
    AgencyMemberIncomeHelper helper = new AgencyMemberIncomeHelper(member: member, statics: statics, points: points, currentTarget: currentTarget, nextTarget: nextTarget);

    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if( jsonData['member'] != null){
        member = AgencyMember.fromJson(jsonData['member'] );
      }
      for(var i = 0 ; i <  jsonData['statics'].length ; i++ ){
        AgencyMemberStatics st = AgencyMemberStatics.fromJson(jsonData['statics'][i]);
        statics.add(st);
      }
      for(var i = 0 ; i <  jsonData['points'].length ; i++ ){
        AgencyMemberPoints pt = AgencyMemberPoints.fromJson(jsonData['points'][i]);
        points.add(pt);
      }
      if(jsonData['currentTarget'] != null ){
        currentTarget = AgencyTarget.fromJson(jsonData['currentTarget'] );
      }

      nextTarget = AgencyTarget.fromJson(jsonData['nextTarget'] );

      helper.member = member ;
      helper.points = points ;
      helper.nextTarget  = nextTarget ;
      helper.currentTarget = currentTarget ;
      helper.statics = statics ;

      return helper ;

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

}
import 'dart:convert';

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


}
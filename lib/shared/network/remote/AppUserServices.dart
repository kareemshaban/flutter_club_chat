import 'dart:io';

import 'package:clubchat/shared/components/Constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppUserServices {

  Future<http.Response> createAccount( name , register_with ,img,  phone , email  ,  password) async {
    String deviceId = await getId() ?? "";
    var data = await getIpAddress() ;
    var ipAddress = data['ip'] ?? "" ;
    return http.post(
      Uri.parse('${BASEURL}Account/Create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'img': img  ?? "",
        'phone': phone  ?? "",
        'email': email ,
        'password': password,
        'register_with': register_with,
        'ipAddress': ipAddress,
        'macAddress': "2.0.0.0",
        'deviceId': deviceId
      }),
    );
  }

  dynamic getIpAddress() async {
    try {
      /// Initialize Ip Address
      var ipAddress = IpAddress(type: RequestType.json);

      /// Get the IpAddress based on requestType.
      dynamic data = await ipAddress.getIpAddress();
      print(data['ip']);
      return data ;
    } on IpAddressException catch (exception) {
      /// Handle the exception.
      return "";
      print(exception.message);
    }
  }

  Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;

      return androidDeviceInfo.id; // unique ID on Android
      
    }
  }




}
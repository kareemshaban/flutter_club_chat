import 'dart:io';

import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/Follower.dart';
import 'package:clubchat/models/Friends.dart';
import 'package:clubchat/models/Visitor.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppUserServices {
  static AppUser? user  ;
  userSetter(AppUser u){
     user = u ;
  }
  AppUser? userGetter(){
    return user ;
  }


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


  Future<List<AppUser>> searchUser(txt) async {
    final response = await http.get(Uri.parse('${BASEURL}users/Search/${txt}'));
    List<AppUser> users  = [];
    if (response.statusCode == 200) {
      List<dynamic>  jsonData = json.decode(response.body);
      for( var i = 0 ; i < jsonData.length ; i ++ ){
        AppUser user = AppUser.fromJson(jsonData[i]);
        users.add(user);
      }
      return users ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }


  Future<AppUser?> getUser(id) async {
    final response = await http.get(Uri.parse('${BASEURL}Account/GetUser/${id}'));
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){
        AppUser user = AppUser.fromJson(jsonData['user']) ;
        List<Follower> followers = [];
        List<Follower> followings = [];
        List<Friends> friends = [];
        List<Visitor> visitors = [];
        for (var j = 0; j < jsonData['followers'].length; j ++) {
            Follower like = Follower.fromJson(jsonData['followers'][j]);
            followers.add(like);

        }
        for (var j = 0; j < jsonData['followings'].length; j ++) {
          Follower like = Follower.fromJson(jsonData['followings'][j]);
          followings.add(like);

        }
        for (var j = 0; j < jsonData['friends'].length; j ++) {
          Friends like = Friends.fromJson(jsonData['friends'][j]);
          friends.add(like);

        }
        for (var j = 0; j < jsonData['visitors'].length; j ++) {
          Visitor like = Visitor.fromJson(jsonData['visitors'][j]);
          visitors.add(like);

        }
        user.friends = friends ;
        user.visitors = visitors ;
        user.followings = followings ;
        user.followers = followers ;

        return  user;
      } else {
        return null ;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }


}
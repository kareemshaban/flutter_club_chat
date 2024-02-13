import 'dart:convert';

import 'package:clubchat/helpers/RoomBasicDataHelper.dart';
import 'package:clubchat/helpers/RoomHelper.dart';
import 'package:clubchat/models/Category.dart';
import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/models/Emossion.dart';
import 'package:clubchat/models/Gift.dart';
import 'package:clubchat/models/Mic.dart';
import 'package:clubchat/models/RoomAdmin.dart';
import 'package:clubchat/models/RoomBlock.dart';
import 'package:clubchat/models/RoomFollow.dart';
import 'package:clubchat/models/RoomMember.dart';
import 'package:clubchat/models/RoomTheme.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatRoomService {

  static ChatRoom? room  ;
  static RoomBasicDataHelper? roomBasicDataHelper  ;
  roomSetter(ChatRoom u){
    room = u ;
  }
  ChatRoom? roomGetter(){
    return room ;
  }

  roomBasicDataHelperSetter(RoomBasicDataHelper u){
    roomBasicDataHelper = u ;
  }
  RoomBasicDataHelper? roomBasicDataHelperGetter(){
    return roomBasicDataHelper ;
  }

  Future<List<ChatRoom>> getAllChatRooms() async {
    final response = await http.get(Uri.parse('${BASEURL}chatRooms/getAll'));
    List<ChatRoom> rooms = [];
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      for (var i = 0; i < jsonData.length; i ++) {
        ChatRoom room = ChatRoom.fromJson(jsonData[i]);
        rooms.add(room);
      }
      return rooms;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load chatroom');
    }
  }

  Future<List<ChatRoom>> searchRoom(txt) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/Search/${txt}'));
    List<ChatRoom> rooms = [];
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      for (var i = 0; i < jsonData.length; i ++) {
        ChatRoom user = ChatRoom.fromJson(jsonData[i]);
        rooms.add(user);
      }
      return rooms;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> openMyRoom(admin_id) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/getRoom/${admin_id}'));
    ChatRoom room;
    List<Mic> mics = [] ;
    List<RoomMember> members = [] ;
    List<RoomAdmin> admins = [] ;
    List<RoomFollow> followers = [] ;
    List<RoomBlock> blockers = [] ;

    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        room = ChatRoom.fromJson(jsonData['room']);

        for (var j = 0; j < jsonData['mics'].length; j ++) {
          Mic mic = Mic.fromJson(jsonData['mics'][j]);
          mics.add(mic);
        }
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RoomMember member = RoomMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        for (var j = 0; j < jsonData['admins'].length; j ++) {
          RoomAdmin admin = RoomAdmin.fromJson(jsonData['admins'][j]);
          admins.add(admin);
        }

        for (var j = 0; j < jsonData['followers'].length; j ++) {
          RoomFollow follow = RoomFollow.fromJson(jsonData['followers'][j]);
          followers.add(follow);
        }
        for (var j = 0; j < jsonData['blockers'].length; j ++) {
          RoomBlock block = RoomBlock.fromJson(jsonData['blockers'][j]);
          blockers.add(block);
        }
        room.mics = mics ;
        room.blockers = blockers ;
        room.admins = admins ;
        room.members = members ;
        room.followers = followers ;


        return room;
      } else {
        Fluttertoast.showToast(
            msg: 'remote_chat_msg_failed'.tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> openRoomById(room_id) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/getRoomById/${room_id}'));
    ChatRoom room;
    List<Mic> mics = [] ;
    List<RoomMember> members = [] ;
    List<RoomAdmin> admins = [] ;
    List<RoomFollow> followers = [] ;
    List<RoomBlock> blockers = [] ;
   // print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        room = ChatRoom.fromJson(jsonData['room']);

        for (var j = 0; j < jsonData['mics'].length; j ++) {
          Mic mic = Mic.fromJson(jsonData['mics'][j]);
          mics.add(mic);
        }
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RoomMember member = RoomMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        for (var j = 0; j < jsonData['admins'].length; j ++) {
          RoomAdmin admin = RoomAdmin.fromJson(jsonData['admins'][j]);
          admins.add(admin);
        }

        for (var j = 0; j < jsonData['followers'].length; j ++) {
          RoomFollow follow = RoomFollow.fromJson(jsonData['followers'][j]);
          followers.add(follow);
        }
        for (var j = 0; j < jsonData['blockers'].length; j ++) {
          RoomBlock block = RoomBlock.fromJson(jsonData['blockers'][j]);
          blockers.add(block);
        }
        room.mics = mics ;
        room.blockers = blockers ;
        room.admins = admins ;
        room.members = members ;
        room.followers = followers ;


        return room;
      } else {
        Fluttertoast.showToast(
            msg: 'remote_chat_msg_failed'.tr,
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

  Future<ChatRoom?> openRoomByAdminId(admin_id) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/getRoomByAdmin/${admin_id}'));
    ChatRoom room;
    List<Mic> mics = [] ;
    List<RoomMember> members = [] ;
    List<RoomAdmin> admins = [] ;
    List<RoomFollow> followers = [] ;
    List<RoomBlock> blockers = [] ;
   print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        room = ChatRoom.fromJson(jsonData['room']);

        for (var j = 0; j < jsonData['mics'].length; j ++) {
          Mic mic = Mic.fromJson(jsonData['mics'][j]);
          mics.add(mic);
        }
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RoomMember member = RoomMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        for (var j = 0; j < jsonData['admins'].length; j ++) {
          RoomAdmin admin = RoomAdmin.fromJson(jsonData['admins'][j]);
          admins.add(admin);
        }

        for (var j = 0; j < jsonData['followers'].length; j ++) {
          RoomFollow follow = RoomFollow.fromJson(jsonData['followers'][j]);
          followers.add(follow);
        }
        for (var j = 0; j < jsonData['blockers'].length; j ++) {
          RoomBlock block = RoomBlock.fromJson(jsonData['blockers'][j]);
          blockers.add(block);
        }
        room.mics = mics ;
        room.blockers = blockers ;
        room.admins = admins ;
        room.members = members ;
        room.followers = followers ;


        return room;
      } else {
        print(jsonData['message']);

        return null ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> trackUser(user_id) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/trackUser/${user_id}'));
    ChatRoom room;
    List<Mic> mics = [] ;
    List<RoomMember> members = [] ;
    List<RoomAdmin> admins = [] ;
    List<RoomFollow> followers = [] ;
    List<RoomBlock> blockers = [] ;
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        room = ChatRoom.fromJson(jsonData['room']);

        for (var j = 0; j < jsonData['mics'].length; j ++) {
          Mic mic = Mic.fromJson(jsonData['mics'][j]);
          mics.add(mic);
        }
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RoomMember member = RoomMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        for (var j = 0; j < jsonData['admins'].length; j ++) {
          RoomAdmin admin = RoomAdmin.fromJson(jsonData['admins'][j]);
          admins.add(admin);
        }

        for (var j = 0; j < jsonData['followers'].length; j ++) {
          RoomFollow follow = RoomFollow.fromJson(jsonData['followers'][j]);
          followers.add(follow);
        }
        for (var j = 0; j < jsonData['blockers'].length; j ++) {
          RoomBlock block = RoomBlock.fromJson(jsonData['blockers'][j]);
          blockers.add(block);
        }
        room.mics = mics ;
        room.blockers = blockers ;
        room.admins = admins ;
        room.members = members ;
        room.followers = followers ;


        return room;
      } else {
        print(jsonData['message']);

        return null ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<RoomBasicDataHelper?> getRoomBasicData() async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/getBasicData'));

     List<Emossion> emossions = [];
     List<RoomTheme> themes = [];
     List<Gift> gifts = [];
     List<Category> categories = [];
    RoomBasicDataHelper helper = RoomBasicDataHelper(emossions: emossions, themes: themes, gifts: gifts, categories: categories);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        for (var j = 0; j < jsonData['emossions'].length; j ++) {
          Emossion emossion = Emossion.fromJson(jsonData['emossions'][j]);
          emossions.add(emossion);
        }
        for (var j = 0; j < jsonData['themes'].length; j ++) {
          RoomTheme theme = RoomTheme.fromJson(jsonData['themes'][j]);
          themes.add(theme);
        }
        for (var j = 0; j < jsonData['gifts'].length; j ++) {
          Gift gift = Gift.fromJson(jsonData['gifts'][j]);
          gifts.add(gift);
        }

        for (var j = 0; j < jsonData['giftCategories'].length; j ++) {
          Category category = Category.fromJson(jsonData['giftCategories'][j]);
          categories.add(category);
        }

        helper.categories = categories ;
        helper.gifts = gifts ;
        helper.themes = themes ;
        helper.emossions = emossions ;


        return helper;
      } else {

      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> updateRoomName(id , name) async {
    ChatRoom room;
    List<Mic> mics = [] ;
    List<RoomMember> members = [] ;
    List<RoomAdmin> admins = [] ;
    List<RoomFollow> followers = [] ;
    List<RoomBlock> blockers = [] ;
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/updateName'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id.toString(),
        'name': name.toString(),
      }),
    );
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        room = ChatRoom.fromJson(jsonData['room']);

        for (var j = 0; j < jsonData['mics'].length; j ++) {
          Mic mic = Mic.fromJson(jsonData['mics'][j]);
          mics.add(mic);
        }
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RoomMember member = RoomMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        for (var j = 0; j < jsonData['admins'].length; j ++) {
          RoomAdmin admin = RoomAdmin.fromJson(jsonData['admins'][j]);
          admins.add(admin);
        }

        for (var j = 0; j < jsonData['followers'].length; j ++) {
          RoomFollow follow = RoomFollow.fromJson(jsonData['followers'][j]);
          followers.add(follow);
        }
        for (var j = 0; j < jsonData['blockers'].length; j ++) {
          RoomBlock block = RoomBlock.fromJson(jsonData['blockers'][j]);
          blockers.add(block);
        }
        room.mics = mics ;
        room.blockers = blockers ;
        room.admins = admins ;
        room.members = members ;
        room.followers = followers ;


        return room;
      } else {
        Fluttertoast.showToast(
            msg: 'remote_chat_msg_failed'.tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> updateRoomHello(id , hello_message) async {
    ChatRoom room;
    List<Mic> mics = [] ;
    List<RoomMember> members = [] ;
    List<RoomAdmin> admins = [] ;
    List<RoomFollow> followers = [] ;
    List<RoomBlock> blockers = [] ;
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/updateHello'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id.toString(),
        'hello_message': hello_message.toString(),
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        room = ChatRoom.fromJson(jsonData['room']);

        for (var j = 0; j < jsonData['mics'].length; j ++) {
          Mic mic = Mic.fromJson(jsonData['mics'][j]);
          mics.add(mic);
        }
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RoomMember member = RoomMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        for (var j = 0; j < jsonData['admins'].length; j ++) {
          RoomAdmin admin = RoomAdmin.fromJson(jsonData['admins'][j]);
          admins.add(admin);
        }

        for (var j = 0; j < jsonData['followers'].length; j ++) {
          RoomFollow follow = RoomFollow.fromJson(jsonData['followers'][j]);
          followers.add(follow);
        }
        for (var j = 0; j < jsonData['blockers'].length; j ++) {
          RoomBlock block = RoomBlock.fromJson(jsonData['blockers'][j]);
          blockers.add(block);
        }
        room.mics = mics ;
        room.blockers = blockers ;
        room.admins = admins ;
        room.members = members ;
        room.followers = followers ;


        return room;
      } else {
        Fluttertoast.showToast(
            msg: 'remote_chat_msg_failed'.tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> updateRoomPassword(id , password) async {
    ChatRoom room;
    List<Mic> mics = [] ;
    List<RoomMember> members = [] ;
    List<RoomAdmin> admins = [] ;
    List<RoomFollow> followers = [] ;
    List<RoomBlock> blockers = [] ;
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/updatePassword'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id.toString(),
        'password': password.toString(),
      }),
    );
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        room = ChatRoom.fromJson(jsonData['room']);

        for (var j = 0; j < jsonData['mics'].length; j ++) {
          Mic mic = Mic.fromJson(jsonData['mics'][j]);
          mics.add(mic);
        }
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RoomMember member = RoomMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        for (var j = 0; j < jsonData['admins'].length; j ++) {
          RoomAdmin admin = RoomAdmin.fromJson(jsonData['admins'][j]);
          admins.add(admin);
        }

        for (var j = 0; j < jsonData['followers'].length; j ++) {
          RoomFollow follow = RoomFollow.fromJson(jsonData['followers'][j]);
          followers.add(follow);
        }
        for (var j = 0; j < jsonData['blockers'].length; j ++) {
          RoomBlock block = RoomBlock.fromJson(jsonData['blockers'][j]);
          blockers.add(block);
        }
        room.mics = mics ;
        room.blockers = blockers ;
        room.admins = admins ;
        room.members = members ;
        room.followers = followers ;


        return room;
      } else {
        Fluttertoast.showToast(
            msg: 'remote_chat_msg_failed'.tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> enterRoom(user_id , room_id) async {
    ChatRoom room;
    List<Mic> mics = [] ;
    List<RoomMember> members = [] ;
    List<RoomAdmin> admins = [] ;
    List<RoomFollow> followers = [] ;
    List<RoomBlock> blockers = [] ;
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/enterRoom'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
      }),
    );
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        room = ChatRoom.fromJson(jsonData['room']);

        for (var j = 0; j < jsonData['mics'].length; j ++) {
          Mic mic = Mic.fromJson(jsonData['mics'][j]);
          mics.add(mic);
        }
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RoomMember member = RoomMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        for (var j = 0; j < jsonData['admins'].length; j ++) {
          RoomAdmin admin = RoomAdmin.fromJson(jsonData['admins'][j]);
          admins.add(admin);
        }

        for (var j = 0; j < jsonData['followers'].length; j ++) {
          RoomFollow follow = RoomFollow.fromJson(jsonData['followers'][j]);
          followers.add(follow);
        }
        for (var j = 0; j < jsonData['blockers'].length; j ++) {
          RoomBlock block = RoomBlock.fromJson(jsonData['blockers'][j]);
          blockers.add(block);
        }
        room.mics = mics ;
        room.blockers = blockers ;
        room.admins = admins ;
        room.members = members ;
        room.followers = followers ;


        return room;
      } else {
        // Fluttertoast.showToast(
        //     msg: 'remote_chat_msg_failed'.tr,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black26,
        //     textColor: Colors.orange,
        //     fontSize: 16.0
        // );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }
  Future<ChatRoom?> exitRoom(user_id , room_id) async {
    ChatRoom room;
    List<Mic> mics = [] ;
    List<RoomMember> members = [] ;
    List<RoomAdmin> admins = [] ;
    List<RoomFollow> followers = [] ;
    List<RoomBlock> blockers = [] ;
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/exitRoom'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        room = ChatRoom.fromJson(jsonData['room']);

        for (var j = 0; j < jsonData['mics'].length; j ++) {
          Mic mic = Mic.fromJson(jsonData['mics'][j]);
          mics.add(mic);
        }
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RoomMember member = RoomMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        for (var j = 0; j < jsonData['admins'].length; j ++) {
          RoomAdmin admin = RoomAdmin.fromJson(jsonData['admins'][j]);
          admins.add(admin);
        }

        for (var j = 0; j < jsonData['followers'].length; j ++) {
          RoomFollow follow = RoomFollow.fromJson(jsonData['followers'][j]);
          followers.add(follow);
        }
        for (var j = 0; j < jsonData['blockers'].length; j ++) {
          RoomBlock block = RoomBlock.fromJson(jsonData['blockers'][j]);
          blockers.add(block);
        }
        room.mics = mics ;
        room.blockers = blockers ;
        room.admins = admins ;
        room.members = members ;
        room.followers = followers ;


        return room;
      } else {
        // Fluttertoast.showToast(
        //     msg: 'remote_chat_msg_failed'.tr,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black26,
        //     textColor: Colors.orange,
        //     fontSize: 16.0
        // );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> lockMic(user_id , room_id , mic) async {
    ChatRoom room;
    List<Mic> mics = [] ;
    List<RoomMember> members = [] ;
    List<RoomAdmin> admins = [] ;
    List<RoomFollow> followers = [] ;
    List<RoomBlock> blockers = [] ;
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/lockMic'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
        'mic': mic.toString()
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        room = ChatRoom.fromJson(jsonData['room']);

        for (var j = 0; j < jsonData['mics'].length; j ++) {
          Mic mic = Mic.fromJson(jsonData['mics'][j]);
          mics.add(mic);
        }
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RoomMember member = RoomMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        for (var j = 0; j < jsonData['admins'].length; j ++) {
          RoomAdmin admin = RoomAdmin.fromJson(jsonData['admins'][j]);
          admins.add(admin);
        }

        for (var j = 0; j < jsonData['followers'].length; j ++) {
          RoomFollow follow = RoomFollow.fromJson(jsonData['followers'][j]);
          followers.add(follow);
        }
        for (var j = 0; j < jsonData['blockers'].length; j ++) {
          RoomBlock block = RoomBlock.fromJson(jsonData['blockers'][j]);
          blockers.add(block);
        }
        room.mics = mics ;
        room.blockers = blockers ;
        room.admins = admins ;
        room.members = members ;
        room.followers = followers ;


        return room;
      } else {
        // Fluttertoast.showToast(
        //     msg: 'remote_chat_msg_failed'.tr,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black26,
        //     textColor: Colors.orange,
        //     fontSize: 16.0
        // );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }
  Future<ChatRoom?> unlockMic(user_id , room_id , mic) async {
    ChatRoom room;
    List<Mic> mics = [] ;
    List<RoomMember> members = [] ;
    List<RoomAdmin> admins = [] ;
    List<RoomFollow> followers = [] ;
    List<RoomBlock> blockers = [] ;
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/unlockMic'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
        'mic': mic.toString()
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        room = ChatRoom.fromJson(jsonData['room']);

        for (var j = 0; j < jsonData['mics'].length; j ++) {
          Mic mic = Mic.fromJson(jsonData['mics'][j]);
          mics.add(mic);
        }
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RoomMember member = RoomMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        for (var j = 0; j < jsonData['admins'].length; j ++) {
          RoomAdmin admin = RoomAdmin.fromJson(jsonData['admins'][j]);
          admins.add(admin);
        }

        for (var j = 0; j < jsonData['followers'].length; j ++) {
          RoomFollow follow = RoomFollow.fromJson(jsonData['followers'][j]);
          followers.add(follow);
        }
        for (var j = 0; j < jsonData['blockers'].length; j ++) {
          RoomBlock block = RoomBlock.fromJson(jsonData['blockers'][j]);
          blockers.add(block);
        }
        room.mics = mics ;
        room.blockers = blockers ;
        room.admins = admins ;
        room.members = members ;
        room.followers = followers ;


        return room;
      } else {
        // Fluttertoast.showToast(
        //     msg: 'remote_chat_msg_failed'.tr,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black26,
        //     textColor: Colors.orange,
        //     fontSize: 16.0
        // );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> useMic(user_id , room_id , mic) async {
    ChatRoom room;
    List<Mic> mics = [] ;
    List<RoomMember> members = [] ;
    List<RoomAdmin> admins = [] ;
    List<RoomFollow> followers = [] ;
    List<RoomBlock> blockers = [] ;
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/useMic'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
        'mic': mic.toString()
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        room = ChatRoom.fromJson(jsonData['room']);

        for (var j = 0; j < jsonData['mics'].length; j ++) {
          Mic mic = Mic.fromJson(jsonData['mics'][j]);
          mics.add(mic);
        }
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RoomMember member = RoomMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        for (var j = 0; j < jsonData['admins'].length; j ++) {
          RoomAdmin admin = RoomAdmin.fromJson(jsonData['admins'][j]);
          admins.add(admin);
        }

        for (var j = 0; j < jsonData['followers'].length; j ++) {
          RoomFollow follow = RoomFollow.fromJson(jsonData['followers'][j]);
          followers.add(follow);
        }
        for (var j = 0; j < jsonData['blockers'].length; j ++) {
          RoomBlock block = RoomBlock.fromJson(jsonData['blockers'][j]);
          blockers.add(block);
        }
        room.mics = mics ;
        room.blockers = blockers ;
        room.admins = admins ;
        room.members = members ;
        room.followers = followers ;


        return room;
      } else {
        // Fluttertoast.showToast(
        //     msg: 'remote_chat_msg_failed'.tr,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black26,
        //     textColor: Colors.orange,
        //     fontSize: 16.0
        // );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }


  Future<ChatRoom?> leaveMic(user_id , room_id , mic) async {
    ChatRoom room;
    List<Mic> mics = [] ;
    List<RoomMember> members = [] ;
    List<RoomAdmin> admins = [] ;
    List<RoomFollow> followers = [] ;
    List<RoomBlock> blockers = [] ;
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/leaveMic'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
        'mic': mic.toString()
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        room = ChatRoom.fromJson(jsonData['room']);

        for (var j = 0; j < jsonData['mics'].length; j ++) {
          Mic mic = Mic.fromJson(jsonData['mics'][j]);
          mics.add(mic);
        }
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RoomMember member = RoomMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        for (var j = 0; j < jsonData['admins'].length; j ++) {
          RoomAdmin admin = RoomAdmin.fromJson(jsonData['admins'][j]);
          admins.add(admin);
        }

        for (var j = 0; j < jsonData['followers'].length; j ++) {
          RoomFollow follow = RoomFollow.fromJson(jsonData['followers'][j]);
          followers.add(follow);
        }
        for (var j = 0; j < jsonData['blockers'].length; j ++) {
          RoomBlock block = RoomBlock.fromJson(jsonData['blockers'][j]);
          blockers.add(block);
        }
        room.mics = mics ;
        room.blockers = blockers ;
        room.admins = admins ;
        room.members = members ;
        room.followers = followers ;


        return room;
      } else {
        // Fluttertoast.showToast(
        //     msg: 'remote_chat_msg_failed'.tr,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black26,
        //     textColor: Colors.orange,
        //     fontSize: 16.0
        // );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> changeTheme(bg , room_id) async {
    ChatRoom room;
    List<Mic> mics = [] ;
    List<RoomMember> members = [] ;
    List<RoomAdmin> admins = [] ;
    List<RoomFollow> followers = [] ;
    List<RoomBlock> blockers = [] ;
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/chnageRoomBg'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'room_id': room_id.toString(),
        'bg': bg.toString()
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        room = ChatRoom.fromJson(jsonData['room']);

        for (var j = 0; j < jsonData['mics'].length; j ++) {
          Mic mic = Mic.fromJson(jsonData['mics'][j]);
          mics.add(mic);
        }
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RoomMember member = RoomMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        for (var j = 0; j < jsonData['admins'].length; j ++) {
          RoomAdmin admin = RoomAdmin.fromJson(jsonData['admins'][j]);
          admins.add(admin);
        }

        for (var j = 0; j < jsonData['followers'].length; j ++) {
          RoomFollow follow = RoomFollow.fromJson(jsonData['followers'][j]);
          followers.add(follow);
        }
        for (var j = 0; j < jsonData['blockers'].length; j ++) {
          RoomBlock block = RoomBlock.fromJson(jsonData['blockers'][j]);
          blockers.add(block);
        }
        room.mics = mics ;
        room.blockers = blockers ;
        room.admins = admins ;
        room.members = members ;
        room.followers = followers ;


        return room;
      } else {
        // Fluttertoast.showToast(
        //     msg: 'remote_chat_msg_failed'.tr,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black26,
        //     textColor: Colors.orange,
        //     fontSize: 16.0
        // );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }


}
import 'dart:convert';

import 'package:clubchat/helpers/RoomHelper.dart';
import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/models/Mic.dart';
import 'package:clubchat/models/RoomAdmin.dart';
import 'package:clubchat/models/RoomBlock.dart';
import 'package:clubchat/models/RoomFollow.dart';
import 'package:clubchat/models/RoomMember.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ChatRoomService {

  static ChatRoom? room  ;
  roomSetter(ChatRoom u){
    room = u ;
  }
  ChatRoom? roomGetter(){
    return room ;
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
          RoomMember member = RoomMember.fromJson(jsonData['admins'][j]);
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
            msg: 'Failed to open room , please contact support !',
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
}
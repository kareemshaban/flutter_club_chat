import 'dart:convert';

import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:http/http.dart' as http;

class ChatRoomService {

  Future<List<ChatRoom>> getAllChatRooms() async {
    final response = await http.get(Uri.parse('${BASEURL}chatRooms/getAll'));
    List<ChatRoom> rooms  = [];
    if (response.statusCode == 200) {
      List<dynamic>  jsonData = json.decode(response.body);
      for( var i = 0 ; i < jsonData.length ; i ++ ){
        ChatRoom room = ChatRoom.fromJson(jsonData[i]);
        rooms.add(room);
      }
      return rooms ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load chatroom');
    }

  }

  Future<List<ChatRoom>> searchRoom(txt) async {
    final response = await http.get(Uri.parse('${BASEURL}chatRooms/Search/${txt}'));
    List<ChatRoom> rooms  = [];
    if (response.statusCode == 200) {
      List<dynamic>  jsonData = json.decode(response.body);
      for( var i = 0 ; i < jsonData.length ; i ++ ){
        ChatRoom user = ChatRoom.fromJson(jsonData[i]);
        rooms.add(user);
      }
      return rooms ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

  Future<ChatRoom> openMyRoom(user_id) async {
    final response = await http.get(Uri.parse('${BASEURL}chatRooms/getRoom/${user_id}'));
    ChatRoom? room ;

    final Map jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      room =   ChatRoom.fromJson(jsonData['room']);
      // for (var j = 0; j < jsonData['followers'].length; j ++) {
      //   Follower like = Follower.fromJson(jsonData['followers'][j]);
      //   followers.add(like);
      //
      // }
      return room ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

}
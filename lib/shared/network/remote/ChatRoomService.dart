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

  Future<List<ChatRoom>> searchUser(txt) async {
    final response = await http.get(Uri.parse('${BASEURL}users/chatRooms/${txt}'));
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

}
import 'dart:io';
import 'package:clubchat/helpers/RoomBasicDataHelper.dart';
import 'package:clubchat/helpers/RoomCupHelper.dart';
import 'package:clubchat/helpers/RoomHelper.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/Category.dart';
import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/models/Emossion.dart';
import 'package:clubchat/models/Gift.dart';
import 'package:clubchat/models/Mic.dart';
import 'package:clubchat/models/RoomAdmin.dart';
import 'package:clubchat/models/RoomBlock.dart';
import 'package:clubchat/models/RoomCup.dart';
import 'package:clubchat/models/RoomFollow.dart';
import 'package:clubchat/models/RoomMember.dart';
import 'package:clubchat/models/RoomTheme.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';



class ChatRoomService {

  static ChatRoom? room  ;
  static ChatRoom? savedRoom  ;
  static RtcEngine? engine ;
  static int musicPlayedIndex = - 1 ;
  static bool showMsgInput = false ;
  static RoomBasicDataHelper? roomBasicDataHelper  ;
  roomSetter(ChatRoom u){
    room = u ;
  }
  ChatRoom? roomGetter(){
    return room ;
  }

  savedRoomSetter(ChatRoom? u){
    savedRoom = u ;
  }
  ChatRoom? savedRoomGetter(){
    return savedRoom ;
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

  ChatRoom mapRoom(jsonData){
    ChatRoom room;
    List<Mic> mics = [] ;
    List<RoomMember> members = [] ;
    List<RoomAdmin> admins = [] ;
    List<RoomFollow> followers = [] ;
    List<RoomBlock> blockers = [] ;
    room = ChatRoom.fromJson(jsonData['room']);
    int roomCup = jsonData['roomCup'] ;
    room.roomCup = roomCup.toString() ;

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
  }

  Future<ChatRoom?> openMyRoom(admin_id) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/getRoom/${admin_id}'));


    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
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
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
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
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);

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
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
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
        return mapRoom(jsonData);
      } else {
        throw Exception('Failed to load album');
      }
    }
  }

  Future<ChatRoom?> updateRoomHello(id , hello_message) async {
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
        return mapRoom(jsonData);
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
        return mapRoom(jsonData);
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
        return mapRoom(jsonData);
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
        return mapRoom(jsonData);
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
        return mapRoom(jsonData);
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
        return mapRoom(jsonData);
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
        return mapRoom(jsonData);
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
        return mapRoom(jsonData);
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
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
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

  Future<bool> sendGift(sender_id , recevier_id , owner_id , room_id , gift_id , count) async{


    var response = await http.post(
      Uri.parse('${BASEURL}gifts/sendGift'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'sender_id': sender_id.toString(),
        'recevier_id': recevier_id.toString(),
        'owner_id': owner_id.toString(),
        'room_id': room_id.toString(),
        'gift_id': gift_id.toString(),
        'count': count.toString(),
      }),
    );
    print('sengift');

    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      print(jsonData['message'] );
      if(jsonData['message'] == 'success'){
        return true ;
      } else {
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
        return false ;
      }


    } else {
      print(response.body);
      throw Exception('Failed to send gift');



    }
  }

  Future<RoomCupHelper> getRoomCup($room_id) async {

    List<RoomCup> daily = [] ;
    List<RoomCup> weekly = [] ;
    List<RoomCup> monthly = [] ;
    RoomCupHelper helper = new RoomCupHelper(daily: daily , weekly: weekly , monthly: monthly);
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/getRoomCup/${$room_id}'));
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      AppUser? user ;
      for (var j = 0; j < jsonData['daily'].length; j ++) {
        RoomCup cup = RoomCup.fromJson(jsonData['daily'][j]);
        user = await AppUserServices().getUser(cup.sender_id);
        cup.user = user ;
        daily.add(cup);
      }
      for (var j = 0; j < jsonData['weekly'].length; j ++) {
        RoomCup cup = RoomCup.fromJson(jsonData['weekly'][j]);
        user = await AppUserServices().getUser(cup.sender_id);
        cup.user = user ;
        weekly.add(cup);
      }
      for (var j = 0; j < jsonData['monthly'].length; j ++) {
        RoomCup cup = RoomCup.fromJson(jsonData['monthly'][j]);
        user = await AppUserServices().getUser(cup.sender_id);
        cup.user = user ;
        monthly.add(cup);
      }
      helper.daily = daily ;
      helper.monthly = monthly ;
      helper.weekly = weekly ;

      return helper ;
    } else {
      throw Exception('Failed to load album');
    }

  }


  Future<ChatRoom?> updateRoomCategory(id , subject) async {
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/updateRoomCategory'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id.toString(),
        'subject': subject.toString(),
      }),
    );
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
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

  Future<AppUser?> updateRoomImg(id , File? imageFile   ) async {

    var stream = new http.ByteStream(DelegatingStream.typed(imageFile!.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(BASEURL+'chatRooms/updateRoomImage');

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('img', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    request.fields.addAll(<String, String>{
      'id': id.toString() ,
    });
    var response = await request.send();
    print('upload image');
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });

  }

  Future<ChatRoom?> addChatRoomAdmin(user_id , room_id) async {
    ChatRoom room;
    List<Mic> mics = [] ;
    List<RoomMember> members = [] ;
    List<RoomAdmin> admins = [] ;
    List<RoomFollow> followers = [] ;
    List<RoomBlock> blockers = [] ;
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/addAdmin'),
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
        return mapRoom(jsonData);
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

  Future<ChatRoom?> removeChatRoomAdmin(user_id , room_id) async {
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/removeAdmin'),
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
        return mapRoom(jsonData);
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

  Future<ChatRoom?> toggleRoomCounter(room_id) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/toggleCounter/${room_id}'));
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
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



}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/message.dart';

class ChatService extends ChangeNotifier {
  // get instance of auth and firestore
  AppUser? user = AppUserServices().userGetter();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance ;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance ;
  //send message
  Future<void> sendMessage(int receiverId , String message )async {
    //get current user information
    final int currentUserId = user!.id;
    final String currentUserEmail = user!.email;
    final Timestamp timestamp = Timestamp.now() ;
    //create a new message
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp
    );

    List<int> ids = [currentUserId , receiverId];
    ids.sort() ;
    String chatRoomId = ids.join("_");

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap()
    );

    // call sendMess

  }
//get messages
  Stream<QuerySnapshot> getMessages(int userId , int otherUserId){
    // construct chat room id from user id (sorted to ensure it matches the id used when sending message
    List<int> ids = [userId , otherUserId] ;
    ids.sort() ;
    print(ids);
    String chatRoomId = ids.join("_");
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp',descending: false)
        .snapshots();
  }
}
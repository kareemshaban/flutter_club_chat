import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubchat/shared/network/remote/ChatRoomService.dart';

class ExitRoomHelper {
  final int user_id ;
  final int room_id ;
  ExitRoomHelper( this.user_id ,  this.room_id){
    handleExitRoom();
  }
  handleExitRoom() async{
    await ChatRoomService().exitRoom(user_id, room_id);
    await FirebaseFirestore.instance.collection("exitRoom").add({
      'room_id': room_id,
      'user_id': user_id,
    });
  }
}
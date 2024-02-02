import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService{
  Future<void> send_notification(token,message,user)async{
    var response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':'key=AAAA9KG6GqI:APA91bE3eRJUYtH33C8bpKWdyi4tcQwmIqhSq3_IPNUnjrAXUnyN3tNSfxiY8uS_DJ1zGgQD8XVDtANvBOnd3703JE77iTQjWoVAuCh6Q_KEDnxWP-1KWs44eCcIuLhRY14ELm7eKywN'
      },
      body: jsonEncode(<String, dynamic>{
          "to":token,

          "notification":{
            "title":"you have recieved a message from ${user}",
            "body":message,
            "sound":"default"
          },

          "android": {
            "priority": "HEIG",
            "notification": {
              "notification_priority" : "PRIORITY_MAX" ,
              "sound":"default",
              "default_sound": true ,
              "default_vibrate_timings":true ,
              "default_light_settings":true,
            }
          },
          "data":{
            "type":"order",
            "id":"87" ,
            "click_action":"FLUTTER_NOTIFICATION_CLICK"
          }
      }),
    );
    print(response..body);
  }
}
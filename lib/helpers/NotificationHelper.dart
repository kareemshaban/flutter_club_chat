import 'package:clubchat/models/Announcement.dart';
import 'package:clubchat/models/Notification.dart';

class NotificationHelper {
  List<UserNotification>? notifications = [];
  List<Announcement>?   announcements  = [];

  NotificationHelper({this.notifications , this.announcements});
}
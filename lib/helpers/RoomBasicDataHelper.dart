import 'package:clubchat/models/Category.dart';
import 'package:clubchat/models/Emossion.dart';
import 'package:clubchat/models/Gift.dart';
import 'package:clubchat/models/RoomTheme.dart';

class RoomBasicDataHelper {
   List<Emossion> emossions ;
   List<RoomTheme> themes ;
   List<Gift> gifts ;
   List<Category> categories ;

  RoomBasicDataHelper({required this.emossions , required this.themes , required this.gifts , required this.categories});

}
import 'package:clubchat/models/AgencyMember.dart';
import 'package:clubchat/models/AgencyMemberPoints.dart';
import 'package:clubchat/models/AgencyMemberStatics.dart';
import 'package:clubchat/models/AgencyTarget.dart';

class AgencyMemberIncomeHelper {
   AgencyMember? member ;
   List<AgencyMemberStatics>  statics ;
   List<AgencyMemberPoints> points ;
   AgencyTarget? currentTarget ;
   AgencyTarget? nextTarget ;
  AgencyMemberIncomeHelper({required this.member , required this.statics , required this.points ,
    required this.currentTarget , required this.nextTarget});
}
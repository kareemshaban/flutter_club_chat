class ChatRoom {
  final int id ;
  final String tag ;
  final String name ;
  final String img ;
  final int state ;
  final String password ;
  final int userId ;
  final String subject ;
  final int talkers_count ;
  final int starred ;
  final int isBlocked ;
  final String blockedDate ;
  final String blockedUntil ;
  final String createdDate ;
  final int isTrend ;
  final String details ;
  final int micCount ;
  final int enableMessages ;
  final int reportCount ;
  final int themeId ;
  final String flag ;
  final String admin_tag ;
  final String admin_name ;
  final String admin_img ;
  final int country_id ;


  ChatRoom({required this.id, required this.tag,required this.name, required this.img,required  this.state, required this.password, required this.userId, required this.subject, required this.talkers_count,
    required this.starred,required this.isBlocked,required this.blockedDate, required this.blockedUntil, required this.createdDate, required this.isTrend, required this.details, required this.micCount,
    required this.enableMessages, required this.reportCount, required this.themeId , required this.flag , required this.admin_tag , required this.admin_name , required this .admin_img , required this.country_id});


  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'tag': String tag,
      'name': String name,
      'img': String img,
      'state': int state,
      'password': String password,
      'userId': int userId,
      'subject': String subject,
      'talkers_count': int talkers_count,
      'starred': int starred,
      'isBlocked': int isBlocked,
      'blockedDate': String blockedDate,
      'blockedUntil': String blockedUntil,
      'createdDate': String createdDate,
      'isTrend': int isTrend,
      'details': String details,
      'micCount': int micCount,
      'enableMessages': int enableMessages,
      'reportCount': int reportCount,
      'themeId': int themeId,
      'flag': String flag,
      'admin_tag': String admin_tag,
      'admin_name': String admin_name,
      'admin_img': String admin_img,
      'country_id': int country_id


      } =>
          ChatRoom(
              id: id,
              tag: tag,
              name: name,
              img: img,
              state: state,
              password: password,
              userId: userId,
              subject: subject,
              talkers_count: talkers_count,
              starred: starred,
              isBlocked: isBlocked,
              blockedDate: blockedDate,
              blockedUntil: blockedUntil,
              createdDate: createdDate,
              isTrend: isTrend,
              details: details,
              micCount: micCount,
              enableMessages: enableMessages,
              reportCount: reportCount,
              themeId: themeId,
              flag: flag,
              admin_tag: admin_tag,
              admin_name: admin_name,
              admin_img: admin_img,
              country_id: country_id

          ),
      _ => throw const FormatException('Failed to load Room.'),
    };
  }

}
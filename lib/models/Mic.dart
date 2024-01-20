class Mic {
  final int id ;
  final int room_id ;
  final int order ;
  final int user_id ;
  final int isClosed ;
  final int isMute ;
  final String? mic_user_tag ;
  final String? mic_user_name ;
  final String? mic_user_img ;
  final String? mic_user_gender ;
  final String? mic_user_birth_date ;
  final String? mic_user_share_level ;
  final String? mic_user_karizma_level ;
  final String? mic_user_charging_level ;


  Mic({required this.id , required this.room_id , required this.order, required this.user_id , required this.isClosed ,
    required this.isMute ,
  this.mic_user_tag , this.mic_user_name , this.mic_user_img , this.mic_user_gender , this.mic_user_birth_date ,
  this.mic_user_share_level , this.mic_user_karizma_level , this.mic_user_charging_level});


  factory Mic.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'room_id': int room_id,
      'order': String order,
      'user_id': int user_id,
      'isClosed': String isClosed,
      'isMute': int isMute,
      'mic_user_tag': String mic_user_tag,
      'mic_user_name': int mic_user_name,
      'mic_user_img': int mic_user_img,
      'mic_user_img': int mic_user_img,
      'mic_user_img': int mic_user_img,
      'mic_user_img': int mic_user_img,
      } =>
          Mic(
            id: id,
            type: type,
            name: name,
            order: order,
            img: img,
            action: action,
            url: url,
            user_id: user_id,
            room_id: room_id,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
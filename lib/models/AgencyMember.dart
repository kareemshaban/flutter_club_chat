class AgencyMember {
  final String member_name ;
  final String member_tag ;
  final String member_img;
  final String joining_date ;

  AgencyMember({required this.member_img , required this.member_name , required this.member_tag , required this.joining_date});

  factory AgencyMember.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'member_img': String member_img,
      'member_name': String member_name,
      'member_tag': String member_tag,
      'joining_date': String joining_date
      } =>
          AgencyMember(
            member_img: member_img,
            member_name: member_name,
            member_tag: member_tag,
            joining_date: joining_date
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}
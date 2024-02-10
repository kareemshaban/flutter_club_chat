import 'dart:convert';

import 'package:clubchat/models/Design.dart';
import 'package:clubchat/models/Mall.dart';
import 'package:clubchat/models/Vip.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:http/http.dart' as http;

class VipServices {

  Future<List<Mall>> getAllVip() async {
    final response = await http.get(Uri.parse('${BASEURL}vip/all'));
    List<Mall> designs = [] ;
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);

      for( var i = 0 ; i < jsonData['designs'].length ; i ++ ){
        Mall design = Mall.fromJson(jsonData['designs'][i]);
        designs.add(design);
      }

      return designs ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }
  Future<List<Vip>> getAllVipTags() async {
    final response = await http.get(Uri.parse('${BASEURL}vip/getAll'));
    List<Vip> vips = [] ;
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);

      for( var i = 0 ; i < jsonData['vips'].length ; i ++ ){
        Vip design = Vip.fromJson(jsonData['vips'][i]);
        vips.add(design);
      }

      return vips ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }


}
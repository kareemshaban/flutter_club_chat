import 'dart:convert';

import 'package:clubchat/models/ChargingOperation.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:http/http.dart' as http;

class WalletServices {

  Future<List<ChargingOperation>> getUserChargingOperations(user_id) async {
    final response = await http.get(Uri.parse('${BASEURL}wallet/getChargingTransactions/${user_id}'));
    List<ChargingOperation> operatins  = [];
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){
        for (var j = 0; j < jsonData['transactions'].length; j ++) {
          ChargingOperation op = ChargingOperation.fromJson(jsonData['transactions'][j]);
          operatins.add(op);

        }
        return operatins ;
      } else {
        operatins = [] ;
        return operatins ;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load country');
    }

  }


}
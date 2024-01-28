import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  AppUser? user ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

    );
  }
}

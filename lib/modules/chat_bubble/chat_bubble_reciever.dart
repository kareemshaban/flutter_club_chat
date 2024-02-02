import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message ;
  const ChatBubble({
    super.key ,
    required this.message,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 37,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: MyColors.unSelectedColor ,
      ),
      child: Center(
        child: Text(
          message,
          style:const TextStyle(fontSize: 16.0 , color: Colors.white),
        ),
      ),
    );
  }
}

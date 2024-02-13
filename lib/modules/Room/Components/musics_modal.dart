import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../shared/styles/colors.dart';
import 'music2_modal.dart';

class MusicsModal extends StatefulWidget {
  const MusicsModal({super.key});

  @override
  State<MusicsModal> createState() => _MusicsModalState();
}

class _MusicsModalState extends State<MusicsModal> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: MediaQuery.of(context).size.height / 2 ,
      decoration: BoxDecoration(color: Colors.black.withAlpha(180),
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(15.0)) ,
          border: Border(top: BorderSide(width: 3.0, color: MyColors.primaryColor),
          )
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text('My Music',style: TextStyle(color: Colors.white,fontSize: 20.0),),
                  ],
                ),
              ),
              IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                    showModalBottomSheet(
                        context: context,
                        builder: (ctx) => Music2BottomSheet());
                  },
                  icon: Icon(Icons.add_circle_outline , color:  Colors.white,)
              )
            ],
          )
        ],
      ),
    );
  }
}

Widget Music2BottomSheet( ) => MusicsModal2();

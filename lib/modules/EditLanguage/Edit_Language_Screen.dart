import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class EditLanguageScreen extends StatefulWidget {
  const EditLanguageScreen({super.key});

  @override
  State<EditLanguageScreen> createState() => _EditLanguageScreenState();
}

class _EditLanguageScreenState extends State<EditLanguageScreen> {
  dynamic groupValue ;
  dynamic englishRadioVal ;
  dynamic arabicRadioVal ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.darkColor,
        title: Text("Edit Language" , style: TextStyle(color: Colors.white,fontSize: 18.0) ,),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              color: Colors.black26,
              padding: EdgeInsets.all(15.0) ,
              child: Row(
                children: [
                  Text("English" ,style:TextStyle(color: Colors.white,fontSize: 15.0) ,),
                  Expanded(child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Transform.scale(
                            scale:1.3 ,
                            child: Radio(activeColor: MyColors.primaryColor,value: englishRadioVal, groupValue:groupValue , onChanged: (val){}))
                      ],
                    )
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.black45,
              margin: EdgeInsetsDirectional.only(start: 15.0),
            ),
            Container(
              color: Colors.black26,
              padding: EdgeInsets.all(15.0) ,
              child: Row(
                children: [
                  Text("Arabic" ,style:TextStyle(color: Colors.white,fontSize: 15.0) ,),
                  Expanded(child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Transform.scale(
                          scale: 1.3,
                          child:
                          Radio( activeColor: MyColors.primaryColor,value: englishRadioVal, groupValue:groupValue , onChanged: (val){}))
                    ],
                  )
                  ),
                ],
              ),
            ),
          ],
          )
        ),
      );
  }
}

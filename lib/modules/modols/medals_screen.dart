import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/Design.dart';
import '../../shared/components/Constants.dart';
import '../../shared/styles/colors.dart';

class MedalsScreen extends StatefulWidget {
  const MedalsScreen({super.key});

  @override
  State<MedalsScreen> createState() => _MedalsScreenState();
}


class _MedalsScreenState extends State<MedalsScreen> {
  @override

  List<Design> gifts = [] ;

  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.unSelectedColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.darkColor,
        title: Text("Medals".tr , style: TextStyle(color: MyColors.unSelectedColor,fontSize: 20.0) ,),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: MyColors.darkColor,
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                scrollDirection: Axis.vertical,
                childAspectRatio: .7,
                crossAxisCount: 3,
                children: gifts.map((gift ) => giftItemBuilder(gift)).toList() ,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget giftItemBuilder(gift) =>  GestureDetector(
    onTap: (){} ,
    child: Container(
      width: MediaQuery.of(context).size.width / 3 ,
      margin: const EdgeInsets.all(5.0),
      child: Container(
          width: MediaQuery.of(context).size.width / 3 ,

          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.5), color: Colors.black12),
          child: Column(
            children: [
              Image(image: NetworkImage(ASSETSBASEURL + 'Designs/' + gift.icon) , width: 100.0, height: 100.0,),
              Text(gift.name , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),),
              Text("X" + gift.count.toString() , style: TextStyle(color: Colors.white , fontSize: 15.0),)
            ],
          )
      ),
    ),
  );

}

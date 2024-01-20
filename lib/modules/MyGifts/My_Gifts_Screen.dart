import 'package:clubchat/helpers/DesigGiftHelper.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/Design.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class MyGiftsScreen extends StatefulWidget {
  const MyGiftsScreen({super.key});

  @override
  State<MyGiftsScreen> createState() => _MyGiftsScreenState();
}

class _MyGiftsScreenState extends State<MyGiftsScreen> {

  AppUser? user ;
  List<Design> gifts = [] ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  getData() async{
    setState(() {
      user = AppUserServices().userGetter();
    });
    DesignGiftHelper helper = await AppUserServices().getMyDesigns(user!.id);

    setState(() {
      gifts = helper.gifts! ;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.whiteColor, //change your color here
          ),
          toolbarHeight: 70.0,
          backgroundColor: MyColors.darkColor,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                backgroundImage: user?.img != "" ?  NetworkImage('${ASSETSBASEURL}AppUsers/${user?.img}') : null,
                radius: 20,
                child: user?.img== "" ?
                Text(user!.name.toUpperCase().substring(0 , 1) +
                    (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                  style: const TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),) : null,
              ),
              SizedBox(width: 25.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Text(user!.name , style: TextStyle(color: Colors.white , fontSize: 15.0 , fontWeight: FontWeight.bold),),
                      const SizedBox(width: 10.0,),
                      CircleAvatar(
                        backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                        radius: 12.0,
                        child: user!.gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                      )
                    ],
                  ),
                  SizedBox(height: 3.0,),
                  Row(
                    children: [
                      Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.share_level_icon}') , width: 30,),
                      const SizedBox(width: 10.0,),
                      Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.karizma_level_icon}') , width: 30,),
                      const SizedBox(width: 10.0, height: 10,),
                      Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.charging_level_icon}') , width: 20,),
                    ],
                  ),


                ],
              ),
            ],
          ),

        ),
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

  // Widget giftItemBuilder(gift) =>  Container(
  //   height: 200,
  //   width: 100,
  //   color: Colors.blue,
  //   child: Column(
  //     children: [
  //       Container(
  //           width: 80.0,
  //           height: 50.0,
  //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.5), color: Colors.black12),
  //           child: Image(image: NetworkImage(ASSETSBASEURL + 'Designs/' + gift.icon) , width: 50,)
  //       ),
  //       SizedBox(height: 5.0,),
  //       Text(gift.name , style: TextStyle(fontSize: 13.0 , color: MyColors.unSelectedColor),),
  //       Text('X ' +  gift.count.toString() , style: TextStyle(fontSize: 12.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
  //     ],
  //   ),
  // );

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

  Widget seperatorItem() => SizedBox(width: 10.0,);
}

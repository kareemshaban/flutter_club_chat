import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/Visitor.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class VisitorsScreen extends StatefulWidget {
  const VisitorsScreen({super.key});

  @override
  State<VisitorsScreen> createState() => _VisitorsScreenState();
}

class _VisitorsScreenState extends State<VisitorsScreen> {
  List<Visitor>? visitors = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppUser? user = AppUserServices().userGetter();
    visitors = user!.visitors ;
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
        title: Text("Visitors" , style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder(index) ,
                  separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: visitors!.length),
            ),
          ],
        ),
      ),
    );
  }
  Widget itemListBuilder(index) => Column(
    children: [
      Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: visitors![index].follower_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,

                  backgroundImage: visitors![index].follower_img != "" ?
                  NetworkImage('${ASSETSBASEURL}AppUsers/${visitors![index].follower_img}') : null,
                  radius: 30,
                  child: visitors![index].follower_img == "" ?
                  Text(visitors![index].follower_name.toUpperCase().substring(0 , 1) +
                      (visitors![index].follower_name.contains(" ") ? visitors![index].follower_name.substring(visitors![index].follower_name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                    style: const TextStyle(color: Colors.white , fontSize: 24.0 , fontWeight: FontWeight.bold),) : null,
                )
              ],
            ),
            const SizedBox(width: 10.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(visitors![index].follower_name , style: TextStyle(color: MyColors.whiteColor , fontSize: 18.0),),
                    const SizedBox(width: 5.0,),
                    CircleAvatar(
                      backgroundColor: visitors![index].follower_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                      radius: 10.0,
                      child: visitors![index].follower_gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                    )
                  ],
                ),
                Row(

                  children: [
                    Image(image: NetworkImage(ASSETSBASEURL + 'Levels/' + visitors![index].share_level_img) , width: 40,),
                    const SizedBox(width: 10.0,),
                    Image(image: NetworkImage(ASSETSBASEURL + 'Levels/' + visitors![index].karizma_level_img) , width: 40,),
                    const SizedBox(width: 10.0,),
                    Image(image: NetworkImage(ASSETSBASEURL + 'Levels/' + visitors![index].charging_level_img) , width: 30,),

                  ],
                ),

                Text("ID:${visitors![index].follower_tag}" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 13.0),),
                


              ],

            ),
            Expanded(
              child: Column(
                children: [
                  Text(visitors![index].last_visit_date , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 12.0),),
                 SizedBox(height: 5.0,),
                  Container(
                    width: 70.0,
                    padding: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 8.0),
                    decoration: BoxDecoration(color: MyColors.solidDarkColor.withAlpha(100) , borderRadius: BorderRadius.circular(10.0)),
                    child: Row(
                      children: [
                        Text(visitors![index].visits_count.toString() , style: TextStyle(fontSize: 15.0 ,
                            fontWeight: FontWeight.bold , color: Colors.deepOrange),),
                        SizedBox(width: 5.0,),
                        Text("Views" , style: TextStyle(fontSize: 14.0 , color: MyColors.primaryColor),)
                      ],
                    ),
                  )
                ],
              ),
            )
          ]),
      Container(
        width: double.infinity,
        height: 1.0,
        color: MyColors.lightUnSelectedColor,
        margin: EdgeInsetsDirectional.only(start: 50.0),
        child: const Text(""),
      )
    ],
  );

  Widget itemSperatorBuilder() => SizedBox(height: 5.0,);
}

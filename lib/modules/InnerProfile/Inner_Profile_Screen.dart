import 'package:clubchat/helpers/DesigGiftHelper.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/Design.dart';
import 'package:clubchat/modules/EditProfile/Edit_Profile_Screen.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InnerProfileScreen extends StatefulWidget {
  final int visitor_id ;
  const InnerProfileScreen({super.key , required this.visitor_id });

  @override
  State<InnerProfileScreen> createState() => _InnerProfileScreenState();
}

class _InnerProfileScreenState extends State<InnerProfileScreen> {
  AppUser? user ;
  AppUser? visitor ;
  bool? isVisitor ;
  List<Design> designs = [] ;
  List<Design> gifts = [] ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppUser? res = AppUserServices().userGetter();
    setState(() {
      isVisitor = widget.visitor_id != 0 ;
      print(isVisitor);
      user = res;
    });
    getDesigns();
  }
  getDesigns () async {
    DesignGiftHelper helper = await AppUserServices().getMyDesigns(user!.id);
    setState(() {
      designs = helper.designs! ;
      gifts = helper.gifts! ;

    });
    print(gifts[0].id);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
          actions: [

            isVisitor! ?  PopupMenuButton<int>(
              color: MyColors.darkColor,
              onSelected: (item) => {

              },
              iconColor: Colors.white,
              iconSize: 25.0,
              itemBuilder: (context) => [
                 PopupMenuItem<int>(value: 0, child: Row(
                   children: [
                     Icon(Icons.block , color: MyColors.whiteColor , size: 18.0,),
                     SizedBox(width: 5.0,),
                     Text("inner_report".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),)
                   ],
                 )),
                PopupMenuItem<int>(value: 0, child: Row(
                  children: [
                    Icon(Icons.report , color: MyColors.whiteColor , size: 18.0,),
                    SizedBox(width: 5.0,),
                    Text("inner_block".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),)
                  ],
                )),
              ],
            ) :
                IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => const EditProfileScreen()));
                }, icon: Icon(Icons.edit))
          ],
        ),
      ),
      body: Container(
        color: MyColors.darkColor,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200.0,
                      decoration: BoxDecoration(
                          image:  user!.cover != "" ?
                          DecorationImage( image: NetworkImage(ASSETSBASEURL + 'AppUsers/Covers/' + user!.cover), fit: BoxFit.cover) :
                          DecorationImage( image: AssetImage('assets/images/cover.png'), fit: BoxFit.cover ,
                            )

                      ),
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          width: double.infinity,
                          color: MyColors.darkColor,
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              SizedBox(height: 40.0,),
                              Text(user!.name , style: TextStyle(color: Colors.white , fontSize: 18.0),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("ID:" + user!.tag , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 12.0),),
                                  const SizedBox(width: 5.0,),
                                  Icon(Icons.copy_outlined , color: MyColors.unSelectedColor , size: 20.0,)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.share_level_icon}') , width: 50,),
                                  const SizedBox(width: 10.0,),
                                  Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.karizma_level_icon}') , width: 50,),
                                  const SizedBox(width: 10.0),
                                  Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.charging_level_icon}') , width: 30,),
                                ],
                              ),
                              Text(user!.status !="" ? user!.status  : "Nothing here , update your bio" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 16.0),),
                            ],
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0, -30.0),
                          child: CircleAvatar(
                            backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                            backgroundImage: user?.img != "" ?  NetworkImage('${ASSETSBASEURL}AppUsers/${user?.img}') : null,
                            radius: 40,
                            child: user?.img== "" ?
                            Text(user!.name.toUpperCase().substring(0 , 1) +
                                (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                              style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 6.0,
                      color: MyColors.solidDarkColor,
                      margin: EdgeInsetsDirectional.only(top: 20.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8.0,
                                height: 30.0,
                                decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(3.0)),
                              ),
                              SizedBox(width: 10.0,),
                              Text("inner_basic_information".tr , style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),)
                            ],
                          ),
                          SizedBox(height: 15.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Text("ID" , style: TextStyle(fontSize: 16.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
                                Expanded(child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(user!.tag , style: TextStyle(fontSize: 16.0 , color: Colors.white),),
                                        SizedBox(width: 5.0,),
                                        IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.idBadge , color: Colors.white , size: 20.0,) ,)
                                      ],
                                    )                          ],
                                )
                
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 15.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Text("edit_profile_user_name".tr , style: TextStyle(fontSize: 16.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
                                Expanded(child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(user!.name , style: TextStyle(fontSize: 16.0 , color: Colors.white),),
                                        SizedBox(width: 5.0,),
                                        IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.faceGrinWide , color: Colors.white , size: 20.0))
                                      ],
                                    )
                
                                  ],
                                )
                
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 15.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Text("edit_profile_gender".tr , style: TextStyle(fontSize: 16.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
                                Expanded(child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(user!.gender == 0 ? "Male" : "Female" , style: TextStyle(fontSize: 16.0 , color: Colors.white),),
                                        SizedBox(width: 5.0,),
                                        IconButton(onPressed: (){}, icon: Icon(user!.gender == 0 ?  FontAwesomeIcons.male : FontAwesomeIcons.female , color: Colors.white , size: 20.0))
                                      ],
                                    )
                
                                  ],
                                )
                
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 15.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Text("edit_profile_date_of_birth".tr , style: TextStyle(fontSize: 16.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
                                Expanded(child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(formattedDate(user!.birth_date ).toString(), style: TextStyle(fontSize: 16.0 , color: Colors.white),),
                                        SizedBox(width: 5.0,),
                                        IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.birthdayCake  , color: Colors.white , size: 20.0))
                                      ],
                                    )
                
                                  ],
                                )
                
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 15.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Text("edit_profile_country".tr , style: TextStyle(fontSize: 16.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
                                Expanded(child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image(image: NetworkImage(ASSETSBASEURL + 'Countries/' + user!.country_flag) , width: 30.0,),
                                        SizedBox(width: 5.0,),
                                        IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.flag  , color: Colors.white , size: 20.0))
                
                                      ],
                                    )
                
                                  ],
                                )
                
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 6.0,
                      color: MyColors.solidDarkColor,
                      margin: EdgeInsetsDirectional.only(top: 20.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8.0,
                                height: 30.0,
                                decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(3.0)),
                              ),
                              SizedBox(width: 10.0,),
                              Text("edit_profile_my_tags".tr , style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),)
                            ],
                          ),
                          SizedBox(height: 15.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: user!.hoppies!.map((e) => hoppyListItem(e)).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 6.0,
                      color: MyColors.solidDarkColor,
                      margin: EdgeInsetsDirectional.only(top: 20.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8.0,
                                height: 30.0,
                                decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(3.0)),
                              ),
                              SizedBox(width: 10.0,),
                              Text("inner_room_gifts".tr , style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),)
                            ],
                          ),
                          SizedBox(height: 15.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 100.0,
                              child: Row(
                                children: [
                                   Expanded(child: ListView.separated(itemBuilder: (ctx , index) => giftItemBuilder(index), separatorBuilder:(ctx , index) =>  seperatorItem(), itemCount: gifts.length > 3 ? 4 : gifts.length + 1 , scrollDirection: Axis.horizontal, ))
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 6.0,
                      color: MyColors.solidDarkColor,
                      margin: EdgeInsetsDirectional.only(top: 20.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8.0,
                                height: 30.0,
                                decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(3.0)),
                              ),
                              SizedBox(width: 10.0,),
                              Text("inner_my_frames".tr , style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),)
                            ],
                          ),
                          SizedBox(height: 15.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 100.0,
                              child: Row(
                                children: [
                                  Expanded(child: ListView.separated(itemBuilder: (ctx , index) => designItemBuilder(index , 4), separatorBuilder:(ctx , index) =>  seperatorItem(), itemCount: designs.where((element) => element.category_id == 4).toList().length   , scrollDirection: Axis.horizontal, ))
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 6.0,
                      color: MyColors.solidDarkColor,
                      margin: EdgeInsetsDirectional.only(top: 20.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8.0,
                                height: 30.0,
                                decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(3.0)),
                              ),
                              SizedBox(width: 10.0,),
                              Text("inner_cars_(Entries)".tr , style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),)
                            ],
                          ),
                          SizedBox(height: 15.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 100.0,
                              child: Row(
                                children: [
                                  Expanded(child: ListView.separated(itemBuilder: (ctx , index) => designItemBuilder(index , 5), separatorBuilder:(ctx , index) =>  seperatorItem(), itemCount: designs.where((element) => element.category_id == 5).toList().length   , scrollDirection: Axis.horizontal, ))
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
           isVisitor! ? Container(
              color: MyColors.solidDarkColor.withAlpha(150),
              width: double.infinity,
              height: 80.0,
              padding: EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Image(image: AssetImage('assets/images/add-user.png') , width: 80.0,),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Image(image: AssetImage('assets/images/message.png') , width: 80.0),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Image(image: AssetImage('assets/images/home.png') , width: 80.0),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Image(image: AssetImage('assets/images/tracking.png') , width: 80.0),
                      ],
                    ),
                  ),
                  
                ],
              ),
            ) : SizedBox(height: 5.0,)
          ],
        ),
      ),
    );
  }



  String formattedDate(dateTime) {
    const DATE_FORMAT = 'dd/MM/yyyy';
    print('dateTime ($dateTime)');
    return DateFormat(DATE_FORMAT).format(DateTime.parse(dateTime) );

  }

  Widget hoppyListItem(tag) => Container(
    margin: EdgeInsets.symmetric(horizontal: 10.0),
    child: DottedBorder (
      borderType: BorderType.RRect,
      color: MyColors.primaryColor,
      strokeWidth: 1,
      dashPattern: [8, 4],
      strokeCap: StrokeCap.round,
      radius: Radius.circular(100.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0 , vertical: 8.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.transparent , width: 1.0 , style: BorderStyle.solid) , borderRadius: BorderRadius.circular(25.0) ,
            color: MyColors.blueColor.withAlpha(100) ),
        child:  Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('#${tag.name}' , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),)
          ],),
      ),

    ),
  );

  Widget giftItemBuilder(i) => i < gifts.length ? Column(
    children: [
      Container(
        width: 80.0,
        height: 55.0,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.5), color: Colors.black12),
        child: Image(image: NetworkImage(ASSETSBASEURL + 'Designs/' + gifts[i].icon) , width: 50,)
      ),
      SizedBox(height: 5.0,),
      Text(gifts[i].name , style: TextStyle(fontSize: 13.0 , color: MyColors.unSelectedColor),),
      Text('X ' +  gifts[i].count.toString() , style: TextStyle(fontSize: 12.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
    ],
  ) :  Column(
    children: [
      Container(
          width: 80.0,
          height: 55.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.5), color: Colors.black12),
          child: Icon(Icons.arrow_forward_ios_outlined , color: MyColors.unSelectedColor , size: 20.0,)
      ),
    ],
  );

  Widget seperatorItem() => SizedBox(width: 10.0,);

  Widget designItemBuilder(i , cat) => Container(
     width: 80.0,
     height: 80.0,
     decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0) , color: Colors.black12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(image: NetworkImage(ASSETSBASEURL + 'Designs/' +
            designs.where((element) => element.category_id == cat).toList()[i].icon) , width: 70, height: 70,)
      ],
    ),
  );
}

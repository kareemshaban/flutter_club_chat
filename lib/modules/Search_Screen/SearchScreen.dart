import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/ChatRoomService.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  List<AppUser> users = [] ;
  List<ChatRoom> rooms = [] ;
  var userTxt = TextEditingController()  ;
  var roomTxt = TextEditingController();
  bool isLoading = false ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return
      DefaultTabController(
        length: 2,
        child: Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.darkColor,
        title: TabBar(
          dividerColor: Colors.transparent,
          tabAlignment: TabAlignment.center,
          isScrollable: true ,
          indicatorColor: MyColors.primaryColor,
          labelColor: MyColors.primaryColor,
          unselectedLabelColor: MyColors.unSelectedColor,
          labelStyle: const TextStyle(fontSize: 17.0 , fontWeight: FontWeight.w900),

          tabs: const [
            Tab(text: "User" ),
            Tab(text: "Room",),
          ],
        ) ,
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        child: TabBarView(
            children:[
              Container(
                padding: const EdgeInsets.all(20.0),

                child:  Column(
                  children: [
                    Container(
                      height: 45.0 ,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0) , color: MyColors.lightUnSelectedColor,),
                      child: TextField( controller: userTxt, decoration: InputDecoration(labelText: "Search in Users by ID / Name" , suffixIcon: IconButton(icon: const Icon(Icons.search , color: Colors.white, size: 25.0,),
                        onPressed: (){searchUsers();},) , fillColor: MyColors.primaryColor, focusColor: MyColors.primaryColor, focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ,
                          borderSide: BorderSide(color: MyColors.whiteColor) ) ,  border: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ) , labelStyle: const TextStyle(color: Colors.white , fontSize: 13.0) ,  ),
                        style: const TextStyle(color: Colors.white , fontSize: 10.0), cursorColor: MyColors.primaryColor,),
                    ),
                    const SizedBox(height: 20.0,),
                    Expanded(child: ListView.separated(itemBuilder:(ctx , index) => usersListItem(index), separatorBuilder:(ctx , index) => listSeperator(), itemCount: users.length))
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child:  Column(
                  children: [
                    SizedBox(
                      height: 45.0 ,
                      child: TextField(controller: roomTxt, decoration: InputDecoration(labelText: "Search in Users by ID / Name" , suffixIcon: IconButton(icon: const Icon(Icons.search , color: Colors.white, size: 25.0,),
                        onPressed: (){searchRooms();},) , fillColor: MyColors.primaryColor, focusColor: MyColors.primaryColor, focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ,
                          borderSide: BorderSide(color: MyColors.whiteColor) ) ,  border: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ) , labelStyle: const TextStyle(color: Colors.white , fontSize: 13.0) ),
                        style: const TextStyle(color: Colors.white), cursorColor: MyColors.primaryColor,),
                    ),
                    const SizedBox(height: 20.0,),
                    Expanded(
                        child: ListView.separated(itemBuilder:(ctx , index) => roomListItem(index), separatorBuilder:(ctx , index) => listSeperator(), itemCount: rooms.length)
                    )
                  ],
                ),
              )
            ],
        )
      ),
    ),);
  }
  void searchUsers() async{
      setState(() {
        isLoading = true ;
      });
     List<AppUser> res = await AppUserServices().searchUser(userTxt.text);
     setState(() {
       users = res ;
       isLoading = false ;
     });
  }
  void searchRooms() async{
    setState(() {

      isLoading = true ;
    });
    List<ChatRoom> res = await ChatRoomService().searchRoom(roomTxt.text);
    setState(() {
      rooms = res ;
      isLoading = false ;

    });
  }

  Widget usersListItem(index) => Column(
    children: [
      Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           Column(
               children: [
                 CircleAvatar(
                   backgroundColor: users[index].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                   backgroundImage:NetworkImage('${ASSETSBASEURL}AppUsers/${users[index].img}'),
                   radius: 30,
                   child: users[index].img == "" ?
                   Text(users[index].name.toUpperCase().substring(0 , 1) +
                       (users[index].name.contains(" ") ? users[index].name.substring(users[index].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
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
                    Text(users[index].name , style: TextStyle(color: MyColors.whiteColor , fontSize: 18.0),),
                    const SizedBox(width: 5.0,),
                    CircleAvatar(
                      backgroundColor: users[index].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                      radius: 10.0,
                      child: users[index].gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                    )
                  ],
                ),
                Row(

                  children: [
                    Image(image: NetworkImage(ASSETSBASEURL + 'Levels/' + users[index].share_level_icon) , width: 40,),
                    const SizedBox(width: 10.0,),
                    Image(image: NetworkImage(ASSETSBASEURL + 'Levels/' + users[index].karizma_level_icon) , width: 40,),
                    const SizedBox(width: 10.0,),
                    Image(image: NetworkImage(ASSETSBASEURL + 'Levels/' + users[index].charging_level_icon) , width: 30,),

                  ],
                ),

                Text("ID:${users[index].tag}" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 13.0),),


              ],

            ),

      ]),
      Container(
        width: double.infinity,
        height: 1.0,
        color: MyColors.lightUnSelectedColor,
        child: const Text(""),
      )
    ],
  );

  Widget listSeperator() => const SizedBox(height: 10.0,);

  Widget roomListItem(index) => Column(
    children: [
      Row(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image(image: NetworkImage('${ASSETSBASEURL}Rooms/${rooms[index].img}') , width: 80.0 , height: 80.0,  fit: BoxFit.cover)
              )
            ],
          ),
          const SizedBox(width: 20.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(rooms[index].name , style: const TextStyle(color: Colors.white , fontSize: 16.0 , fontWeight: FontWeight.bold),),
              const SizedBox(height: 10.0,),
              Row(
                children: [
                  Image(image: NetworkImage('${ASSETSBASEURL}Countries/${rooms[index].flag}' ) , width: 30.0,),
                   const SizedBox(width: 10.0,),
                  Container(
                      decoration: BoxDecoration(color: getMyColor(rooms[index].subject) , borderRadius: BorderRadius.circular(20.0)),
                       padding: const EdgeInsets.symmetric(horizontal: 5.0 , vertical: 1.0),
                      child: Text('#${rooms[index].subject.toLowerCase()}' , style: const TextStyle(color: Colors.white),)
                  )
                ],
              ),
              const SizedBox(height: 10.0,),
              Text('ID:${rooms[index].tag}' , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 13.0),)
              
            ],
          ),
        ],
      ),
      Container(
        width: double.infinity,
        height: 1.0,
        color: MyColors.lightUnSelectedColor,
        child: const Text(""),
      )
    ],
  );

  Color getMyColor(String subject){
    if(subject == "CHAT"){
      return MyColors.primaryColor.withOpacity(.8) ;
    } else if(subject == "FRIENDS"){
      return MyColors.successColor.withOpacity(.8) ;
    }else if(subject == "GAMES"){
      return MyColors.blueColor.withOpacity(.8) ;
    }
    else {
      return MyColors.primaryColor.withOpacity(.8) ;
    }

  }
}

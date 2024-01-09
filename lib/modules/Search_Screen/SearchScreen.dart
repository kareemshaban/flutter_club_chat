import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
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
                child:  TextField(decoration: InputDecoration(labelText: "Search in Users by ID / Name" , suffixIcon: IconButton(icon: Icon(Icons.search , color: Colors.white, size: 30.0,),
                  onPressed: (){},) , fillColor: MyColors.primaryColor, focusColor: MyColors.primaryColor, focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) , borderSide: BorderSide(color: MyColors.primaryColor) ) ,  border: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ) , labelStyle: TextStyle(color: Colors.white , fontSize: 13.0) ),),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child:  TextField(decoration: InputDecoration(labelText: "Search in Rooms by ID / Name" , suffixIcon: IconButton(icon: Icon(Icons.search , color: Colors.white)  , onPressed: (){},) , border: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ,),),
              ),
              )
            ],
        )
      ),
    ),);
  }
}

import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddStatusScreen extends StatefulWidget {
  const AddStatusScreen({super.key});

  @override
  State<AddStatusScreen> createState() => _AddStatusScreenState();
}

class _AddStatusScreenState extends State<AddStatusScreen> {
  AppUser? user ;
  var statusController = TextEditingController()  ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     user = AppUserServices().userGetter();
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
        title: Text("My Status" , style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(icon: Icon(FontAwesomeIcons.circleQuestion , color: Colors.white,) , onPressed: (){},)
        ],
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10.0) ,
                child: CircleAvatar(
                  backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                  backgroundImage:(user!.img != "" ?  NetworkImage('${ASSETSBASEURL}AppUsers/${user?.img}') : null),
                  radius: 50,
                  child: user?.img== ""  ?
                  Text(user!.name.toUpperCase().substring(0 , 1) +
                      (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                    style: const TextStyle(color: Colors.white , fontSize: 28.0 , fontWeight: FontWeight.bold),) : null,
                ),
          
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.share_level_icon}') , width: 50,),
                    const SizedBox(width: 10.0,),
                    Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.karizma_level_icon}') , width: 50,),
                    const SizedBox(width: 10.0, height: 10,),
                    Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.charging_level_icon}') , width: 30,),
                    
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
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(color: Colors.black26.withAlpha(50) , borderRadius: BorderRadius.circular(20.0) ,),
                child: TextField(
                  controller: statusController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  cursorColor: MyColors.primaryColor,
                  decoration: InputDecoration(border: InputBorder.none , labelText: "#Share Your Bio With Friends!" , labelStyle: TextStyle(color: Colors.grey , fontSize: 18.0)),
                  style: TextStyle(color: MyColors.whiteColor),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric( horizontal: 10.0),
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(  color: MyColors.primaryColor, borderRadius: BorderRadius.circular(15.0)),
                child: MaterialButton(onPressed: (){ AddStatus();} , child: Text('Share' , style: TextStyle(color:MyColors.darkColor , fontSize: 18.0),),),
              )
            ],
          ),
        ),
      ),
    );
  }

  String calculateAge(DateTime birth) {
    DateTime now = DateTime.now();
    Duration age = now.difference(birth);
    int years = age.inDays ~/ 365;
    int months = (age.inDays % 365) ~/ 30;
    int days = ((age.inDays % 365) % 30);
    return years.toString() ;
  }

  AddStatus() async{
    AppUser? res = await AppUserServices().updateStatus(user!.id, statusController.text);
    AppUserServices().userSetter(res!);
    Fluttertoast.showToast(
        msg: "Status Updated Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
        fontSize: 16.0
    );
    Navigator.pop(context , true);
  }
}

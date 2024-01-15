import 'dart:io';
import 'dart:math';

import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/Country.dart';
import 'package:clubchat/models/Tag.dart';
import 'package:clubchat/models/UserHoppy.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/CountryService.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  AppUser? user ;
  List<Country> countries = [] ;
  List<Tag> tags = [] ;
  List<UserHoppy>? hoppies = [] ;
  String selectedCountry = "1" ;
  String selectedDate ="2000-01-01 00:00:00";
  var userNameController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
      countries = CountryService().countryGetter();
      selectedCountry = user!.country != 0 ?  user!.country.toString()  : countries[1].id.toString();
      hoppies = user!.hoppies ;
      selectedDate = user!.birth_date ;
      userNameController.text = user!.name ;
    });
    getHoppies();


  }
  getHoppies() async {
     List<Tag> res  = await AppUserServices().getAllHoppies();
     setState(() {
       this.tags = res ;
     });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.darkColor,
        title: Text("Edit Profile" , style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(icon: Icon(FontAwesomeIcons.circleQuestion , color: Colors.white,) , onPressed: (){},)
        ],
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: (
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10.0) ,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,

                  onTap: (){
                    showPickImageOptions();
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CircleAvatar(
                        backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                        backgroundImage: _image == null ?
                        (user!.img != "" ?  NetworkImage('${ASSETSBASEURL}AppUsers/${user?.img}') : null) :
                        Image.file(_image! , width: 100,).image  ,
                        radius: 50,
                        child: user?.img== "" && _image == null ?
                        Text(user!.name.toUpperCase().substring(0 , 1) +
                            (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                          style: const TextStyle(color: Colors.white , fontSize: 28.0 , fontWeight: FontWeight.bold),) : null,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: (){

                        },
                        child: Transform.translate(
                          offset: Offset(0, 10.0),
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.black54 ,
                            child: Icon(Icons.camera_alt_outlined ,color: Colors.white, size: 20,),
                          ),
                        ),
                      )
                    ],
                  ),
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
                        Text("Basic Information" , style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),)
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
                                  IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_outlined , color: Colors.white , size: 20.0,) ,)
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
                          Text("User Name" , style: TextStyle(fontSize: 16.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
                          Expanded(child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () async{
                                  await _displayTextInputDialog(context);
                                } ,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(user!.name , style: TextStyle(fontSize: 16.0 , color: Colors.white),),
                                    SizedBox(width: 5.0,),
                                    IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.pen , color: Colors.white , size: 20.0))
                                  ],
                                ),
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
                          Text("Gender" , style: TextStyle(fontSize: 16.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
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
                          Text("Date of Birth" , style: TextStyle(fontSize: 16.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
                          Expanded(child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap:(){
                                  _selectDate(context);
                                } ,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(formattedDate(selectedDate ).toString(), style: TextStyle(fontSize: 16.0 , color: Colors.white),),
                                    SizedBox(width: 5.0,),
                                    IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.calendar  , color: Colors.white , size: 20.0))
                                  ],
                                ),
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
                          Text("Country" , style: TextStyle(fontSize: 16.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
                          Expanded(child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton(items: getItems(), onChanged: (value) async {
                                      print(value);
                                      setState(() {
                                        selectedCountry = value ;
                                        updateUserCountry(value);

                                      });
                                    } , value: selectedCountry,
                                      dropdownColor: MyColors.darkColor, menuMaxHeight: 200.0, ),
                                  ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8.0,
                          height: 30.0,
                          decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(3.0)),
                        ),
                        SizedBox(width: 10.0,),
                        Text("My Tags" , style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),)
                      ],
                    ),
                    SizedBox(height: 15.0,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: hoppies!.map((e) => hoppyListItem(e)).toList(),
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            showModalBottomSheet(context: context, builder: (ctx) => TagsBottomSheet()  );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.0 , vertical: 8.0),
                            decoration: BoxDecoration(color: Colors.black45 , borderRadius: BorderRadius.circular(25.0)),
                            child: Text("Add +/ Remove -" , style: TextStyle(color: Colors.white , fontSize: 15.0),),
                          ),
                        )
                      ],
                    )


                  ],
                ),
              ),
            ],
          )
          ),
        ),
      ),
    );
  }
  String formattedDate(dateTime) {
    const DATE_FORMAT = 'dd/MM/yyyy';
    print('dateTime ($dateTime)');
    return DateFormat(DATE_FORMAT).format(DateTime.parse(dateTime) );
  }
  List<DropdownMenuItem> getItems(){
    return countries.where((element) => element.id > 0).map<DropdownMenuItem<String>>((Country country) {
      return DropdownMenuItem<String>(
        value: country.id.toString(),
        child: Container(

          child: Row(
            children: [
              SizedBox(width: 5.0,),
              Image(image: NetworkImage(ASSETSBASEURL + 'Countries/' + country.icon) , width: 20.0,) ,
              SizedBox(width: 5.0,),
              Text(country.name , style: TextStyle(color: Colors.white , fontSize: 15.0),)
            ],
          ),
        ),
      );
    }).toList();
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

  Widget tagListItem(tag) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () async{
      if(hoppies!.where((element) => element.id == tag.id).length == 0){
          user  = await AppUserServices().addHoppy(user!.id , tag.id , "ADD") ;
          setState(() {
            hoppies = user!.hoppies ;
            print(hoppies);
          });
      } else {
        user  = await AppUserServices().addHoppy(user!.id , tag.id , "DEL") ;
        setState(() {
          hoppies = user!.hoppies ;
        });

      }
      Fluttertoast.showToast(
          msg: "Tags Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
      Navigator.pop(context);
    },
    child: Container(
      height: 60.0,
      width: MediaQuery.of(context).size.width / 3 ,
      padding: const EdgeInsets.symmetric(horizontal: 15.0 , vertical: 8.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.transparent , width: 1.0 , style: BorderStyle.solid) , borderRadius: BorderRadius.circular(25.0) ,
          color: hoppies!.where((element) => element.id == tag.id).isEmpty ?
          MyColors.solidDarkColor.withAlpha(100) : MyColors.primaryColor.withAlpha(100) ),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('#${tag.name}' , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),)
        ],),
    ),
  );

  Widget TagsBottomSheet() =>  Container(
      color: MyColors.darkColor,
      padding: EdgeInsets.all( 10.0),
      child: GridView.count(
      crossAxisCount: 3,
      childAspectRatio: (MediaQuery.of(context).size.width / 180),
      padding: const EdgeInsets.all(4.0),
      mainAxisSpacing: 20.0,
      crossAxisSpacing: 10.0,
      children: tags.map((tag) => tagListItem(tag)).toList(),

      )
  );

  updateUserCountry(val) async {
    AppUser? res = await AppUserServices().updateCountry(user!.id, val) ;
    AppUserServices().userSetter(res!);
    setState(() {
      user = res ;
    });
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(selectedDate),
        firstDate: DateTime(1900, 8),
        lastDate: DateTime.now(),
        builder: ( context,  child){
            return Theme(
            data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.orange,
            accentColor: MyColors.blueColor,
            backgroundColor: MyColors.darkColor,
            cardColor: MyColors.darkColor,
            ),
            dialogBackgroundColor:MyColors.darkColor,
            ), child: child!,
            );
            },
    );


    if (picked != null && picked != selectedDate) {
        print(formattedDate(picked.toString()));
       setState(() {
         selectedDate =  (picked.toString());
         updateUserBirthDate(selectedDate);
       });
    }
  }
  updateUserBirthDate(date) async{
    AppUser? res = await AppUserServices().updateBirthdate(user!.id, date);
    AppUserServices().userSetter(res!);
    setState(() {
      user = res ;

    });

  }
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(

          child: AlertDialog(
            backgroundColor: MyColors.darkColor,
            title: Text('User Name' , style: TextStyle(color: Colors.white , fontSize: 20.0) , textAlign: TextAlign.center, ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Up to 20 Characters !" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 13.0), textAlign: TextAlign.start,),
                  ],
                ),
                Container(
                  height: 70.0,
                  child: TextField(
                    controller: userNameController,
                    style: TextStyle(color: Colors.white),
                    cursorColor: MyColors.primaryColor,
                    maxLength: 20,
                    decoration: InputDecoration(hintText: "Text Field in Dialog" ,
                        focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(10.0) ,
                            borderSide: BorderSide(color: MyColors.whiteColor) ) ,
                        border: OutlineInputBorder( borderRadius: BorderRadius.circular(10.0) ) ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Container(
                decoration: BoxDecoration(color: MyColors.solidDarkColor , borderRadius: BorderRadius.circular(15.0)),

                child: MaterialButton(
                  child: Text('CANCEL' , style: TextStyle(color: Colors.white),),
                  onPressed: () async{

                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(15.0)),
                child: MaterialButton(
                  child: Text('Edit' , style: TextStyle(color: MyColors.darkColor),),
                  onPressed: () async{
                    AppUser? res = await AppUserServices().updateName(user!.id, userNameController.text );
                    setState(() {
                      user = res ;
                      AppUserServices().userSetter(res!);
                      Navigator.pop(context);
                    });

                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImageFromGalleryOrCamera(ImageSource _source) async {
    final pickedFile = await ImagePicker().pickImage(source: _source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploadProfileImg();
      }
    });
  }

  uploadProfileImg() async{
    await AppUserServices().updateProfileImg(user!.id, _image);
    AppUser? res = await AppUserServices().getUser(user!.id);
    AppUserServices().userSetter(res!);
    setState(() {
      user = res ;
    });
    Fluttertoast.showToast(
        msg: 'Your photo has been updated! ',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
        fontSize: 16.0
    );

  }

  Future showPickImageOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGalleryOrCamera(ImageSource.gallery);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromGalleryOrCamera(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }

}

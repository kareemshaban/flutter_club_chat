import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../../shared/styles/colors.dart';
import 'music2_modal.dart';

class MusicsModal extends StatefulWidget {
  const MusicsModal({super.key});

  @override
  State<MusicsModal> createState() => _MusicsModalState();
}

class _MusicsModalState extends State<MusicsModal> {
  List<FileSystemEntity> musicFiles = [] ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }
  getData() async{
    Directory? appDocDir = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> allFiles;
    List<FileSystemEntity> files;



    allFiles = appDocDir.listSync(recursive: true, followLinks: false);
    files = [...allFiles.where((element) => FileManager.isFile(element))];
    List<FileSystemEntity> MF = [] ;
    MF = [...files.where((file) => file.path.toLowerCase().endsWith('.mp3') ||file.path.toLowerCase().endsWith('.m4a')  ) ] ;
    setState(() {
      musicFiles = MF ;
    });

  }
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
                  Text('musics_model_my_music'.tr,style: TextStyle(color: Colors.white,fontSize: 18.0),),
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
          ),
          Expanded(
          child: ListView.separated(
          itemCount: musicFiles.length,
          itemBuilder: (context, index) {
          return Container(
          color: Colors.black.withAlpha(180),
          height: 80.0,
          padding: EdgeInsetsDirectional.only(start: 10.0),
          child: Row(
          children: [
          Column(
          children: [
          Container(
          padding: EdgeInsetsDirectional.only(end: 10.0),
          height: 50.0,
          width: 80.0,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image(
          image: AssetImage('assets/images/mp3.png'),
          ),
          ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          ),
          Column(
          children: [
          Container(
          width: 200.0,
          child: Row(
          children: [
          Expanded(
          child: Text(
          FileManager.basename(musicFiles[index]) ,
          style: TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis,
          ),
          ),
          ],
          ),
          ),
          Row(
          children: [
          Icon(CupertinoIcons.clock , size: 15.0, color: Colors.white,),
          Padding(
          padding: const EdgeInsetsDirectional.only(start:5.0 , end: 5.0),
          child: Text('01:20',style: TextStyle(fontSize: 12.0 , color: Colors.white),),
          ),
          Container(
          color: Colors.white,
          width: 1,
          height: 20.0,
          ),
          Padding(
          padding: EdgeInsetsDirectional.only(start: 5.0 , end: 5.0),
          child: Icon(Icons.save_outlined ,size: 15.0, color: Colors.white,),
          ),
          Text('2024-01-18 20',style:TextStyle(fontSize: 12.0 , color: Colors.white),)
          ],
          )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          ),
          Expanded(
          child:Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

          ],
          ) ,
          )
          ],
          ),
          );
          },
          separatorBuilder: (context,index)=> Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey[300],
          ),
          ),
          )
        ],
      ),
    );
  }
}

Widget Music2BottomSheet( ) => MusicsModal2();

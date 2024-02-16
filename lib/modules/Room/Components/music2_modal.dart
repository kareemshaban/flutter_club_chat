import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../shared/styles/colors.dart';
import 'musics_modal.dart';
import 'package:path/path.dart' as path;

class MusicsModal2 extends StatefulWidget {
  const MusicsModal2({super.key});


  @override
  State<MusicsModal2> createState() => _MusicsModalState2();
}

class _MusicsModalState2 extends State<MusicsModal2> {
  bool isCheked = false ;
  final FileManagerController controller = FileManagerController();
  List<File> _mp3Files = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initlist();
    requestPermissions();
  }
  void initlist() async {

      Directory? dir = await getExternalStorageDirectory();
      List<FileSystemEntity> files;
      files = dir!.listSync(recursive: true, followLinks: false);
      print('files');
      print(files);
    }


  requestPermissions() async{
    // Request permission to access the device's storage
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission granted, you can now proceed with file access
    } else {
      // Permission denied
      // Handle the situation where the user denied permission
    }

  }

  bool _isMusicFile(String path) {
    final musicExtensions = ['mp3','mp4', 'Irc', 'm4a', '.ogg' ,'MP3','MP4' ]; // Add more extensions as needed
    return musicExtensions.any((ext) => path.endsWith(ext));
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
              IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                    showModalBottomSheet(
                        context: context,
                        builder: (ctx) => MusicBottomSheet());
                  },
                  icon: Icon(Icons.arrow_circle_left_outlined , color:  Colors.white,size: 25.0,)
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('musics2_model_add_music'.tr,style: TextStyle(color: Colors.white,fontSize: 18.0),),
                  ],
                ),
              ),
            ],
          ),
          // FileManager(
          //   controller: controller,
          //   builder: (context, snapshot) {
          //     final List<FileSystemEntity> entities = snapshot;
          //
          //     // Filter for music files using a regular expression
          //     final musicFiles = entities.where((entity) =>
          //     FileManager.isFile(entity) &&
          //         _isMusicFile(entity.path)
          //     ).toList();
          //     print('musicFiles') ;
          //     print(musicFiles) ;
          //     return Expanded(
          //       child: ListView.builder(
          //         itemCount: musicFiles.length,
          //         itemBuilder: (context, index) {
          //           return Card(
          //             child: ListTile(
          //               leading: Icon(Icons.music_note), // Use a music file icon
          //               title: Text(FileManager.basename(musicFiles[index])),
          //               onTap: () {
          //                 if (FileManager.isDirectory(musicFiles[index])) {
          //                   controller.openDirectory(musicFiles[index]);
          //                 } else {
          //                   // Handle music file tap (e.g., play the file)
          //                 }
          //               },
          //             ),
          //           );
          //         },
          //       ),
          //     );
          //   },
          // )
          // FileManager(
          //   controller: controller,
          //   builder: (context, snapshot) {
          //     final List<FileSystemEntity> entities = snapshot;
          //     print('entities') ;
          //     print(entities) ;
          //     return Expanded(
          //       child: ListView.builder(
          //         itemCount: entities.length,
          //         itemBuilder: (context, index) {
          //           return Card(
          //             child: ListTile(
          //               leading: FileManager.isFile(entities[index])
          //                   ? Icon(Icons.feed_outlined)
          //                   : Icon(Icons.folder),
          //               title: Text(FileManager.basename(entities[index])),
          //               onTap: () {
          //                 if (FileManager.isDirectory(entities[index])) {
          //                   controller.openDirectory(entities[index]);
          //                   print(entities[index]);// open directory
          //                 } else {
          //                   CircularProgressIndicator(color: MyColors.primaryColor,);
          //                 }
          //               },
          //             ),
          //           );
          //         },
          //       ),
          //     );
          //   },
          // )
          FileManager(
            loadingScreen: Center(child: CircularProgressIndicator(color: MyColors.primaryColor,)),
            controller: controller,
            builder: (context, snapshot) {
              final List<FileSystemEntity> entities = snapshot ?? [];
              List<FileSystemEntity> dirs = [] ;
               List<FileSystemEntity> allFiles = [] ; //entities.where((element) =>FileManager.isDirectory(element) ).toList();
              List<FileSystemEntity> musicFiles = [] ;
               dirs = entities.where((element) => FileManager.isDirectory(element) ).toList() ;
              allFiles = entities.where((element) => FileManager.isFile(element) ).toList() ;
              dirs.forEach((element) {

                Directory dr = element as Directory ;
                if(!dr.path.contains('Android')){
                  List<FileSystemEntity> files = dr.listSync(followLinks: true ,recursive: true);
                  allFiles = [...allFiles , ...files.where((element) => FileManager.isFile(element))];
                }

              });
                musicFiles = [...allFiles.where((file) => file.path.toLowerCase().endsWith('.mp3') ||file.path.toLowerCase().endsWith('.m4a')  ) ] ;
              print('musicFiles') ;
              print(musicFiles) ;
              print('dirs') ;
              print(dirs) ;
              return Expanded(
                child: ListView.separated(
                  itemCount: musicFiles.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          isCheked = true ;
                        });
                      },
                      child: Container(
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
                                      image: AssetImage('assets/images/flag.png'),
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
                                    Text('Artist NAme' , style: TextStyle(color: Colors.white),),
                                  ],
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
                                  Checkbox(
                                    activeColor: MyColors.primaryColor,
                                      value: isCheked ,
                                      onChanged: (d){}
                                  )
                                ],
                              ) ,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context,index)=> Container(
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                ),
              );
            },
          )


        ],
      ),
    );
  }
}

Widget MusicBottomSheet() => MusicsModal();

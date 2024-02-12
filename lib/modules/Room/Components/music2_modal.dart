import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../shared/styles/colors.dart';
import 'musics_modal.dart';

class MusicsModal2 extends StatefulWidget {
  const MusicsModal2({super.key});


  @override
  State<MusicsModal2> createState() => _MusicsModalState2();
}

class _MusicsModalState2 extends State<MusicsModal2> {
  final FileManagerController controller = FileManagerController();
  List<File> _mp3Files = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initlist();

  }
  void initlist() async {

      Directory? dir = await getExternalStorageDirectory();
      List<FileSystemEntity> files;
      files = dir!.listSync(recursive: true, followLinks: false);
      print('files');
      print(files);
    }


  getSongs() async{

  }

  void _loadMP3Files() async {
    try {
      // Get the directory for the device's external storage
     List<Directory>? directories =  await getExternalStorageDirectories();
     List<FileSystemEntity> files = [];
     print('directories');
     print(directories!.length);
     for(var i =0 ; i <directories.length ; i++ ){
       Directory directory = directories[i];
       List<FileSystemEntity> f  = directory.listSync(recursive: true) ;
       files = [...files , ...f];
     }
     print('files');
     print(files);
      // Get all files in the directory


      // Filter MP3 files
      List<File> mp3Files = files
          .where((file) => file.path.toLowerCase().endsWith('.mp3'))
          .map((file) => File(file.path))
          .toList();


      setState(() {
        _mp3Files = mp3Files;
      });
    } catch (e) {
      print('Error loading MP3 files: $e');
    }
  }

  requestPermissions() async{
    var status = await Permission.audio;
    if(await status.isGranted){
      _loadMP3Files();
    }else{
      await Permission.manageExternalStorage.request();
      _loadMP3Files() ;
    }
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
                    Text('Add Music',style: TextStyle(color: Colors.white,fontSize: 20.0),),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _mp3Files.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_mp3Files[index].path.split('/').last),
                  onTap: () {
                    // Handle tapping on a file if needed
                  },
                );
              },
            ),
          ),
          // FileManager(
          //   controller: controller,
          //   builder: (context, snapshot) {
          //     final List<FileSystemEntity> entities = snapshot;
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
        ],
      ),
    );
  }
}

Widget MusicBottomSheet() => MusicsModal();

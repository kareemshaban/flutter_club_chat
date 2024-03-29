import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubchat/helpers/ChatRoomMessagesHelper.dart';
import 'package:clubchat/helpers/DesigGiftHelper.dart';
import 'package:clubchat/helpers/EnterRoomHelper.dart';
import 'package:clubchat/helpers/ExitRoomHelper.dart';
import 'package:clubchat/helpers/MicHelper.dart';
import 'package:clubchat/helpers/RoomBasicDataHelper.dart';
import 'package:clubchat/layout/tabs_screen.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/Category.dart' as Cat;
import 'package:clubchat/models/Chat.dart';
import 'package:clubchat/models/ChatRoom.dart';
import 'package:clubchat/models/ChatRoomMessage.dart';
import 'package:clubchat/models/Design.dart';
import 'package:clubchat/models/Emossion.dart';
import 'package:clubchat/models/Gift.dart';
import 'package:clubchat/models/RoomMember.dart';
import 'package:clubchat/models/RoomTheme.dart';
import 'package:clubchat/models/message.dart';
import 'package:clubchat/modules/Home/Home_Screen.dart';
import 'package:clubchat/modules/Loading/loadig_screen.dart';
import 'package:clubchat/modules/Room/Components/emoj_modal.dart';
import 'package:clubchat/modules/Room/Components/gift_modal.dart';
import 'package:clubchat/modules/Room/Components/menu_modal.dart';
import 'package:clubchat/modules/Room/Components/room_close_modal.dart';
import 'package:clubchat/modules/Room/Components/room_cup_modal.dart';
import 'package:clubchat/modules/Room/Components/room_info_modal.dart';
import 'package:clubchat/modules/Room/Components/room_members_modal.dart';
import 'package:clubchat/modules/SmallProfile/Small_Profile_Screen.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/ChatRoomService.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:popover/popover.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

const appId = "d3a7fdb87c8d4bbd8b0e33a95a1d4e2a";

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> with TickerProviderStateMixin{
  AppUser? user;
  List<Design> designs = [];
  String frame = "";
  ChatRoom? room;
  String room_img = "";
  List<Emossion> emossions = [];
  List<RoomTheme> themes = [];
  List<Gift> gifts = [];
  List<Cat.Category> categories = [];
  TabController? _tabController ;
  List<Widget> giftTabs = [] ;
  List<Widget> giftViews = [] ;
  String sendGiftReceiverType = "";
  int? selectedGift  ;
  String userRole = 'USER';
  List<ChatRoomMessage> messages = [] ;
  late RtcEngine _engine;
  bool showMsgInput = false ;
  final TextEditingController _messageController = TextEditingController();
  FocusNode focusNode = FocusNode();
  String token = "";
  String channel = "";
  bool emojiShowing = false;
  String entery = "";
  String giftImg = "";
  List<String> micEmojs = ["" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""  ];
  bool _localUserJoined = false;
  bool _localUserMute = true ;
  int bannerState = 0 ;
  bool showBanner = false ;
  String bannerMsg = "" ;
  String giftImgSmall = "" ;
  ScrollController _scrollController = new ScrollController();
  List<int> speakers = [] ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    setState(() {
      sendGiftReceiverType = "select_one_ore_more";
      user = AppUserServices().userGetter();
      room = ChatRoomService().roomGetter();
      setState(() {
        channel = room!.tag ;
      });
      if(user!.id == room!.userId){
        setState(() {
          userRole = 'OWNER';
        });
      } else if(room!.admins!.where((element) => element.user_id == user!.id).length > 0){
        setState(() {
          userRole = 'OWNER';
        });
      } else {
        setState(() {
          userRole = 'USER';
        });
      }

    });
    getRoomImage();

    EnterRoomHelper(user!.id , room!.id);
    enterRoomListener();
    exitRoomListener();
    micListener();
    micUsageListener();
    themesListener();
    geAdminDesigns();
    micEmossionListener();
    giftListener();
    micCounterListener();
    micRemoveListener();
    if(ChatRoomService.savedRoom == null){
      initAgora();

    } else {
      ChatRoomService().savedRoomSetter(null);
      setState(() {
        _localUserJoined = true;
        _engine = ChatRoomService.engine! ;
      });
    }

    messagesListener();
    getRoomBasicData();
    focusNode.addListener(() {
      print('1:  ${focusNode.hasFocus}');
      if(!focusNode.hasFocus){
        FocusScope.of(context).unfocus();

        setState(() {
          emojiShowing = false ;
        });
        toggleMessageInput();
      }
    });

  }
  getRoomImage(){
    String img = '';
    if(room!.img == room!.admin_img){
      if(room!.admin_img != ""){
        img = '${ASSETSBASEURL}AppUsers/${room?.img}' ;
      } else {
        img = '${ASSETSBASEURL}Defaults/room_default.png' ;
      }

    } else {
      if(room?.img != ""){
        img = '${ASSETSBASEURL}Rooms/${room?.img}' ;
      } else {
        img = '${ASSETSBASEURL}Defaults/room_default.png' ;
      }

    }
    setState(() {
      room_img =  img ;
    });
    print('room_img');
    print(room_img);
  }

  enterRoomListener(){
    CollectionReference reference = FirebaseFirestore.instance.collection('enterRoom');
    reference.snapshots().listen((querySnapshot) {
      DocumentChange change =   querySnapshot.docChanges[0] ;
      if(change.newIndex > 0){
        Map<String , dynamic>? data = change.doc.data() as Map<String,dynamic>;
        int room_id = data['room_id'] ;
        if(room_id == room!.id){
          refreshRoom(0);
        }
      }
    });
  }
  exitRoomListener(){
    CollectionReference reference = FirebaseFirestore.instance.collection('exitRoom');
    reference.snapshots().listen((querySnapshot) {
      DocumentChange change =   querySnapshot.docChanges[0] ;
      if(change.newIndex > 0){
        Map<String , dynamic>? data = change.doc.data() as Map<String,dynamic>;
        int room_id = data['room_id'] ;
        if(room_id == room!.id){
          refreshRoom(0);
        }
      }
    });
  }
  micListener(){
    CollectionReference reference = FirebaseFirestore.instance.collection('mic-state');
    reference.snapshots().listen((querySnapshot) {
      DocumentChange change =   querySnapshot.docChanges[0] ;
      if(change.newIndex > 0){
        Map<String , dynamic>? data = change.doc.data() as Map<String,dynamic>;
        int room_id = data['room_id'] ;
        if(room_id == room!.id){
          refreshRoom(0);
        }
      }
    });
  }
  micCounterListener(){
    CollectionReference reference = FirebaseFirestore.instance.collection('mic-counter');
    reference.snapshots().listen((querySnapshot) {
      DocumentChange change =   querySnapshot.docChanges[0] ;
      if(change.newIndex > 0){
        Map<String , dynamic>? data = change.doc.data() as Map<String,dynamic>;
        int room_id = data['room_id'] ;
        if(room_id == room!.id){
          refreshRoom(0);
        }
      }
    });
  }


  micUsageListener(){
    CollectionReference reference = FirebaseFirestore.instance.collection('mic-usage');
    reference.snapshots().listen((querySnapshot) {
      DocumentChange change =   querySnapshot.docChanges[0] ;
      if(change.newIndex > 0){
        Map<String , dynamic>? data = change.doc.data() as Map<String,dynamic>;
        int room_id = data['room_id'] ;
        if(room_id == room!.id){
          refreshRoom(0);
        }
      }
    });
  }
  micRemoveListener() {
    CollectionReference reference = FirebaseFirestore.instance.collection('mic-remove');
    reference.snapshots().listen((querySnapshot) async{
      DocumentChange change =   querySnapshot.docChanges[0] ;
      if(change.newIndex > 0){
        Map<String , dynamic>? data = change.doc.data() as Map<String,dynamic>;
        int room_id = data['room_id'] ;
        int user_id = data['user_id'] ;
        print('micRemoveListener');
        print(room_id);
        if(room_id == room!.id){
          print('refreshRoom');
          refreshRoom(0);
        }
        if(user_id == user!.id){
          // if this is the user
          // show toast and stop publish
          try{
            await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
            setState(() {
              _localUserMute = true ;
            });
          }catch(err){

          }
          Fluttertoast.showToast(
              msg: 'room_remove_mic'.tr,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black26,
              textColor: Colors.orange,
              fontSize: 16.0);

        }
      }
    });
  }
  themesListener(){
    CollectionReference reference = FirebaseFirestore.instance.collection('themes');
    reference.snapshots().listen((querySnapshot) {
      DocumentChange change =   querySnapshot.docChanges[0] ;
      if(change.newIndex > 0){
        Map<String , dynamic>? data = change.doc.data() as Map<String,dynamic>;
        int room_id = data['room_id'] ;
        if(room_id == room!.id){
          refreshRoom(0);
        }
      }
    });
  }
  micEmossionListener() async {
    CollectionReference reference = FirebaseFirestore.instance.collection('emossions');
    reference.snapshots().listen((querySnapshot) async{

      DocumentChange change =   querySnapshot.docChanges[0] ;
      if(change.newIndex > 0){
        Map<String , dynamic>? data = change.doc.data() as Map<String,dynamic>;
        int room_id = data['room_id'] ;
        int mic = data['mic'] ;
        int user = data['user'] ;
        String emoj = data['emoj'] ;
        if(room_id == room!.id){
          setState(() {
            micEmojs[mic -1] = emoj ;
          });

          await Future.delayed(Duration(seconds: 5));
          setState(() {
            micEmojs[mic -1] = "" ;
          });

        }

      }


      // });
    });
  }
  messagesListener() async{

    CollectionReference reference = FirebaseFirestore.instance.collection('RoomMessages');
    reference.snapshots().listen((querySnapshot) async{
      DocumentChange change =   querySnapshot.docChanges[0] ;

      if(change.newIndex > 0){
        Map<String , dynamic>? data = change.doc.data() as Map<String,dynamic>;
        int room_id = data['room_id'] ;
        int user_id = data['user_id'] ;
        String msg = data['message'] ;
        String type = data['type'] ;
        print('messagesListener type');
        print(type);
        ChatRoom? res = await ChatRoomService().openRoomById(room!.id);
        setState(() {
          room = res ;
          ChatRoomService().roomSetter(room!);
        });
        RoomMember sender = room!.members!.where((element) =>  element.user_id == user_id).toList()[0] ;
        if(room_id == room!.id){
          ChatRoomMessage message = ChatRoomMessage(message: msg.tr, user_name: sender.mic_user_name.toString(),
              user_share_level_img: sender.mic_user_share_level.toString(), user_img: sender.mic_user_img.toString(), user_id: sender.user_id , type:type );
          List<ChatRoomMessage>  old = [...messages];
          old.add(message);
          setState(() {
            messages = old ;
          });
          // _scrollController.animateTo(
          //   0.0,
          //   curve: Curves.easeOut,
          //   duration: const Duration(milliseconds: 300),
          // );
          await Future.delayed(Duration(seconds: 2));
          print('_scrollController');
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 1),
              curve: Curves.fastOutSlowIn);


        }

      }

    });
  }
  giftListener() async{
    //gifts
    CollectionReference reference = FirebaseFirestore.instance.collection('gifts');
    reference.snapshots().listen((querySnapshot) async{
      DocumentChange change =   querySnapshot.docChanges[0] ;

      if(change.newIndex > 0){
        Map<String , dynamic>? data = change.doc.data() as Map<String,dynamic>;
        int room_id = data['room_id'] ;
        int sender_id = data['sender_id'] ;
        String sender_name = data['sender_name'] ;
        String sender_img = data['sender_img'] ;
        int receiver_id = data['receiver_id'] ;
        String receiver_name = data['receiver_name'] ;
        String receiver_img = data['receiver_img'] ;
        String gift_name = data['gift_name'] ;
        String gift_img = data['gift_img'] ;
        int count = data['count'] ;
        String gift_audio = data['gift_audio'];
        String sender_share_level = data['sender_share_level'] ;
        if(room_id == room!.id){
          refreshRoom(0);
        }
        if(gift_img.toLowerCase().endsWith('.svga')){
          svgaImagesListener(room_id , gift_img , gift_name , receiver_name , sender_name , sender_share_level , sender_img , sender_id ,gift_audio);
        }



      }

    });
  }
  svgaImagesListener(room_id , gift_img , gift_name , receiver_name , sender_name , sender_share_level , sender_img , sender_id , gift_audio) async{
    if(room_id == room!.id){
      //show gift
      setState(() {
        giftImg = gift_img ;
      });
      final player = AudioPlayer();
      if(gift_audio != ""){
        final player = AudioPlayer();
        final duration = await player.setUrl(gift_audio);
        player.play();
      }

      await Future.delayed(Duration(seconds: 10)).then((value) => {
        setState(() {
          giftImg = ''  ;
        })
      });
      await player.stop();
      // show on tetx
      ChatRoomMessage message = ChatRoomMessage(message:  'sent a ${gift_name} to ${receiver_name}' , user_name: sender_name.toString(),
          user_share_level_img: sender_share_level.toString(), user_img: sender_img.toString(), user_id: sender_id , type:'GIFT' );
      List<ChatRoomMessage>  old = [...messages];
      old.add(message);
      setState(() {
        messages = old ;
      });
    }
    //show banner in all rooms
    setState(() {
      showBanner = true ;
      giftImgSmall = gift_img ;
      bannerMsg = '${sender_name} sent a ${gift_name} to ${receiver_name}';
    });
    await Future.delayed(Duration(seconds: 10)).then((value) => {
      setState(() {
        showBanner = false ;
        bannerState = 0 ;
        bannerMsg = "";
        giftImgSmall = "" ;

      })
    } );
  }
  mp4GiftsListener(room_id , gift_img , gift_name , receiver_name , sender_name , sender_share_level , sender_img , sender_id) async{
    if(room_id == room!.id){
      //show gift



      // show on tetx
      ChatRoomMessage message = ChatRoomMessage(message:  'sent a ${gift_name} to ${receiver_name}' , user_name: sender_name.toString(),
          user_share_level_img: sender_share_level.toString(), user_img: sender_img.toString(), user_id: sender_id , type:'GIFT' );
      List<ChatRoomMessage>  old = [...messages];
      old.add(message);
      setState(() {
        messages = old ;
      });
    }
    //show banner in all rooms
    setState(() {
      showBanner = true ;
      giftImgSmall = gift_img ;
      bannerMsg = '${sender_name} sent a ${gift_name} to ${receiver_name}';
    });
    await Future.delayed(Duration(seconds: 10)).then((value) => {
      setState(() {
        showBanner = false ;
        bannerState = 0 ;
        bannerMsg = "";
        giftImgSmall = "" ;

      })
    } );
  }
  smallGiftsListener(room_id , gift_img , gift_name , receiver_name , sender_name , sender_share_level , sender_img , sender_id) async{
    if(room_id == room!.id){
      //show gift
      setState(() {
        giftImg = gift_img ;
      });
      await Future.delayed(Duration(seconds: 5)).then((value) => {
        setState(() {
          giftImg = ''  ;
        })
      });
      // show on tetx
      ChatRoomMessage message = ChatRoomMessage(message:  'sent a ${gift_name} to ${receiver_name}' , user_name: sender_name.toString(),
          user_share_level_img: sender_share_level.toString(), user_img: sender_img.toString(), user_id: sender_id , type:'GIFT' );
      List<ChatRoomMessage>  old = [...messages];
      old.add(message);
      setState(() {
        messages = old ;
      });
    }
    //show banner in all rooms

  }
  refreshRoom(joiner_id) async{
    ChatRoom? res = await ChatRoomService().openRoomById(room!.id);

    setState(() {
      room = res ;
      ChatRoomService().roomSetter(room!);

    });
    getRoomImage();
  }
  userJoinRoomWelcome(joiner_id) async{
    RoomMember joiner = room!.members!.where((element) =>  element.mic_user_tag == joiner_id.toString()).toList()[0] ;
    if(joiner.entery !=""){
      setState(() {
        entery = ASSETSBASEURL + 'Designs/Motion/' + joiner.entery! + '?raw=true'  ;
      });

      await Future.delayed(Duration(seconds: 9)).then((value) => {
        setState(() {
          entery = ''  ;
        })
      });
    }
    debugPrint("joiner ${joiner} ");
    ChatRoomMessage message = ChatRoomMessage(message: 'room_msg'.tr, user_name: 'APP', user_share_level_img: '', user_img: '', user_id: 0 , type: "TEXT");
    List<ChatRoomMessage>  old = [...messages];
    old.add(message);
    if(room!.hello_message != ""){
      message = ChatRoomMessage(message: room!.hello_message , user_name: 'ROOM', user_share_level_img: '', user_img: '', user_id: 0 ,type: "TEXT");
      old.add(message);
    }
    setState(() {
      messages = old ;
    });

    await ChatRoomMessagesHelper(room_id: room!.id , user_id: user!.id , message: 'user_enter_message' , type: 'TEXT').handleSendRoomMessage();




  }

  geAdminDesigns() async {
    DesignGiftHelper _helper =
    await AppUserServices().getMyDesigns(room!.userId);
    setState(() {
      designs = _helper.designs!;
    });
    if (designs
        .where((element) =>
    (element.category_id == 4 && element.isDefault == 1))
        .toList()
        .length >
        0) {
      String icon = designs
          .where(
              (element) => (element.category_id == 4 && element.isDefault == 1))
          .toList()[0]
          .motion_icon;

      setState(() {
        frame = ASSETSBASEURL + 'Designs/Motion/' + icon + '?raw=true';
        print(frame);
      });
    }
  }

  getRoomBasicData() async {
    RoomBasicDataHelper? helper = await ChatRoomService().getRoomBasicData();
    ChatRoomService().roomBasicDataHelperSetter(helper!);
    setState(() {
      emossions = helper!.emossions;
      themes = helper.themes;
      gifts = helper.gifts;
      categories = helper.categories;
      _tabController = new TabController(vsync: this, length: categories.length);
    });
  }

  Future<void> initAgora() async {
    print('initAgora');
    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    await _engine.enableAudioVolumeIndication(interval: 1000, smooth: 5, reportVad: false);



    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed)  async{
          debugPrint("local user ${connection.localUid} joined");
          await refreshRoom(connection.localUid);
          userJoinRoomWelcome(connection.localUid);
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            //   _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) async {
          debugPrint("remote user $remoteUid left channel");
          try{
            await ExitRoomHelper(remoteUid , room!.id);
            refreshRoom(0);

          }catch(err){

          }

          setState(() {
            // _remoteUid = null;

          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },

        onAudioVolumeIndication:(connection, _speakers, speakerNumber, totalVolume){
          print('onAudioVolumeIndication' );
          List<int> sp = [] ;
          setState(() {
            speakers = sp ;
          });
          _speakers.forEach((element) { sp.add(element.uid!);});
          setState(() {
            speakers = sp ;
          });
          print(speakers);
        },
        onAudioMixingFinished: (){
          print('onAudioMixingFinished' );
        },
        onAudioMixingStateChanged: ( AudioMixingStateType state,
            AudioMixingReasonType reason){
          print( 'audioMixingStateChanged state:${state.toString()}, reason: ${reason.toString()}}');
        },
        onAudioMixingPositionChanged: (pos){
          // print('onAudioMixingPositionChanged' );

        },


      ),
    );


    // await _engine.enableVideo();
    // await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: int.parse(user!.tag) ,

      options: const ChannelMediaOptions( clientRoleType: ClientRoleType.clientRoleAudience),
    );

    ChatRoomService.engine = _engine ;
  }
  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    if(ChatRoomService.savedRoom == null){
      await _engine.leaveChannel();
      await _engine.release();
    }

  }

  toggleMessageInput(){
    setState(() {
      showMsgInput = !showMsgInput ;
    });


  }

  sendMessage() async{
    if(_messageController.text.isNotEmpty){
      await ChatRoomMessagesHelper(room_id: room!.id , user_id: user!.id , message: _messageController.text , type: 'TEXT').handleSendRoomMessage();
      _messageController.clear();
      toggleMessageInput();
      if(!showMsgInput){
        setState(() {
          emojiShowing = false ;
        });

      }
      await Future.delayed(Duration(seconds: 2));
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1),
          curve: Curves.fastOutSlowIn);
    }

  }

  Future<void> _refresh()async{
    await refreshRoom(0) ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTextStyle(
        style: TextStyle(decoration: TextDecoration.none),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(ASSETSBASEURL + 'Themes/' + room!.room_bg!),
                  fit: BoxFit.cover)),
          padding: EdgeInsetsDirectional.only(top: 5.0, end: 10.0),
          child: SafeArea(
            child: Stack(
              alignment: Alignment.topCenter,

              children: [
                showBanner ? Stack(
                  alignment: Alignment.center,
                  children: [
                    SVGASimpleImage(   resUrl: ASSETSBASEURL + 'AppBanners/gift_red_banner.svga?raw=true'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(bannerMsg , style: TextStyle(fontSize: 11.0),),
                        SizedBox(width: 10.0,),
                        SizedBox(height: 40.0, width: 40.0,  child: SVGASimpleImage(resUrl: giftImgSmall)),

                      ],
                    )
                  ],
                ) : Container(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            Expanded(
                              flex: 55,
                              child: RefreshIndicator(
                                onRefresh: _refresh,
                                color: MyColors.primaryColor,
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (ctx) => RoomInfoBottomSheet());
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0, vertical: 5.0),
                                              decoration: BoxDecoration(
                                                color: Colors.black26,
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      child: SizedBox(),
                                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                          BorderRadius.circular(10.0),
                                                          image: room_img == ""
                                                              ? DecorationImage(
                                                              image: AssetImage(
                                                                  'assets/images/user.png'),
                                                              fit: BoxFit.cover)
                                                              : DecorationImage(
                                                              image: NetworkImage(room_img),
                                                              fit: BoxFit.cover))),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        room!.name,
                                                        style: TextStyle(
                                                            color: Colors.white, fontSize: 16.0),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Text(
                                                        'ID:' + room!.tag,
                                                        style: TextStyle(
                                                            color: MyColors.unSelectedColor,
                                                            fontSize: 11.0),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap:(){
                                                    showModalBottomSheet(
                                                        isScrollControlled: true ,
                                                        context: context,
                                                        builder: (ctx) => RoomCup());
                                                  },

                                                  child: Container(
                                                    padding: EdgeInsets.all(5.0),
                                                    decoration: BoxDecoration(
                                                        color: Colors.black26,
                                                        borderRadius:
                                                        BorderRadius.circular(10.0)),
                                                    child: Row(
                                                      children: [
                                                        Image(
                                                          image: AssetImage(
                                                              'assets/images/chatroom_rank_ic.png'),
                                                          height: 18.0,
                                                          width: 18.0,
                                                        ),
                                                        SizedBox(
                                                          width: 5.0,
                                                        ),
                                                        Text(
                                                          double.parse(room!.roomCup.toString()).floor().toString()  ,
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 13.0),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 7.0,
                                                ),
                                                GestureDetector(
                                                    child: Container(
                                                        margin: EdgeInsets.symmetric(
                                                            horizontal: 10.0),
                                                        child: Icon(
                                                          FontAwesomeIcons.shareFromSquare,
                                                          color: Colors.white,
                                                          size: 20.0,
                                                        ))),
                                                GestureDetector(
                                                    onTap: (){
                                                      showModalBottomSheet(
                                                          isScrollControlled: true ,
                                                          context: context,
                                                          builder: (ctx) => roomCloseModal());
                                                    },
                                                    child: Container(
                                                      margin:
                                                      EdgeInsets.symmetric(horizontal: 10.0),
                                                      child: Icon(
                                                        FontAwesomeIcons.powerOff,
                                                        color: Colors.white,
                                                        size: 20.0,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: room!.members!.map((e) => roomMemberItmeBuilder(e)).toList(),
                                          ),


                                          GestureDetector(
                                            onTap: (){
                                              showModalBottomSheet(
                                                  isScrollControlled: true ,
                                                  context: context,
                                                  builder: (ctx) => roomMembersModal());
                                            },
                                            child: Container(
                                              width: 60.0,
                                              padding: EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.black26,
                                                  borderRadius: BorderRadius.circular(10.0)),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.people_alt,
                                                    color: MyColors.primaryColor,
                                                    size: 20.0,
                                                  ),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                    room!.members!.length.toString(),
                                                    style: TextStyle(
                                                        color: MyColors.primaryColor,
                                                        fontSize: 13.0),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      GridView.count(
                                        shrinkWrap: true,
                                        crossAxisCount: 4,
                                        children:
                                        room!.mics!.map((mic) => micListItem(mic)).toList(),
                                        mainAxisSpacing: 0.0,
                                      ),


                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 45,
                              child: Row(
                                children: [
                                  Container(
                                      padding: EdgeInsetsDirectional.only(start: 10.0),
                                      width: MediaQuery.sizeOf(context).width * .7 ,


                                      child: ListView.separated(   itemBuilder:(context, index) => roomMessageBuilder(index), separatorBuilder: (context, index) => roomMessageSeperator(), itemCount: messages.length ,  controller: _scrollController,) ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 10.0),
                              child: !showMsgInput ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              toggleMessageInput();
                                            },
                                            child: Image(
                                              image: AssetImage('assets/images/messages.png'),
                                              width: 40.0,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Image(
                                            image: AssetImage('assets/images/chats.png'),
                                            width: 40.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              showModalBottomSheet(

                                                  context: context,
                                                  builder: (ctx) => MenuBottomSheet());
                                            },
                                            child: Image(
                                              image: AssetImage('assets/images/menu.png'),
                                              width: 40.0,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          GestureDetector(
                                            onTap: () async{
                                              if(room!.mics!.where((element) => element.user_id == user!.id).toList().length > 0){
                                                if(_localUserMute){
                                                  await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
                                                  setState(() {
                                                    _localUserMute = false ;
                                                  });
                                                } else {
                                                  await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
                                                  setState(() {
                                                    _localUserMute = true ;
                                                  });
                                                }
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: 'You are not using any mic !',
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.black26,
                                                    textColor: Colors.orange,
                                                    fontSize: 16.0);
                                              }
                                            },
                                            child: Image(
                                              image: _localUserMute ? AssetImage('assets/images/mic_off.png') :  AssetImage('assets/images/mic_on.png'),
                                              width: 40.0,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          GestureDetector(
                                              onTap: (){
                                                showModalBottomSheet(

                                                    context: context,
                                                    builder: (ctx) => EmojBottomSheet());
                                              },
                                              child: Image(
                                                image: AssetImage('assets/images/emoj.png'),
                                                width: 40.0,
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              showModalBottomSheet(

                                                  context: context,
                                                  builder: (ctx) => giftBottomSheet());
                                            },
                                            child: Image(
                                              image: AssetImage('assets/images/gift_box.webp'),
                                              width: 40.0,
                                            ),
                                          )
                                        ],
                                      ))
                                ],
                              ) :     Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[600],
                                            borderRadius: BorderRadius.circular(13.0)
                                        ),
                                        height: 45.0,
                                        child: TextFormField(
                                            controller: _messageController,
                                            autofocus: true,
                                            focusNode: focusNode,
                                            cursorColor: Colors.grey,
                                            style: TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                                hintText: 'chat_hint_text_form'.tr,
                                                hintStyle: TextStyle(
                                                    color: Colors.white, fontSize: 14),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(13.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,),
                                                  borderRadius: BorderRadius.circular(13.0),
                                                ),
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      emojiShowing = !emojiShowing;

                                                    });
                                                  },
                                                  icon: Icon(Icons.emoji_emotions_outlined,
                                                    color: Colors.white,), iconSize: 30.0,
                                                )
                                            )
                                        ),
                                      )
                                  ),
                                  SizedBox(width: 15.0,),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: MyColors.primaryColor,
                                        borderRadius: BorderRadius.circular(10.0)
                                    ),
                                    height: 45.0,
                                    width: 65.0,
                                    child: MaterialButton(
                                      onPressed: () {
                                        sendMessage();

                                      }, //sendMessage
                                      child: Text('gift_send'.tr, style: TextStyle(
                                          color: MyColors.darkColor,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Offstage(
                                offstage: !emojiShowing,
                                child: SizedBox(
                                    height: 250,
                                    child: EmojiPicker(
                                        textEditingController: _messageController,
                                        onBackspacePressed: () {
                                          print('clicked');
                                        },
                                        config: Config(
                                          columns: 7,
                                          // Issue: https://github.com/flutter/flutter/issues/28894
                                          emojiSizeMax: 32 *
                                              (foundation.defaultTargetPlatform ==
                                                  TargetPlatform.iOS
                                                  ? 1.30
                                                  : 1.0),
                                          verticalSpacing: 0,
                                          horizontalSpacing: 0,
                                          gridPadding: EdgeInsets.zero,
                                          initCategory: Category.RECENT,
                                          bgColor: MyColors.darkColor,
                                          indicatorColor: MyColors.primaryColor,
                                          iconColor: Colors.grey,
                                          iconColorSelected: MyColors.primaryColor,
                                          backspaceColor: MyColors.primaryColor,
                                          skinToneDialogBgColor: MyColors.darkColor,
                                          skinToneIndicatorColor: Colors.grey,
                                          enableSkinTones: true,
                                          recentTabBehavior: RecentTabBehavior.RECENT,
                                          recentsLimit: 28,
                                          replaceEmojiOnLimitExceed: false,
                                          noRecents: Text(
                                            'chat_no_resents'.tr ,
                                            style: TextStyle(fontSize: 20,
                                                color: Colors.black26),
                                            textAlign: TextAlign.center,
                                          ),
                                          loadingIndicator: const SizedBox.shrink(),
                                          tabIndicatorAnimDuration: kTabScrollDuration,
                                          categoryIcons: const CategoryIcons(),
                                          buttonMode: ButtonMode.MATERIAL,
                                          checkPlatformCompatibility: true,
                                        )
                                    )
                                )
                            ),

                          ],
                        ),
                        entery != ""  ? SVGASimpleImage(   resUrl: entery) : Container() ,
                        giftImg != "" ?  SVGASimpleImage(   resUrl: giftImg) : Container() ,

                      ],
                    ),
                    !_localUserJoined ? Loading() : Container()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget ProfileBottomSheet( user )  {
   ChatRoomService.showMsgInput = showMsgInput ;
   return SmallProfileModal(visitor: user , type: 1);
  }

  Widget micListItem( mic) => StreamBuilder<Object>(
      stream: null,
      builder: (context, snapshot) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            mic!.mic_user_img == null ? RippleAnimation(
                              color:  MyColors.primaryColor ,
                              delay: const Duration(milliseconds: 300),
                              repeat: true,
                              minRadius: speakers.where((element) => element.toString() == mic!.mic_user_tag ).toList().length > 0 ? 25 : 0,
                              ripplesCount: 6,
                              duration: const Duration(milliseconds: 6 * 300),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 25,
                                backgroundImage: getMicUserImg(mic),
                              ),
                            ) :     RippleAnimation(
                              color:  MyColors.primaryColor ,
                              delay: const Duration(milliseconds: 300),
                              repeat: true,
                              minRadius: 25,
                              ripplesCount: 6,
                              duration: const Duration(milliseconds: 6 * 300),
                              child: CircleAvatar(
                                backgroundColor:  mic.mic_user_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                backgroundImage:  mic!.mic_user_img != "" ? ( mic!.mic_user_img.startsWith('https') ? NetworkImage( mic!.mic_user_img)  :  NetworkImage('${ASSETSBASEURL}AppUsers/${ mic!.mic_user_img}'))  :    null,
                                radius: 22,
                                child:  mic!.mic_user_img== "" ?
                                Text(mic!.mic_user_name.toUpperCase().substring(0 , 1) +
                                    (mic!.mic_user_name.contains(" ") ? mic!.mic_user_name.substring(mic!.mic_user_name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                  style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                              ),
                            ),
                            Container(height: 70.0, width: 70.0, child: mic!.frame != "" ? SVGASimpleImage(   resUrl: ASSETSBASEURL + 'Designs/Motion/' + mic!.frame +'?raw=true') : null),
                            // Container(height: 70.0, width: 70.0,
                            // child: speakers.where((element) => element.toString() == mic!.mic_user_tag ).toList().length > 0  ?
                            // SizedBox( height: 50.0, width: 50.0,
                            //     child: SVGASimpleImage(   resUrl: ASSETSBASEURL + 'Defaults/wave.svga')) : null),


                            //frame
                          ],
                        ),
                        micEmojs[mic.order -1] != "" ?    Container(height: 70.0, width: 70.0, child: SVGASimpleImage(   resUrl: micEmojs[mic.order -1] +'?raw=true') ) : Container()

                      ],
                    ),
                    Text(
                      mic!.mic_user_name == null
                          ? mic!.order.toString()
                          : mic!.mic_user_name,
                      style: TextStyle(color: Colors.white, fontSize: 13.0),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
                PopupMenuButton(
                    position: PopupMenuPosition.under,
                    shadowColor: MyColors.unSelectedColor,
                    elevation: 4.0,

                    color: MyColors.darkColor,
                    icon: Container(),
                    onSelected: (int result) {
                      micActions(result , mic);
                    },
                    itemBuilder: (BuildContext context) =>  AdminMicListItems(mic)
                ),
              ],
            ),
            (mic.user_id > 0 && room!.isCounter == 1) ? Transform.translate(
              offset: Offset(0, 8.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(20.0)),
                child: Text(mic.counter.toString() , style: TextStyle(color: MyColors.darkColor , fontSize: 14.0),),
              ),
            ): SizedBox()
          ],
        );
      }
  );


  micActions(result , mic) async {
    if(result == 1){
      //use_mic
      await MicHelper( user_id:  user!.id , room_id:  room!.id , mic: mic.order).useMic();
      await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      setState(() {
        _localUserMute = false ;
      });
    }
    else if(result == 2){
      //lock_mic
      MicHelper( user_id:  user!.id , room_id:  room!.id , mic: mic.order).lockMic();
    }
    else if(result == 3){
      //lock_all_mics
      MicHelper( user_id:  user!.id , room_id:  room!.id , mic: 0).lockMic();
    }
    else if(result == 4){
      //unlock_mic
      MicHelper( user_id:  user!.id , room_id:  room!.id , mic: mic.order).unlockMic();
    }
    else if(result == 5){
      //unlock_all_mic
      MicHelper( user_id:  user!.id , room_id:  room!.id , mic: 0).unlockMic();
    }
    else if(result == 6){
      //remove_from_mic
      MicHelper(user_id:  mic!.user_id , room_id:  room!.id , mic: mic.order).removeFromMic(user!.id);

    }
    else if(result == 7){
      //un_use_mic
      MicHelper( user_id:  user!.id , room_id:  room!.id , mic: mic.order).leaveMic();
      await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
      try{
        _engine = ChatRoomService.engine! ;
        await _engine.stopAudioMixing();
      }catch(err){

      }
      setState(() {
        _localUserMute = true ;
      });

    }
    else if(result == 8){
      //mute
      if(_localUserMute){
        await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
        setState(() {
          _localUserMute = false ;
        });
      } else {
        await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
        setState(() {
          _localUserMute = true ;
        });
      }

    } else if(result == 9){
      //showprofile

      AppUser? res =  await AppUserServices().getUser(mic!.user_id);
      showModalBottomSheet(

          context: context,
          builder: (ctx) => ProfileBottomSheet(res)).whenComplete(() {
            setState(() {
              showMsgInput = ChatRoomService.showMsgInput ;
            });
            if(showMsgInput){
              _messageController.text = "@" + res!.name + '.';
            }
      });

    }
  }

  ImageProvider getMicUserImg(mic) {
    //if (mic!.mic_user_img == null) {
    if(mic.isClosed == 0)
      return AssetImage('assets/images/mic_open.png');
    else
      return AssetImage('assets/images/mic_close.png');
    // } else {
    //
    //   return NetworkImage(ASSETSBASEURL + 'AppUsers/' + mic!.mic_user_img);
    // }
  }


  Widget RoomCup( ) => RoomCupModal();

  Widget EmojBottomSheet( ) => EmojModal();
  Widget giftBottomSheet() => GiftModal(reciverId: 0,);
  Widget MenuBottomSheet() => MenuModal(scrollController: _scrollController,);
  Widget RoomInfoBottomSheet() => RoomInfoModal();
  Widget roomCloseModal() => RoomCloseModal(pcontext: context, engine: _engine);
  Widget roomMembersModal() => RoomMembersModal();
  List<PopupMenuEntry<int>> AdminMicListItems(mic) {
    if(userRole == 'OWNER'  || userRole == 'ADMIN'){
      if(mic.user_id == 0){
        if(mic.isClosed == 0){
          return
            [
              PopupMenuItem<int>(
                value: 1,
                child: Text('use_mic'.tr , style: TextStyle(color: Colors.white),),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text('lock_mic'.tr , style: TextStyle(color: Colors.white),),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Text('lock_all_mics'.tr , style: TextStyle(color: Colors.white),),
              ),
            ];

        } else {
          return
            [
              PopupMenuItem<int>(
                value: 4,
                child: Text('unlock_mic'.tr , style: TextStyle(color: Colors.white),),
              ),
              PopupMenuItem<int>(
                value: 5,
                child: Text('unlock_all_mic'.tr , style: TextStyle(color: Colors.white),),
              ),

            ];
        }
      } else {
        if(mic.user_id != user!.id){
          return
            [
              PopupMenuItem<int>(
                value: 6,
                child: Text('remove_from_mic'.tr , style: TextStyle(color: Colors.white),),
              ),
              PopupMenuItem<int>(
                value: 6,
                child: Text('kick_out'.tr , style: TextStyle(color: Colors.white),),
              ),
              PopupMenuItem<int>(
                value: 9,
                child: Text('show_user'.tr , style: TextStyle(color: Colors.white),),
              ),


            ];
        } else {
          return
            [
              PopupMenuItem<int>(
                value: 7,
                child: Text('un_use_mic'.tr , style: TextStyle(color: Colors.white),),
              ),
              PopupMenuItem<int>(
                value: 8,
                child: _localUserMute ? Text('unmute'.tr , style: TextStyle(color: Colors.white),) :  Text('mute'.tr , style: TextStyle(color: Colors.white),),
              ),

            ];

        }
      }
    } else {
      // not admin
      if(mic.user_id == 0){
        if(mic.isClosed == 0){
          if(mic.order > 1){
            return [
              PopupMenuItem<int>(
                value: 1,
                child: Text('use_mic'.tr , style: TextStyle(color: Colors.white),),
              ),
            ];
          } else {
            Fluttertoast.showToast(
                msg: 'admin_mic_alert'.tr,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black26,
                textColor: Colors.orange,
                fontSize: 16.0);
            return [];
          }

        } else {
          Fluttertoast.showToast(
              msg: 'room_close_mic'.tr,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black26,
              textColor: Colors.orange,
              fontSize: 16.0);
          return [];
        }
      } else {
        if(mic.user_id != user!.id){
          return
            [
              PopupMenuItem<int>(
                value: 9,
                child: Text('show_user'.tr , style: TextStyle(color: Colors.white),),
              ),


            ];
        } else {
          return
            [
              PopupMenuItem<int>(
                value: 7,
                child: Text('un_use_mic'.tr , style: TextStyle(color: Colors.white),),
              ),
              PopupMenuItem<int>(
                value: 8,
                child: _localUserMute ? Text('unmute'.tr , style: TextStyle(color: Colors.white),) :  Text('mute'.tr , style: TextStyle(color: Colors.white),),
              ),

            ];
        }

      }
    }

  }

  Widget roomMessageBuilder(index) => messages[index].user_id == 0 ? Flex(
    direction: Axis.horizontal,
    children: [
      Container( padding: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0 ),   decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0) , color: Colors.black54),   constraints: BoxConstraints(
        maxWidth: (MediaQuery.of(context).size.width * 0.7) - 20.0,
      ),
        child: messages[index].user_name == 'APP' ? Text( messages[index].message , style: TextStyle(color: Colors.red , fontSize: 13.0),) :
        Text( 'notice'.tr +  messages[index].message , style: TextStyle(color: MyColors.primaryColor , fontSize: 13.0),),
      ),
    ],
  ) : Flex(
    direction: Axis.horizontal,
    children: [
      Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0) , color: Colors.black54) ,  padding: EdgeInsets.symmetric(horizontal: 5.0 , vertical: 5.0 ),    constraints: BoxConstraints(
        maxWidth: (MediaQuery.of(context).size.width * 0.7) - 20.0,
      ),
        child:
        GestureDetector(
          onTap: () async{
            AppUser? res =  await AppUserServices().getUser(messages[index].user_id);
            showModalBottomSheet(

                context: context,
                builder: (ctx) => ProfileBottomSheet(res)).whenComplete(() {
              setState(() {
                showMsgInput = ChatRoomService.showMsgInput ;
              });
              if(showMsgInput){
                _messageController.text = "@" + res!.name + '.' ;
              }
            });
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(image: NetworkImage('${ASSETSBASEURL}Levels/${messages[index].user_share_level_img}') , width: 30,),
              SizedBox(width: 5.0,),
              getMessageContent(messages[index])

            ],
          ),
        ),
      ),
    ],
  );
  Widget roomMessageSeperator() => SizedBox(height: 5.0,);

  Widget getMessageContent(ChatRoomMessage message) {
    if(message.type == "TEXT"  || message.type == "GIFT"){
      return   Expanded(child: Text(message.user_name + ': '  + message.message , style: TextStyle(color: MyColors.whiteColor , fontSize: 13.0),  overflow: TextOverflow.ellipsis,
          maxLines: 4,
          textAlign: TextAlign.start));
    } else if(message.type == "NURD"){
      return Column(
        children: [
          Text(message.user_name , style: TextStyle(color: MyColors.whiteColor , fontSize: 13.0 ) , overflow: TextOverflow.ellipsis, ),
          SizedBox(height: 10.0,),
          Image(image: NetworkImage(ASSETSBASEURL + 'Nurd/' + message.message + '.webp' ) , width: 40.0,)
        ],
      );
    }
    else if(message.type == "LUCKY"){
      return Column(
        children: [
          Text(message.user_name , style: TextStyle(color: MyColors.whiteColor , fontSize: 13.0 ) , overflow: TextOverflow.ellipsis, ),
          SizedBox(height: 10.0,),
          Text(message.message , style: TextStyle(color: MyColors.primaryColor , fontSize: 30.0 , fontWeight: FontWeight.bold  ) , overflow: TextOverflow.ellipsis, ),
        ],
      );

    }
    else {
      return Container();
    }
  }



Widget roomMemberItmeBuilder(RoomMember user) =>    GestureDetector(
  onTap: () async{
    AppUser? res =  await AppUserServices().getUser(user.user_id);
    showModalBottomSheet(

        context: context,
        builder: (ctx) => ProfileBottomSheet(res)).whenComplete(() {
      setState(() {
        showMsgInput = ChatRoomService.showMsgInput ;
      });
      if(showMsgInput){
        _messageController.text = "@" + res!.name + '.';
      }
    });
  },
  child: Stack(
    alignment: Alignment.center,
    children: [
      CircleAvatar(
          radius: 15.0,
          backgroundImage: getUserAvatar(user)),
      user.user_id == room!.userId  ? Image(
        image: AssetImage(
            'assets/images/room_user_small_border.png'),
        width: 50,
        height: 50,
      ): SizedBox()
    ],
  ),
);

  ImageProvider getUserAvatar(RoomMember user) {

    if (user.mic_user_img == '') {
      return AssetImage('assets/images/user.png');
    } else {
      return NetworkImage('${ASSETSBASEURL}AppUsers/${user.mic_user_img}');
    }
  }



}

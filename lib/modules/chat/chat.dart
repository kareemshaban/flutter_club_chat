import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../chat_bubble/chat_bubble_reciever.dart';
import '../chat_service/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUserEmail ;
  final String receiverUserID ;
  const ChatScreen({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
  });
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);
    }
    //clear the text controller after sending the message
    _messageController.clear();
  }

  bool emojiShowing = false;

  _onBackspacePressed() {
    print('clicked');
    _messageController
      ..text = _messageController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _messageController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.grey[850],
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white,)
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 23.0,
              ),
              SizedBox(width: 5.0,),
              Text('Mohamed Yousri',
                style: TextStyle(color: Colors.white, fontSize: 18.0),),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.menu, color: Colors.white,)
                    ),
                  ],
                ),
              )
            ],
          )
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  //messages
                  child: _buildMessageList(),
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
                              noRecents: const Text(
                                'No Recents',
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
                Container(
                  height: 70,
                  color: MyColors.darkColor,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
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
                                cursorColor: Colors.grey,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: 'Enter Something...',
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
                                          print(emojiShowing);
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
                        height: 40.0,
                        width: 67,
                        decoration: BoxDecoration(
                          color: MyColors.primaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            sendMessage;
                          }, //sendMessage
                          child: Text('Send', style: TextStyle(
                              color: MyColors.darkColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// build message list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserID,
            _firebaseAuth.currentUser!.uid
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error' + snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading');
          }
          return Container(
            color: Colors.grey[600],
            child: ListView(
              children: snapshot.data!.docs
                  .map((document) => _buildMessageItem(document))
                  .toList(),
            ),
          );
        }
    );
  }

// build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    // allign the message to the right if the sender is the current user, otherwise to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerLeft
        : Alignment.centerRight;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: (data['senderId'] ==
              _firebaseAuth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] ==
              _firebaseAuth.currentUser!.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Row(
              children: [
                ChatBubble(message: data['message']),
                SizedBox(width: 5.0,),
                CircleAvatar(
                  radius: 23.0,
                ),
              ],
            ) : Row(
              children: [
                CircleAvatar(
                  radius: 23.0,
                ),
                SizedBox(width: 5.0,),
                ChatBubble(message: data['message']),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:whisperwave/service/database.dart';
import 'package:whisperwave/service/shared_pref.dart';

class ChatScreen extends StatefulWidget {
  final String? name, profileurl, username;
  const ChatScreen(
      {super.key,
      required this.name,
      required this.profileurl,
      required this.username});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messagecontroller = new TextEditingController();
  String? myName, myProfilePic, myUserName, myEmail, messageID, chatRoomId;
  Stream? messageStream;
  getthesharedpref() async {
    myName = await sharedPreferenceHelper().getUserDisplayName();
    myProfilePic = await sharedPreferenceHelper().getUserPic();
    myUserName = await sharedPreferenceHelper().getUserName();
    myEmail = await sharedPreferenceHelper().getUserEmail();
    chatRoomId = getChatRoomIdbyUsername(widget.username!, myUserName!);
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    await getAndSetMessages();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  getChatRoomIdbyUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return 'users/$b/$a';
    } else {
      return 'users/$a/$b';
    }
  }

  Widget chatMessageTitle(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomRight:
                    sendByMe ? Radius.circular(0) : Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: sendByMe ? Radius.circular(24) : Radius.circular(0),
              ),
              color: sendByMe
                  ? Color.fromARGB(255, 234, 236, 240)
                  : Color.fromARGB(255, 211, 228, 243),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget chatMessage() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 90, top: 130),
                itemCount: snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return chatMessageTitle(
                      ds["message"], myUserName == ds["sendBy"]);
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  addMessage(bool sendClicked) {
    if (messagecontroller.text != "") {
      String message = messagecontroller.text;
      messagecontroller.text = "";
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('h:mma').format(now);
      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": formattedDate, // time stamp
        "time": FieldValue.serverTimestamp(),
        "imgUrl": myProfilePic,
      };
      messageID ??= randomAlphaNumeric(10);
      DatabaseMethods()
          .addMessage(chatRoomId!, messageID!, messageInfoMap)
          .then(
        (value) {
          Map<String, dynamic> lastMessageInfoMap = {
            "lastMessage": message,
            "lastMessageSendTs": formattedDate,
            "time": FieldValue.serverTimestamp(),
            "lastMessageSendBy": myUserName,
          };
          DatabaseMethods()
              .updateLastMessageSend(chatRoomId!, lastMessageInfoMap);
          if (sendClicked) {
            messageID = null;
          }
        },
      );
    }
  }

  getAndSetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF553370),
      appBar: AppBar(
        backgroundColor: Color(0xFF553370),
        leading: IconButton(
          color: Color(0xFFC199CD),
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text(
          widget.name!,
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFC199CD),
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(30.0))),
            child: chatMessage(),
          ),
          Positioned(
            left: 20.0,
            right: 20.0,
            bottom: 15.0,
            child: Material(
              borderRadius: BorderRadius.circular(30.0),
              elevation: 5.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messagecontroller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message',
                          hintStyle: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => addMessage(true),
                      icon: Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

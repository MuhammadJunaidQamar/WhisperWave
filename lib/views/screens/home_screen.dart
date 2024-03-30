import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whisperwave/service/database.dart';
import 'package:whisperwave/service/shared_pref.dart';
import 'package:whisperwave/utils/routes_name.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool search = false;
  String? myName, myProfilePic, myUserName, myEmail;
  Stream? chatRoomsStream;
  getthesharedpref() async {
    myName = await SharedPreferenceHelper().getUserDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserPic();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    chatRoomsStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return ChatRoomListTile(
                    chatRoomId: ds.id,
                    lastMessage: ds["lastMessage"],
                    myUsername: myUserName!,
                    time: ds["lastMessageSendTs"],
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  getChatRoomIdbyUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      // ignore: unnecessary_string_escapes
      return '$b\_$a';
    } else {
      // ignore: unnecessary_string_escapes
      return '$a\_$b';
    }
  }

  var queryResultSet = [];
  var tempSearchStore = [];
  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().search(value).then(
        (QuerySnapshot docs) {
          for (int i = 0; i < docs.docs.length; i++) {
            queryResultSet.add(docs.docs[i].data());
          }
        },
      );
    } else {
      tempSearchStore = [];
      for (var element in queryResultSet) {
        if (element['UserName'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (search) {
          setState(() {
            search = false;
          });
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF553370),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF553370),
          title: search
              ? Expanded(
                  child: TextField(
                    autofocus: true,
                    onChanged: (value) {
                      initiateSearch(value.toUpperCase());
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search User',
                      hintStyle: TextStyle(
                        color: Color(0xFFC199CD),
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : const Text(
                  'Wisper Wave',
                  style: TextStyle(
                    color: Color(0xFFC199CD),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          actions: [
            GestureDetector(
              onTap: () {
                setState(() {
                  search = !search;
                  if (!search) {
                    queryResultSet = [];
                    tempSearchStore = [];
                  }
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 20.0),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xFF3A2144),
                    borderRadius: BorderRadius.circular(20)),
                child: search
                    ? const Icon(
                        Icons.close,
                        color: Color(0xFFC199CD),
                      )
                    : const Icon(
                        Icons.search,
                        color: Color(0xFFC199CD),
                      ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0, horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    search
                        ? ListView(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            primary: false,
                            shrinkWrap: true,
                            children: tempSearchStore.map((element) {
                              return buildResultCard(element);
                            }).toList(),
                          )
                        : chatRoomList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResultCard(data) {
    return data == null
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : GestureDetector(
            onTap: () async {
              var chatRoomId =
                  getChatRoomIdbyUsername(myUserName!, data["UserName"]);
              Map<String, dynamic> chatRoomInfoMap = {
                "users": [myUserName, data["UserName"]],
              };
              await DatabaseMethods()
                  .createChatRoom(chatRoomId, chatRoomInfoMap);
              search = false;
              setState(() {});
              queryResultSet = [];
              tempSearchStore = [];
              Navigator.pushNamed(
                context,
                RouteName.chatScreen,
                arguments: {
                  'name': data["Name"],
                  'profileUrl': data["Photo"],
                  'username': data["UserName"],
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          data["Photo"],
                          height: 70.0,
                          width: 70.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data["Name"],
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            data["UserName"],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String? lastMessage, chatRoomId, myUsername, time;
  const ChatRoomListTile(
      {super.key,
      required this.chatRoomId,
      required this.lastMessage,
      required this.myUsername,
      required this.time});

  @override
  State<ChatRoomListTile> createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String name = "", profileUrl = "", username = "", id = "";
  getThisUserInfo() async {
    username = widget.chatRoomId!
        .replaceAll("_", "")
        .replaceAll(widget.myUsername!, "");
    QuerySnapshot querySnapshot =
        await DatabaseMethods().getUserInfo(username.toUpperCase());
    name = "${querySnapshot.docs[0]["Name"]}";
    profileUrl = "${querySnapshot.docs[0]["Photo"]}";
    id = "${querySnapshot.docs[0]["Id"]}";
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        RouteName.chatScreen,
        arguments: {
          'name': name,
          'profileUrl': profileUrl,
          'username': username,
        },
      ),
      child: Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileUrl == ""
                ? const CircularProgressIndicator()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      profileUrl,
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.lastMessage!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.time!,
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

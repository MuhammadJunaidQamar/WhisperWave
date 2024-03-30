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
  getthesharedpref() async {
    myName = await sharedPreferenceHelper().getUserDisplayName();
    myProfilePic = await sharedPreferenceHelper().getUserPic();
    myUserName = await sharedPreferenceHelper().getUserName();
    myEmail = await sharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
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
      queryResultSet.forEach(
        (element) {
          if (element['UserName'].startsWith(capitalizedValue)) {
            setState(() {
              tempSearchStore.add(element);
            });
          }
        },
      );
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
        backgroundColor: Color(0xFF553370),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF553370),
          title: search
              ? Expanded(
                  child: TextField(
                    autofocus: true,
                    onChanged: (value) {
                      initiateSearch(value.toUpperCase());
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search User',
                      hintStyle: TextStyle(
                        color: Color(0xFFC199CD),
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : Text(
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
                margin: EdgeInsets.only(right: 20.0),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Color(0xFF3A2144),
                    borderRadius: BorderRadius.circular(20)),
                child: search
                    ? Icon(
                        Icons.close,
                        color: Color(0xFFC199CD),
                      )
                    : Icon(
                        Icons.search,
                        color: Color(0xFFC199CD),
                      ),
              ),
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
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
                              padding: EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                              ),
                              primary: false,
                              shrinkWrap: true,
                              children: tempSearchStore.map((element) {
                                return buildResultCard(element);
                              }).toList(),
                            )
                          : Column(
                              children: [
                                GestureDetector(
                                  // onTap: () => Navigator.pushNamed(
                                  //     context, RouteName.chatScreen),
                                  child: Container(
                                    color: Colors.white,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: Image.asset(
                                            'assets/images/boy1.jpg',
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              'Junaid1',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              'Hello, what are you doing?',
                                              style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Text(
                                          '4:30 PM',
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                GestureDetector(
                                  // onTap: () => Navigator.pushNamed(
                                  //     context, RouteName.chatScreen),
                                  child: Container(
                                    color: Colors.white,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: Image.asset(
                                            'assets/images/boy2.jpg',
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              'Junaid2',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              'You Alive?',
                                              style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Text(
                                          '4:30 PM',
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResultCard(data) {
    return data == null
        ? Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Center(
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
              // setState(() {});
              // queryResultSet = [];
              // tempSearchStore = [];
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
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(18),
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
                      SizedBox(
                        width: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data["Name"],
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            data["UserName"],
                            style: TextStyle(
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

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF553370),
      appBar: AppBar(
        backgroundColor: Color(0xFF553370),
        leading: IconButton(
          color: Color(0xFFC199CD),
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text(
          widget.name ?? 'rffffffffffffff',
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFC199CD),
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 50.0,
          bottom: 40.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              margin:
                  EdgeInsets.only(left: MediaQuery.of(context).size.width / 3),
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 234, 236, 240),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Text(
                'Hello, what are you doing?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin:
                  EdgeInsets.only(right: MediaQuery.of(context).size.width / 3),
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 211, 228, 243),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                'THE DAY WAS REALLY GOOD',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Spacer(),
            Material(
              borderRadius: BorderRadius.circular(30.0),
              elevation: 5.0,
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message',
                          hintStyle: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: Color(0xFFF3F3F3),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.send,
                          color: Color.fromARGB(255, 164, 154, 154),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

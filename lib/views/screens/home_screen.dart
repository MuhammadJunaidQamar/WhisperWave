import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: Color(0xFF553370),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF553370),
          title: Text(
            'Wisper Wave',
            style: TextStyle(
              color: Color(0xFFC199CD),
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 20.0),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Color(0xFF3A2144),
                  borderRadius: BorderRadius.circular(20)),
              child: Icon(
                Icons.search,
                color: Color(0xFFC199CD),
              ),
            ),
            // IconButton(
            //   style: ButtonStyle(backgroundColor: Color(0xFF3A2144),),
            //   padding: EdgeInsets.all(8),
            //   color: Color(0xFF3A2144),
            //   onPressed: () {},
            //   icon: Icon(
            //     Icons.search,
            //     color: Color(0xFFC199CD),
            //   ),
            // )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(
              //       left: 20.0, right: 20.0, top: 50.0, bottom: 20.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         'WisperWave',
              //         style: TextStyle(
              //           color: Color(0xFFC199CD),
              //           fontSize: 22.0,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       Container(
              //         padding: EdgeInsets.all(8),
              //         decoration: BoxDecoration(
              //             color: Color(0xFF3A2144),
              //             borderRadius: BorderRadius.circular(20)),
              //         child: Icon(
              //           Icons.search,
              //           color: Color(0xFFC199CD),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
}

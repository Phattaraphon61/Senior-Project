// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:easypayeasywash/createbank/createbank.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Selectbank extends StatefulWidget {
  Selectbank({Key? key, required this.userInfo})
      : super(key: key);
  Map<String, dynamic>? userInfo;

  @override
  State<Selectbank> createState() => _SelectbankState();
}

class _SelectbankState extends State<Selectbank> {
  List<dynamic>? banks = [
    {'engname': 'scb', 'thname': 'ไทยพาณิชย์'},
    {'engname': 'kbank', 'thname': 'กสิกรไทย'},
    {'engname': 'ktb', 'thname': 'กรุงไทย'}
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(
                    child: Container(
                      // ignore: unnecessary_new
                      decoration: new BoxDecoration(
                          color: Color.fromRGBO(84, 199, 199, 1),
                          // ignore: unnecessary_new
                          borderRadius: new BorderRadius.only(
                              bottomLeft: const Radius.circular(8),
                              bottomRight: const Radius.circular(8))),
                      height: height * 0.07,
                    ),
                  ),
                  Positioned(
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new),
                          iconSize: 30,
                          color: Colors.white,
                          tooltip: 'back',
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: Createbank(
                                  userInfo: widget.userInfo,
                                  bank: null,
                                ),
                              ),
                            );
                            print('back');
                          },
                        ),
                        // Text(
                        //   'ย้อนกลับ',
                        //   style: TextStyle(fontSize: 20, color: Colors.white),
                        // ),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      "เลือกธนาคาร",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  for (var i in banks!)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: GestureDetector(
                        onTap: () {
                          print("YES");
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRight,
                              child: Createbank(
                                  userInfo: widget.userInfo,
                                  bank: i),
                            ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            leading: Image.asset(
                                'assets/images/${i['engname']}.png'),
                            title: Text('ธนาคาร' + i['thname']),
                            // subtitle: Text('เครื่องหน้าหอ'),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

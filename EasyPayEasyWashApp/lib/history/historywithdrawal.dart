import 'dart:convert';

import 'package:easypayeasywash/home/home.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

class History extends StatefulWidget {
  History({Key? key, required this.userInfo}) : super(key: key);
  Map<String, dynamic>? userInfo;

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<dynamic>? data;
  Future<bool> loaddata() async {
    var client = http.Client();
    var response = await client.post(
        Uri.parse('https://server.easypayeasywash.tk/withdraw/getmywithdraw'),
        body: {'userid': '${widget.userInfo!['id']}'});
    client.close();
    print(json.decode(response.body)['data']);
    data = json.decode(response.body)['data'];
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: loaddata(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
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
                                  Navigator.pop(context);
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
                            "ประวัติการถอน",
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        for (var i in data!)
                          Card(
                            child: ListTile(
                              title: Text('ถอนเงินจำนวน ${i['amount']} บาท'),
                              subtitle: Text(i['updatedAt']),
                              trailing: i['status'] == "approve"
                                  ? Text("สำเร็จ",
                                      style: TextStyle(color: Colors.green))
                                  : i['status'] == "wait"
                                      ? Text("กำลังดำเนินการ",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 251, 168, 2)))
                                      : Tooltip(
                                          message: i['detail'].toString(),
                                          child: new Text("ไม่สำเสร็จ",
                                              style: TextStyle(
                                                  color: Color.fromARGB(255, 255, 1, 1)))),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

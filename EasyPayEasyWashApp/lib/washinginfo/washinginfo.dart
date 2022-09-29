// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:easypayeasywash/home/home.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

class WashingInfo extends StatefulWidget {
  WashingInfo({Key? key, required this.userData, required this.washinginfo})
      : super(key: key);
  Map<String, dynamic>? userData, washinginfo;

  @override
  State<WashingInfo> createState() => _WashingInfoState();
}

class _WashingInfoState extends State<WashingInfo> {
  TextEditingController? detail, price;
  @override
  void initState() {
    super.initState();
    detail =
        new TextEditingController(text: '${widget.washinginfo!['detail']}');
    price = new TextEditingController(text: '${widget.washinginfo!['price']}');
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("ยกเลิก"),
      onPressed: () {
        Navigator.pop(context);
        // );
      },
    );
    Widget continueButton = FlatButton(
      child: Text("ยืนยัน"),
      onPressed: () async {
        Navigator.pop(context);
        var client = http.Client();
        var response = await client.post(
            Uri.parse('https://server.easypayeasywash.tk/washing/logout'),
            body: {
              'washingid': '${widget.washinginfo!['washingid']}',
            });
        client.close();
        print(json.decode(response.body)['message']);
        if (json.decode(response.body)['message'] == "success") {
          ArtDialogResponse response = await ArtSweetAlert.show(
              barrierDismissible: false,
              context: context,
              artDialogArgs: ArtDialogArgs(
                // showCancelBtn: true,
                title: "ดำเนินการเสร็จสิ้น",
                confirmButtonText: "OK",
              ));

          if (response == null) {
            return;
          }
          if (response.isTapConfirmButton) {
            print(response.isTapConfirmButton);
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.leftToRight,
                child: Home(),
              ),
            );
          }
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ลบเครื่องซักผ้า"),
      content: Text("กรุณายืนยันเพื่อทำการลบเครื่องซักผ้าไอดีนี้"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

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
                                child: Home(),
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
                      "จัดการเครื่องซักผ้า",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ),
              Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.05),
                    child: Center(
                        child: Image.asset('assets/images/washing.png',
                            width: 153, height: 153, fit: BoxFit.fill)),
                  ),
                  Center(
                    child: Text(
                      'ID : ${widget.washinginfo!['washingid']}',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: price,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("ค่าบริการ"),
                        hintText: 'กรอกค่าบริการ',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: detail,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("คำอธิบาย"),
                        hintText: 'กรอกคำอธิบาย',
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          print("YES");
                          print(price!.text);
                          print(detail!.text);
                          var client = http.Client();
                          var response = await client.post(
                              Uri.parse(
                                  'https://server.easypayeasywash.tk/washing/update'),
                              body: {
                                'type':'edit',
                                'washingid':
                                    '${widget.washinginfo!['washingid']}',
                                "detail": "${detail!.text}",
                                "price": "${price!.text}"
                              });
                          client.close();
                          print(json.decode(response.body)['message']);
                          if (json.decode(response.body)['message'] ==
                              "success") {
                            ArtDialogResponse response =
                                await ArtSweetAlert.show(
                                    barrierDismissible: false,
                                    context: context,
                                    artDialogArgs: ArtDialogArgs(
                                      // showCancelBtn: true,
                                      title: "ดำเนินการเสร็จสิ้น",
                                      confirmButtonText: "OK",
                                    ));

                            if (response == null) {
                              return;
                            }
                          }
                          // showAlertDialog(context);
                          // ArtDialogResponse response = await ArtSweetAlert.show(
                          //     barrierDismissible: false,
                          //     context: context,
                          //     artDialogArgs: ArtDialogArgs(
                          //       // showCancelBtn: true,
                          //       title: "ดำเนินการแก้ไขเสร็จสิ้น",
                          //       confirmButtonText: "OK",
                          //     ));
                          // if (response == null) {
                          //   return;
                          // }

                          // if (response.isTapConfirmButton) {
                          //   print(response.isTapConfirmButton);
                          //   Navigator.pop(context);
                          // }
                        },
                        child: Container(
                          // ignore: unnecessary_new
                          decoration: new BoxDecoration(
                              color: Color.fromARGB(255, 253, 199, 24),
                              // ignore: unnecessary_new
                              borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(10),
                                  topRight: const Radius.circular(10),
                                  bottomLeft: const Radius.circular(10),
                                  bottomRight: const Radius.circular(10))),
                          width: width * 0.3,
                          height: height * 0.06,
                          child: Center(
                            child: Text(
                              "แก้ไข",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          print("YES");
                          showAlertDialog(context);
                        },
                        child: Container(
                          // ignore: unnecessary_new
                          decoration: new BoxDecoration(
                              color: Color.fromARGB(255, 250, 25, 25),
                              // ignore: unnecessary_new
                              borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(10),
                                  topRight: const Radius.circular(10),
                                  bottomLeft: const Radius.circular(10),
                                  bottomRight: const Radius.circular(10))),
                          width: width * 0.3,
                          height: height * 0.06,
                          child: Center(
                            child: Text(
                              "ลบ",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

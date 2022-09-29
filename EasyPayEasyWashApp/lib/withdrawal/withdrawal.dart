// ignore_for_file: prefer_const_constructors, must_be_immutable, deprecated_member_use

import 'dart:convert';

import 'package:easypayeasywash/createbank/createbank.dart';
import 'package:easypayeasywash/home/home.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:http/http.dart' as http;

class Withdrawal extends StatefulWidget {
  Withdrawal({Key? key, required this.userInfo, required this.bank})
      : super(key: key);
  Map<String, dynamic>? userInfo, bank;

  @override
  State<Withdrawal> createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {
  final amount = TextEditingController();
  bool check = false;
  Map<String, dynamic> banks = {
    'scb': 'ไทยพาณิชย์',
    'kbank': 'กสิกรไทย',
    'ktb': 'กรุงไทย'
  };
  numtostar(num) {
    var tt = [];
    for (int i = 0; i < num.length; i++) {
      if (num.length - i <= 3) {
        tt.add(num[i]);
      } else {
        tt.add("*");
      }
      if (i + 1 == num.length) {
        return tt.join().toString();
      }
    }
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
        print('kkkk');
        Navigator.pop(context);
        var client = http.Client();
        var response = await client.post(
            Uri.parse('https://server.easypayeasywash.tk/withdraw/create'),
            body: {
              "userid": "${widget.userInfo!['id']}",
              "bank":
                  '{"bank":"${widget.bank!['bank']}","number": "${widget.bank!['number']}","name": "${widget.bank!['name']}"}',
              "amount": '${amount.text}'
            });
        client.close();
        print(json.decode(response.body)['message']);
        if (json.decode(response.body)['message'] == "success") {
          ArtDialogResponse response = await ArtSweetAlert.show(
              barrierDismissible: false,
              context: context,
              artDialogArgs: ArtDialogArgs(
                // showCancelBtn: true,
                title: "ดำเนินการเสร็จสิ้น รอระบบดำเนินการ",
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
      title: Text("ถอนเงิน"),
      content: Text("กรุณายืนยันเพื่อถอนเงินจำนวน ${amount.text} บาท"),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              bottomLeft: const Radius.circular(48.0),
                              bottomRight: const Radius.circular(48.0))),
                      height: height * 0.3,
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
                      "ถอน",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.18),
                    child: Center(
                      child: Container(
                          width: width * 0.8,
                          height: height * 0.2,
                          // ignore: unnecessary_new
                          decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  // ignore: unnecessary_new
                                  new BorderRadius.all(Radius.circular(23)),
                              // ignore: prefer_const_literals_to_create_immutables
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 10,
                                  offset: Offset(1, 8),
                                )
                              ])),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.1),
                    child: Center(
                      child: Column(
                        children: [
                          ClipOval(
                              child: Image.network(
                            widget.userInfo!['image'],
                            fit: BoxFit.contain,
                            matchTextDirection: true,
                            height: height * 0.13,
                          )),
                          Text(
                            widget.userInfo!['name'],
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              "ยอดที่สามารถถอนได้ ",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: height * 0.01),
                              child: Text(
                                NumberFormat("#,###")
                                    .format(widget.userInfo!['balance']),
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.45),
                    child: Column(children: [
                      Text("ถอนไปยัง"),
                      widget.bank == null
                          ? GestureDetector(
                              onTap: () {
                                print("YES");
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: Createbank(
                                      userInfo: widget.userInfo,
                                      bank: null,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text('เลือกบัญชีธนาคาร'),
                                  // subtitle: Text('เครื่องหน้าหอ'),
                                  trailing: Icon(Icons.navigate_next_rounded),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                print("YES");
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: Createbank(
                                      userInfo: widget.userInfo,
                                      bank: null,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                child: ListTile(
                                  leading: Image.asset(
                                      'assets/images/${widget.bank!['bank']}.png'),
                                  title: Text(widget.bank!['name']),
                                  subtitle: Text(
                                      'ธนาคาร${banks[widget.bank!['bank']].toString()} ' +
                                          numtostar(widget.bank!['number'])),
                                  trailing: Icon(Icons.navigate_next_rounded),
                                ),
                              ),
                            ),
                      Text("จำนวนเงิน"),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: amount,
                          onChanged: (text) {
                            if (int.parse(text) > widget.userInfo!['balance']) {
                              setState(() {
                                check = true;
                              });
                            } else {
                              setState(() {
                                check = false;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            errorText: check ? "ยอดเงินของคุณไม่เพียงพอ" : null,
                            border: OutlineInputBorder(),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'บาท',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            hintText: 'กรอกจำนวนเงินที่ต้องการถอน',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print(widget.userInfo!['balance']);
                          print(amount.text);
                          if (int.parse(amount.text) <=
                              widget.userInfo!['balance']) {
                            if (widget.bank != null) {
                              print("YYYYYYYYYY");
                              showAlertDialog(context);
                            } else {
                              ArtSweetAlert.show(
                                  context: context,
                                  artDialogArgs: ArtDialogArgs(
                                      type: ArtSweetAlertType.danger,
                                      title: "เลือกบัญชีธนาคาร",));
                            }
                          }
                          print("YES");
                          //  showAlertDialog(context);
                        },
                        child: Container(
                          // ignore: unnecessary_new
                          decoration: new BoxDecoration(
                              color: Color.fromARGB(255, 97, 222, 253),
                              // ignore: unnecessary_new
                              borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(10),
                                  topRight: const Radius.circular(10),
                                  bottomLeft: const Radius.circular(10),
                                  bottomRight: const Radius.circular(10))),
                          width: width * 0.7,
                          height: height * 0.06,
                          child: Center(
                            child: Text(
                              "ถอน",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      )
                      // TextFormField(
                      //   decoration: InputDecoration(
                      //     semanticCounterText: "kkk",
                      //     labelText: 'จำนวน',
                      //     labelStyle: TextStyle(
                      //       color: Color(0xFF6200EE),
                      //     ),
                      //     helperText: 'กรอกจำนวนเงินที่ต้องการจะถอน',
                      //     suffixIcon: Image.asset(
                      //       'assets/images/baht.png',
                      //       height: 1,
                      //       width: 1,
                      //     ),
                      //     enabledBorder: UnderlineInputBorder(
                      //       borderSide:
                      //           BorderSide(color: Color(0xFF6200EE)),
                      //     ),
                      //   ),
                      // ),
                    ]),
                  ),
                ],
              ),
              // Stack(
              //   children: [
              //     Container(
              //       // ignore: unnecessary_new
              //       decoration: new BoxDecoration(
              //           color: Color.fromRGBO(84, 199, 199, 1),
              //           // ignore: unnecessary_new
              //           borderRadius: new BorderRadius.only(
              //               topLeft: const Radius.circular(15.0),
              //               topRight: const Radius.circular(15.0))),
              //       height: height * 0.08,
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       children: [
              //         Positioned(
              //             child: Column(
              //           children: [
              //             SizedBox(
              //               height: height * 0.05,
              //               child: IconButton(
              //                 padding: EdgeInsets.all(0.0),
              //                 icon: Image.asset('assets/images/history.png'),
              //                 onPressed: () {
              //                   print("history");
              //                 },
              //               ),
              //             ),
              //             Text(
              //               "ประวัติการถอน",
              //               style: TextStyle(
              //                 fontSize: 14,
              //               ),
              //             )
              //           ],
              //         )),
              //         Positioned(
              //             child: Column(
              //           children: [
              //             SizedBox(
              //               height: height * 0.05,
              //               child: IconButton(
              //                 padding: EdgeInsets.all(0.0),
              //                 icon: Image.asset('assets/images/withdrawal.png'),
              //                 onPressed: () {
              //                   print("withdrawal");
              //                 },
              //               ),
              //             ),
              //             Text(
              //               "ถอน",
              //               style: TextStyle(
              //                 fontSize: 14,
              //               ),
              //             )
              //           ],
              //         )),
              //         Positioned(
              //             child: Column(
              //           children: [
              //             SizedBox(
              //               height: height * 0.05,
              //               child: IconButton(
              //                 padding: EdgeInsets.all(0.0),
              //                 icon: Image.asset('assets/images/signout.png'),
              //                 onPressed: () {
              //                   print('signout');
              //                 },
              //               ),
              //             ),
              //             Text(
              //               "ออกจากระบบ",
              //               style: TextStyle(
              //                 fontSize: 14,
              //               ),
              //             )
              //           ],
              //         )),
              //       ],
              //     )
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

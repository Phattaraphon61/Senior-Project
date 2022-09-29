// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:easypayeasywash/selectbank/seleckbank.dart';
import 'package:easypayeasywash/withdrawal/withdrawal.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

class Createbank extends StatefulWidget {
  Createbank(
      {Key? key,
      required this.userInfo,
      required this.bank})
      : super(key: key);
  Map<String, dynamic>? userInfo, bank;

  @override
  State<Createbank> createState() => _CreatebankState();
}

class _CreatebankState extends State<Createbank> {
  List<bool> isSelected = [true, false];
  final name = TextEditingController();
  final number = TextEditingController();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.bank != null) {
      setState(() {
        isSelected[0] = false;
        isSelected[1] = true;
      });
    }
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
                                child: Withdrawal(
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
                      "บัญชีธนาคาร",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 0.01),
                child: ToggleButtons(
                  children: <Widget>[
                    SizedBox(
                        width: width * 0.49,
                        child: Center(
                            child: Text(
                          "บัญชีของฉัน",
                          style: TextStyle(fontSize: 20),
                        ))),
                    SizedBox(
                        width: width * 0.4,
                        child: Center(
                            child: Text(
                          "สร้างบัญชี",
                          style: TextStyle(fontSize: 20),
                        ))),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      print(index);
                      for (int buttonIndex = 0;
                          buttonIndex < isSelected.length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          isSelected[buttonIndex] = true;
                        } else {
                          isSelected[buttonIndex] = false;
                        }
                      }
                    });
                  },
                  isSelected: isSelected,
                ),
              ),
              isSelected[0] == true
                  ? Column(children: [
                      for (var i in widget.userInfo!['bank']!)
                        GestureDetector(
                          onTap: () {
                            print("YES");
                            print(i);
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: Withdrawal(
                                  userInfo: widget.userInfo,
                                  bank: i,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: ListTile(
                              leading:
                                  Image.asset('assets/images/${i['bank']}.png'),
                              title: Text(i['name']),
                              subtitle: Text(
                                  'ธนาคาร${banks[i['bank']]} ' +
                                      numtostar(i['number'])),
                              trailing: Icon(Icons.navigate_next_rounded),
                            ),
                          ),
                        ),
                    ])
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          widget.bank == null
                              ? GestureDetector(
                                  onTap: () {
                                    print("YES");
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: Selectbank(
                                          userInfo: widget.userInfo,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    child: ListTile(
                                      title: Text('เลือกบัญชีธนาคาร'),
                                      // subtitle: Text('เครื่องหน้าหอ'),
                                      trailing:
                                          Icon(Icons.navigate_next_rounded),
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
                                        child: Selectbank(
                                          userInfo: widget.userInfo,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    child: ListTile(
                                      leading: Image.asset(
                                          'assets/images/${widget.bank!['engname']}.png'),
                                      title: Text(widget.bank!['thname']),
                                      // subtitle: Text('เครื่องหน้าหอ'),
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: name,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("ชื่อบัญชี"),
                                hintText: 'กรอกชื่อบัญชี',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("เลขที่บัญชี"),
                                hintText: 'กรอกเลขที่บัญชี',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
                                print("YES");
                                var client = http.Client();
                                var response = await client.post(
                                    Uri.parse(
                                        'https://server.easypayeasywash.tk/user/update'),
                                    body: {
                                      "type": "bank",
                                      "fbid": "${widget.userInfo!['fbid']}",
                                      "bank": "${widget.bank!['engname']}",
                                      "number": "${number.text}",
                                      "name": "${name.text}"
                                    });
                                client.close();
                                print(json.decode(response.body)['data']);
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

                                  if (response.isTapConfirmButton) {
                                    print(response.isTapConfirmButton);
                                    isSelected[0] = true;
                                    isSelected[1] = false;
                                  }
                                }
                                setState(() {
                                  widget.userInfo!['bank'] = json.decode(response.body)['data']['bank'];
                                      widget.bank = null;
                                      name.text = "";
                                      number.text = "";
                                });
                              },
                              child: Container(
                                // ignore: unnecessary_new
                                decoration: new BoxDecoration(
                                    color: Color.fromARGB(255, 97, 222, 253),
                                    // ignore: unnecessary_new
                                    borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(48.0),
                                        topRight: const Radius.circular(48.0),
                                        bottomLeft: const Radius.circular(48.0),
                                        bottomRight:
                                            const Radius.circular(48.0))),
                                width: width * 0.7,
                                height: height * 0.06,
                                child: Center(
                                  child: Text(
                                    "เพิ่มบัญชีธนาคาร",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

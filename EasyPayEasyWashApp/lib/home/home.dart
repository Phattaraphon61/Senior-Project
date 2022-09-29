// ignore_for_file: must_be_immutable, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:easypayeasywash/addwashing/addwashing.dart';
import 'package:easypayeasywash/history/historywithdrawal.dart';
import 'package:easypayeasywash/login/login.dart';
import 'package:easypayeasywash/noti/notification.dart';
import 'package:easypayeasywash/washinginfo/washinginfo.dart';
import 'package:easypayeasywash/withdrawal/withdrawal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? userInfo, userDatas;
  List<dynamic>? mywashing;
  String _scanBarcode = 'Unknown';
  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
      if (barcodeScanRes != "-1") {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.leftToRight,
            child: Addwashing(
              userInfo: userInfo,
              userData: userDatas,
              id: barcodeScanRes,
            ),
          ),
        );
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
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
        await FacebookAuth.instance.logOut();
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            child: Login(),
          ),
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ออกจากระบบ"),
      content: Text("กรุณายืนยันเพื่อออกจากระบบ"),
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

  getdata() async {
    if (userDatas == null) {
      var userData = await FacebookAuth.i.getUserData(
        fields: "name,email,picture.width(200)",
      );
      setState(() {
        userDatas = userData;
      });
      print("MYINFO$userInfo");
      print("MYWASHING$mywashing");
      if (userInfo == null) {
        var client = http.Client();
        var response = await client.post(
            Uri.parse('https://server.easypayeasywash.tk/user/create'),
            body: {
              'name': '${userDatas!['name']}',
              'fbid': '${userDatas!['id']}'
            });
        var responsewashing = await client.post(
            Uri.parse('https://server.easypayeasywash.tk/washing/getmywashing'),
            body: {'userid': '${json.decode(response.body)['data']['id']}'});
        client.close();
        print(json.decode(response.body)['data']);
        print(json.decode(responsewashing.body)['data']);
        setState(() {
          mywashing = json.decode(responsewashing.body)['data'];
          userInfo = json.decode(response.body)['data'];
          userInfo!['image'] = userDatas!['picture']['data']['url'];
        });
      }
    }
  }

  Future<bool> loaddata() async {
    var client = http.Client();
    try {
      if (userDatas == null) {
        var userData = await FacebookAuth.i.getUserData(
          fields: "name,email,picture.width(200)",
        );
        setState(() {
          userDatas = userData;
        });
        print("MYINFO$userInfo");
        print("MYWASHING$mywashing");
        var client = http.Client();
        var response = await client.post(
            Uri.parse('https://server.easypayeasywash.tk/user/create'),
            body: {
              'name': '${userDatas!['name']}',
              'fbid': '${userDatas!['id']}'
            });
        var responsewashing = await client.post(
            Uri.parse('https://server.easypayeasywash.tk/washing/getmywashing'),
            body: {'userid': '${json.decode(response.body)['data']['id']}'});
        print(json.decode(response.body)['data']);
        print(json.decode(responsewashing.body)['data']);
        setState(() {
          mywashing = json.decode(responsewashing.body)['data'];
          userInfo = json.decode(response.body)['data'];
          userInfo!['image'] = userDatas!['picture']['data']['url'];
        });
      }
    } finally {
      client.close();
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: loaddata(),
      builder: (c, s) {
        if (userDatas != null && userInfo != null) {
          return SafeArea(
            child: Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: new BoxDecoration(
                            color: Color.fromRGBO(84, 199, 199, 1),
                            borderRadius: new BorderRadius.only(
                                bottomLeft: const Radius.circular(48.0),
                                bottomRight: const Radius.circular(48.0))),
                        height: height * 0.3,
                      ),
                      Positioned(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Image.asset('assets/images/scan.png'),
                              tooltip: 'scan',
                              onPressed: () async {
                                print('scann');
                                scanQR();
                              },
                            ),
                            IconButton(
                                icon: const Icon(Icons.notification_important),
                                iconSize: 30,
                                tooltip: 'scan',
                                onPressed: () {
                                  print('noti');
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: MyNoti(
                                        userData: userDatas,
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                      Center(
                        child: Text(
                          "จ่ายง่ายได้ซัก",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.18),
                        child: Center(
                          child: Container(
                              width: width * 0.8,
                              height: height * 0.2,
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      new BorderRadius.all(Radius.circular(23)),
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
                                userDatas!['picture']['data']['url'],
                                fit: BoxFit.contain,
                                matchTextDirection: true,
                                height: height * 0.13,
                              )),
                              Text(
                                userDatas!['name'],
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
                          mainAxisAlignment: MainAxisAlignment
                              .spaceEvenly, //Center Row contents horizontally,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "ยอดสุทธิ",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: height * 0.01),
                                  child: Text(
                                    NumberFormat("#,###")
                                        .format(userInfo!['balance']),
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "ยอดรวม",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: height * 0.01),
                                  child: Text(
                                    NumberFormat("#,###")
                                        .format(userInfo!['total']),
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.4),
                        child: Center(
                          child: Text(
                            "เครื่องซักผ้าทั้งหมด (${mywashing!.length})",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.45),
                        child: Container(
                          height: height * 0.35,
                          child: ListView(
                              scrollDirection: Axis.vertical,
                              children: <Widget>[
                                for (var i in mywashing!)
                                  GestureDetector(
                                    onTap: () {
                                      print("YES");
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: WashingInfo(
                                            userData: userDatas,
                                            washinginfo: i,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      child: ListTile(
                                        leading: Image.asset(
                                            'assets/images/washing.png'),
                                        title: Text(i['washingid']),
                                        subtitle: Text(i['detail']),
                                        trailing:
                                            Icon(Icons.navigate_next_rounded),
                                      ),
                                    ),
                                  ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: height * 0.08,
                    decoration: new BoxDecoration(
                        color: Color.fromRGBO(84, 199, 199, 1),
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 10,
                            offset: Offset(1, 8),
                          )
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: height * 0.05,
                              child: IconButton(
                                padding: EdgeInsets.all(0.0),
                                icon: Image.asset('assets/images/history.png'),
                                onPressed: () {
                                  print("history");
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: History(
                                        userInfo: userInfo,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Text(
                              "ประวัติการถอน",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: height * 0.05,
                              child: IconButton(
                                padding: EdgeInsets.all(0.0),
                                icon:
                                    Image.asset('assets/images/withdrawal.png'),
                                onPressed: () {
                                  print("withdrawal");
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: Withdrawal(
                                        userInfo: userInfo,
                                        bank: null,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Text(
                              "ถอน",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: height * 0.05,
                              child: IconButton(
                                padding: EdgeInsets.all(0.0),
                                icon: Image.asset('assets/images/signout.png'),
                                onPressed: () async {
                                  print('signout');
                                  showAlertDialog(context);
                                },
                              ),
                            ),
                            Text(
                              "ออกจากระบบ",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
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

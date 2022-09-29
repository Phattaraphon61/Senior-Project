// ignore_for_file: prefer_const_constructors

import 'package:easypayeasywash/home/home.dart';
import 'package:easypayeasywash/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Menu extends StatefulWidget {
  Menu({Key? key, required this.userData}) : super(key: key);
  Map<String, dynamic>? userData;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String nameclass = 'หน้าหลัก';
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(nameclass),
      ),
      body:
          // nameclass == "login"? Login_Page():
          nameclass == "หน้าหลัก"
              ? Home()
              : const Login(),
      // : nameclass == "ประวัติการรักษา"
      //     ? History_Page(uid: uiduser)
      //     : nameclass == "ข้อมูลของฉัน"
      //         ? Myinfo_Page(uid: uiduser)
      //         : nameclass == "นัดหมาย"
      //             ? Appointment_Page(uid: uiduser)
      //             : nameclass == 'คิวของฉัน'
      //                 ? Queue_Page(uid: uiduser)
      //                 : LoginPage(),
      drawer: Container(
        width: width * 0.70,
        // ignore: unnecessary_new
        child: new Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                height: 180,
                color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    // Padding(
                    //     padding:
                    //         const EdgeInsets.only(top: 10, left: 165),
                    //     child: const DecoratedBox(
                    //       decoration: const BoxDecoration(
                    //           color: Colors.red,
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(10))),
                    //       child: Text('  รอตรวจสอบ  ',
                    //           style: TextStyle(
                    //               fontSize: 16, color: Colors.white)),
                    //     )),

                    Padding(
                      padding: const EdgeInsets.only(top: 60, left: 10),
                      child: ClipOval(
                          child: Image.network(
                        widget.userData!['picture']['data']['url'],
                        fit: BoxFit.contain,
                        matchTextDirection: true,
                        height: 70,
                      )),
                    ),
                    // Image.network(widget.userData!['picture']['data']['url']),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.userData!['name'],
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    )
                    // const Padding(
                    //   padding: EdgeInsets.only(top: 5, left: 10),
                    //   child: Text(
                    //     'kkkk lllll',
                    //     style:
                    //         TextStyle(fontSize: 18, color: Colors.white),
                    //   ),
                    // ),
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    nameclass = "หน้าหลัก";
                  });

                  Navigator.of(context).pop();
                },
                leading: Image.network(
                    'https://cdn.discordapp.com/attachments/834620062090133543/885763382421114880/unknown.png',
                    width: 30,
                    height: 30,
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    colorBlendMode: BlendMode.modulate),
                title: const Text(
                  "หน้าหลัก",
                  style: TextStyle(fontSize: 18),
                ),
                trailing: const Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    nameclass = "ข้อมูลของฉัน";
                  });

                  Navigator.of(context).pop();
                },
                leading: Image.network(
                    'https://cdn.discordapp.com/attachments/834620062090133543/836836380675145758/969312.png',
                    width: 30,
                    height: 30,
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    colorBlendMode: BlendMode.modulate),
                title: const Text(
                  "ข้อมูลของฉัน",
                  style: TextStyle(fontSize: 18),
                ),
                trailing: const Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    nameclass = "ประวัติการรักษา";
                  });

                  Navigator.of(context).pop();
                },
                leading: Image.network(
                    'https://media.discordapp.net/attachments/834620062090133543/836834745303826472/3601157.png',
                    width: 30,
                    height: 30,
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    colorBlendMode: BlendMode.modulate),
                title: const Text(
                  "ประวัติการรักษา",
                  style: TextStyle(fontSize: 18),
                ),
                trailing: const Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    nameclass = "นัดหมาย";
                  });

                  Navigator.of(context).pop();
                },
                leading: Image.network(
                  'https://media.discordapp.net/attachments/834620062090133543/836835672051417128/3652191.png',
                  width: 30,
                  height: 30,
                ),
                title: const Text(
                  "นัดหมาย",
                  style: TextStyle(fontSize: 18),
                ),
                trailing: const Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    nameclass = "คิวของฉัน";
                  });

                  Navigator.of(context).pop();
                },
                leading: Image.network(
                  'https://media.discordapp.net/attachments/834620062090133543/836834856531918878/3113776.png',
                  width: 30,
                  height: 30,
                ),
                title: const Text(
                  "คิวของฉัน",
                  style: TextStyle(fontSize: 18),
                ),
                trailing: const Icon(Icons.arrow_forward),
              ),
              ListTile(
                onTap: () async {
                  await FacebookAuth.instance.logOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                      (route) => false);
                },
                leading: Image.network(
                  'https://media.discordapp.net/attachments/834620062090133543/837178484370571274/logout.png',
                  width: 30,
                  height: 30,
                ),
                title: Text(
                  "ออกจากระบบ",
                  style: TextStyle(fontSize: 18, color: Colors.redAccent[700]),
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Colors.redAccent[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

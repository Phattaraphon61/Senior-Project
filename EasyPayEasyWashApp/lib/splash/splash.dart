// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

import 'package:easypayeasywash/home/home.dart';
import 'package:easypayeasywash/login/login.dart';
import 'package:easypayeasywash/menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4), () async {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      FacebookPermissions? permissions =
          await FacebookAuth.instance.permissions;
      print("uidddd...${permissions}..........");
      if (permissions != null) {
        var userData = await FacebookAuth.i.getUserData(
          fields: "name,email,picture.width(200)",
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
            (route) => false);
      }
      if (permissions == null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false);
      }
    });
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}

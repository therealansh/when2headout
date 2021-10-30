import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel/components/custombottomnav.dart';
import 'package:travel/components/navbar.dart';
import 'package:travel/screens/home/components/body.dart';
User? user;
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? res = FirebaseAuth.instance.currentUser;
    print(res!.uid);
    user = res;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context, isTransparent: true),
      body: Body(),
      bottomNavigationBar: CustomBottonNavBar(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:travel/components/custombottomnav.dart';
import 'package:travel/components/navbar.dart';
import 'package:travel/screens/home/components/body.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context, isTransparent: true),
      body: Body(),
      bottomNavigationBar: CustomBottonNavBar(),
    );
  }
}

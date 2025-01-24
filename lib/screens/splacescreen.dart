import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_app/screens/Homepage.dart';

class Splacescreen extends StatefulWidget {
  const Splacescreen({super.key});

  @override
  State<Splacescreen> createState() => _SplacescreenState();
}

class _SplacescreenState extends State<Splacescreen> {

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Homepage(),));
    },);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.brown,
          child: Center(child: Text('Movies World',style: TextStyle(fontSize: 40,fontStyle: FontStyle.italic),))),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Share extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ShareCode();
  }
}

class ShareCode extends State {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ],
      )),
    );
  }
}

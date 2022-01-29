import 'package:flutter/material.dart';
import 'package:notekeeper/screens/notedetail.dart';
import 'package:notekeeper/screens/notelist.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
return MaterialApp(title: 'Notekeeper',
debugShowCheckedModeBanner: false,
theme: ThemeData(primarySwatch: Colors.deepPurple
),home: NoteList());  }
}

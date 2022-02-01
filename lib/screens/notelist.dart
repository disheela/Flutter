import 'package:flutter/material.dart';
import 'package:notekeeper/screens/notedetail.dart';
import 'package:notekeeper/models/Note.dart';
import 'package:notekeeper/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
   List<Note>? noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if (noteList == null) {
      noteList = <Note>[];
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: getNoteListItem(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         navigateToDetailPage(Note('','',2,''),"Add Note");
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  }


  ListView getNoteListItem() {
    TextStyle? titlestyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(itemCount: count,
        itemBuilder: (BuildContext context, int position) {
      return Card(
        color: Colors.white,
        elevation: 2.0,
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor:
                  getPriorityColor(noteList![position].priority),
              child: getPriorityIcon(this.noteList![position].priority)),
          title: Text(this.noteList![position].title),
          subtitle: Text(this.noteList![position].description),
          trailing: GestureDetector(child: Icon(Icons.delete, ),
            onTap: (){deleteNote(context,this.noteList![position].id);}) ,
          onTap: () {
           navigateToDetailPage(this.noteList![position], "Edit Note");
          },
        ),
      );
    });
  }

  void navigateToDetailPage(Note note, String header) async{
   bool result=  await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, header);
    }));

   if(result==true){
     updateListView();
   }
  }

  Color getPriorityColor(int? priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow_rounded);
        break;
      case 2:
        return Icon(Icons.play_arrow_outlined);
        break;
      default:
        return Icon(Icons.play_arrow_outlined);
    }
  }

  void deleteNote(BuildContext context, int? noteId) async {
    int result = await databaseHelper.deleteNote(noteId!);
    if (result != 0)
      showSnackbar(context, "Note deleted Succcessfully");
    else
      showSnackbar(context, "Error deleting Note. Please Try Again.");

    updateListView();
  }

  void updateListView(){
    final Future<Database?> dbFuture= databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Note>> noteListFuture= databaseHelper.getNoteList();
      noteListFuture.then((notelist){
        setState(() {
          this.noteList= notelist;
          this.count= notelist.length;
        });
      });
    });
  }

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}

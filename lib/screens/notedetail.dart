import 'package:flutter/material.dart';
import 'package:notekeeper/models/Note.dart';
import 'package:notekeeper/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class NoteDetail extends StatefulWidget {
  String appBarTitle;
  Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  var _priorities = ['High', 'Low'];
  var selectedPriority = '';
  TextEditingController _txtcontrollertitle = TextEditingController();
  TextEditingController _txtDescriptioncontroller = TextEditingController();
  String appBarTitle;
  Note note;
  DatabaseHelper databaseHelper = DatabaseHelper();
  var _formKey= GlobalKey<FormState>();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedPriority = _priorities[0];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _txtcontrollertitle.text = note.title;
    _txtDescriptioncontroller.text = note.description;


    return WillPopScope(onWillPop: () {
      movetolastscreen();
      throw '';
    }
        , child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
          ),
          body:  Form(
    key: _formKey,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    // margin: EdgeInsets.all(10),
    child:Padding(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: <Widget>[
                DropdownButton(
                  items: _priorities.map((String dropDownItem) {
                    return DropdownMenuItem<String>(
                      child: Text(dropDownItem),
                      value: dropDownItem,
                    );
                  }).toList(),
                  onChanged: (String? valueSelected) {
                    setState(() {
                      selectedPriority = valueSelected!;
                      updatePriorityAsInt(selectedPriority);
                    });
                  },
                  value: getPriorityAsString(note.priority),),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    controller: _txtcontrollertitle,
                      validator: (String? value){
                        if (value == null || value.isEmpty) {
                          return 'Please enter Principal Amount.';
                        }
                      },
                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.yellow),labelText: 'Title',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.5))),
                    onChanged: (value) {
                      this.note.title = _txtcontrollertitle.text;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: TextField(
                    controller: _txtDescriptioncontroller,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.5))),
                    onChanged: (value) {
                      this.note.description = _txtDescriptioncontroller.text;
                    },
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: RaisedButton(
                                elevation: 10.0,
                                //color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  setState(() {
                                    saveDatatodatabase();
                                  });
                                },
                                child: Text("Save", textScaleFactor: 1.5,))),
                        Text("    "),
                        Expanded(
                          child: RaisedButton(
                            elevation: 10.0,
                            onPressed: () {
                              setState(() {
                                //  reset();
                              });
                            },
                            child: Text("Cancel"),
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ),
        )));
  }

  void saveDatatodatabase() async {
    int result;
    note.date = DateFormat.yMMMd().format(DateTime.now());
    //result = await databaseHelper.insertNote(note);
    if (this.note.id != null) {
      result = await databaseHelper.updateNote(note);
    } else {
      result = await databaseHelper.insertNote(note);
    }

    if (result != 0) {
      movetolastscreen();
      showAlertDialog('Status', 'Note saved successfully.');
    } else
      showAlertDialog('Status', 'Error');
  }

  void showAlertDialog(String title, String message) {
    AlertDialog dialog = AlertDialog(
        title: Text(title), content: Text(message));

    showDialog(context: context, builder: (_) => dialog);
  }

  void movetolastscreen() {
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String val){
    switch(val){
      case 'High': note.priority=1;
      break;
      case 'Low' : note.priority=2;
      break;
      default: note.priority=2;
      break;
    }
  }

  String getPriorityAsString(int val){
    String priority;
    switch(val){
      case 1:
        priority=_priorities[0];
        break;

      case 2:
        priority=_priorities[1];
        break;

      default:
        priority=_priorities[1];
      break;

    }
    return priority;
  }
}

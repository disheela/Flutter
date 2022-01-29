import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notekeeper/models/Note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{
  static DatabaseHelper? _databaseHelper;  //Singleton
  static Database? _database;

  String note_table= 'note_table';
  String colId= 'id';
  String coltitle= 'title';
  String colDesc= 'description';
  String colPriority='priority';
  String coldate= 'date';

  DatabaseHelper.createInstance();

  factory DatabaseHelper(){
    return _databaseHelper ??= DatabaseHelper.createInstance();

   /* if(_databaseHelper == null) {
      _databaseHelper = DatabaseHelper.createInstance();
    }
    return _databaseHelper;*/
  }

  //creating database
  void CreateDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $note_table($colId INTEGER PRIMARY KEY AUTOINCREMENT, $coltitle TEXT, $colDesc TEXT,$coldate TEXT, $colPriority INTEGER)' );
  }

  //getter fxn
  Future<Database?> get database async{
    if(_database==null)
      _database= await initializeDatabase();

    return _database;
  }

  Future<Database?> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    
   var notedatabase= await openDatabase(path,version: 1,onCreate: CreateDb);
    return notedatabase;
  }

  //fetch operation
  Future<List<Map<String,dynamic>>?> getNoteMapList() async{
    Database? db = await this.database;
  //  var result = await db.rawQuery('SELECT * FROM $note_table order by $colPriority Asc');
    var result = await db?.query(note_table,orderBy: '$colPriority asc');
    return result;
  }

  Future<List<Note>> getNoteList() async{
    var noteMapList = await getNoteMapList();
    int count= noteMapList!.length;
    List<Note> notelist = <Note>[];

    for(int i=0;i<count;i++){
      notelist.add(Note.fromMapObeject(noteMapList[i]));
    }
    return notelist;
  }

  //insert operation
  Future<int> insertNote(Note note) async{
    Database? db = await this.database;
    var result = await db!.insert(note_table,note.toMap());
    return result;
  }

  //Update operation
  Future<int> updateNote(Note note) async{
    Database? db = await this.database;
    var result = await db!.update(note_table,note.toMap(), where: '$colId=?', whereArgs: [note.id]);
    return result;
  }

  //Delete operation
  Future<int> deleteNote(int id) async{
    Database? db = await this.database;
    var result = await db!.delete(note_table, where: '$colId=?',whereArgs: [id]);
    return result;
  }

 /* //get count operation
  Future<int> getCount() async{
    Database db = await this.database;
    var result = await db.(note_table,note.toMap(), where: '$colId=?', whereArgs: [note.id]);
    return result;
  }*/
}
class Note {
   int? _id;
 late String _title;
 late String _description;
 late String _date;
 late int _priority;

  Note(this._title,this._date,this._priority,[this._description='']);

  Note.withId(this._id,this._date,this._priority,this._title,[this._description='']);


  int? get id => _id;

  String get title => _title;

  set title(String value) {
    if(value.length<250)
    _title = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  int get priority => _priority;

  set priority(int value) {
    if(value==1 || value==2)
    _priority = value;
  }

  Map<String,dynamic> toMap(){

    var map= <String,dynamic>{
      'title': _title,
      'description':_description,
      'priority': _priority,
      'date': _date,
    };

    if(_id!=null)
      map['id']= _id;

    return map;
  }

  Note.fromMapObeject(Map<String,dynamic> map){
    this._id=map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
    this.priority= map['priority'];

  }
}
import 'package:flutter/material.dart';

class TContact{
  int ? _id;
  String? _number;
  String? _name;

  TContact(this._number,this._name);
  TContact.withId(this._id,this._number,this._name);

  //getters
  int get id=>_id!;
  String get number=>_number!;
  String get name=>_name!;
  
  @override
    String toString(){
      return 'Contact: {id:$_id,name:$_name,number:$_number}';
    }

    //setters
    set number(String newNumber)=>this._number=newNumber;
    set name(String newNumber)=>this._name=newNumber;
    set id(int newId) => this._id = newId;  // Setter for _id


Map<String,dynamic>toMap(){
  var map=new Map<String,dynamic>();
  map['id']=this._id;
  map['number']=this._number;
  map['name']=this._name;

    return map;
}
    TContact.fromMapObject(Map<String,dynamic>map){
      this._id=map['id'];
      this._number=map['number'];
      this._name=map['name'];

    }

  static void fromMap(Map<String, dynamic> data) {}
  }

 
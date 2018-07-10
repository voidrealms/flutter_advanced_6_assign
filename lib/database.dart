import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

int counter;
DatabaseReference counterRef;
DatabaseError error;

void init(FirebaseDatabase database) async {
  counterRef = FirebaseDatabase.instance.reference().child('test/counter');
  counterRef.keepSynced(true);
  database.setPersistenceEnabled(true);
  database.setPersistenceCacheSizeBytes(10000000);
}

Future<int> getCounter() async {
  int value;
  await counterRef.once().then((DataSnapshot snapshot) {
    print('Connected to the database and read ${snapshot.value}');
    value = snapshot.value;
  });
}

Future<Null> setCounter(int value) async {
  final TransactionResult transactionResult = await counterRef.runTransaction((MutableData mutableData) async {
    mutableData.value = value;
    return mutableData;
  });

  if(transactionResult.committed) {
    print('Saved value to the database');
  } else {
    print('Failed to save to the database!');
    if(transactionResult.error != null) {
      print(transactionResult.error.message);
    }
  }
}


Future<Null> addData(String user) async {
  DatabaseReference _messageRef;
  _messageRef = FirebaseDatabase.instance.reference().child('messages/${user}');

  for(int i = 0; i < 20; i++) {
    _messageRef.update(<String,String>{'Key${i.toString()}' : 'Body ${i.toString()}'});
  }
}

Future<Null> removeData(String user) async {
  DatabaseReference _messageRef;
  _messageRef = FirebaseDatabase.instance.reference().child('messages/${user}');
  await _messageRef.remove();
}

Future<Null> setData(String user, String key, String value) async {
  DatabaseReference _messageRef;
  _messageRef = FirebaseDatabase.instance.reference().child('messages/${user}');
  _messageRef.set(<String,String>{key : value});
}

Future<Null> updateData(String user, String key, String value) async {
  DatabaseReference _messageRef;
  _messageRef = FirebaseDatabase.instance.reference().child('messages/${user}');
  _messageRef.update(<String,String>{key : value});
}

Future<String> findData(String user, String key) async {
  DatabaseReference _messageRef;
  _messageRef = FirebaseDatabase.instance.reference().child('messages/${user}');
  String value;
  Query query = _messageRef.equalTo(value, key: key);
  await query.once().then((DataSnapshot snapshot) {
    value = snapshot.value.toString();
  });

  return value;
}

Future<String> findRange(String user, String key) async {
  DatabaseReference _messageRef;
  _messageRef = FirebaseDatabase.instance.reference().child('messages/${user}');
  String value;
  Query query = _messageRef.endAt(value, key: key);
  await query.once().then((DataSnapshot snapshot) {
    value = snapshot.value.toString();
  });

  return value;
}



























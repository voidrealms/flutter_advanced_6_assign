import 'dart:io';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'auth.dart' as auth;

Future<String> upload(File file, String basename) async {

  await auth.ensureLoggedIn();
  StorageReference ref = FirebaseStorage.instance.ref().child('file/test/${basename}');
  StorageUploadTask uploadTask = ref.putFile(file);

  Uri location = (await uploadTask.future).downloadUrl;
  String name = await ref.getName();
  String bucket = await ref.getBucket();
  String path = await ref.getPath();

  print('Url: ${location.toString()}');
  print('Name: ${name}');
  print('Bucket: ${bucket}');
  print('Path: ${path}');

  return location.toString();
}

Future<String> download(Uri location) async {

  http.Response data = await http.get(location);

 return data.body;
}
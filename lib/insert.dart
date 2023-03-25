// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, camel_case_types, avoid_print, must_be_immutable, invalid_return_type_for_catch_error

import 'package:demo_firebase/viewdata.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class insert extends StatefulWidget {

  Map<String, dynamic>? data;
  String? id;
  insert({this.data, this.id});

  @override
  State<insert> createState() => _insertState();
}

class _insertState extends State<insert> {

  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    msgLoad();
    if (widget.data != null) {
      t1.text = widget.data!['name'];
      t2.text = widget.data!['phone'];
    }
  }
  msgLoad()
  {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Insert Page"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(13),
            child: TextField(
              controller: t1,
              decoration: InputDecoration(
                  hintText: "Enter Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  suffixIcon: IconButton(
                      onPressed: () {
                        t1.text = "";
                      },
                      icon: Icon(Icons.clear, color: Colors.red))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(13),
            child: TextField(
                controller: t2,
                decoration: InputDecoration(
                    hintText: "Enter Contact",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    suffixIcon: IconButton(
                        onPressed: () {
                          t2.text = "";
                        },
                        icon: Icon(Icons.clear, color: Colors.red)))),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 5),
              onPressed: () {
                String name = t1.text;
                String contact = t2.text;

                if (widget.data == null) {
                  users.add({
                        'name': name, // John Doe
                        'phone': contact, // Stokes and Sons
                      })
                      .then((value) =>
                      Fluttertoast.showToast(
                      msg: "Data Insert Successfully !",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0
                  ))
                      .catchError((error) => print("Failed to add user: $error"));
                } else {
                  users.doc(widget.id).update({
                        'name': name,
                        'phone': contact,
                      })
                      .then((value) =>  Fluttertoast.showToast(
                      msg: "Data Updated Successfully !",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0
                  ))
                      .catchError((error) => print("Failed to add user: $error"));
                }
              },
              child: Text("Insert Data")),
              ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),elevation: 5),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return viewdata();
                  },
                ));
              },
              child: Text("View Data"))
        ],
      ),
    );
  }
}

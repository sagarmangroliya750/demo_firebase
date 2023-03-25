// ignore_for_file: camel_case_types, prefer_const_constructors, unnecessary_string_interpolations, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'insert.dart';

class viewdata extends StatefulWidget {
  const viewdata({Key? key}) : super(key: key);

  @override
  State<viewdata> createState() => _viewdataState();
}

class _viewdataState extends State<viewdata> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("View Page"),centerTitle:true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              print(document.id);
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              print(data);
              return Card(
                child: ListTile(
                  title: Text(data['name']),
                  subtitle: Text(data['phone']),
                  trailing: Column(
                    children: [
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            CollectionReference users = FirebaseFirestore.instance.collection('users');
                            users.doc(document.id).delete();
                            setState(() {});
                          },
                          icon: Icon(Icons.delete,color:Colors.red.shade300),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return insert(data: data,id:document.id);
                            },));
                          },
                          icon: Icon(Icons.edit,color:Colors.blueGrey.shade400,),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
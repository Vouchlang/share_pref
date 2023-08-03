import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReltimeFirebase extends StatelessWidget {
  const ReltimeFirebase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('testingFirebase').snapshots();
    return Scaffold(
      appBar: AppBar(title: Text('Realtime Firebase'),),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return Text("Full Name: ${data['name']} ${data['Gender']}");
            }).toList(),
          );
        },
      ),
    );
  }
}

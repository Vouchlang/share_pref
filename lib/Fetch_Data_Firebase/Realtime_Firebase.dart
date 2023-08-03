import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RealtimeFirebase extends StatelessWidget {
  const RealtimeFirebase({Key? key}) : super(key: key);

  static const route = '/notification-screen';

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('testingFirebase').snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text('Realtime Firebase'),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Text("Full Name: ${data['name']} ${data['gender']}");
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

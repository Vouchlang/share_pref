import 'package:flutter/material.dart';

class SubjectDetailsScreen extends StatelessWidget {
  final String subjectName;
  final Map<String, dynamic> subjectData;

  const SubjectDetailsScreen(
      {Key? key, required this.subjectData, required this.subjectName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subject Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              subjectName, // Display the subject name here
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: subjectData['Dates'].length,
              itemBuilder: (context, index) {
                final data = subjectData['Dates'][index];
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Date: ${data['Date']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Session 1: ${data['Session 1']}'),
                      Text('Session 2: ${data['Session 2']}'),
                      Text('Session 3: ${data['Session 3']}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

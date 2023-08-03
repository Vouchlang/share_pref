import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Class/CreditClass.dart';
import '../Class/StudentUserClass.dart';

class MyPercentIndicatorScreen extends StatefulWidget {
  final List<StudentUser> data_studentUser;
  // final List<Credit> data_credit;
  const MyPercentIndicatorScreen({
    Key? key,
    required this.data_studentUser,
    // required this.data_credit,
  }) : super(key: key);

  @override
  State<MyPercentIndicatorScreen> createState() =>
      _MyPercentIndicatorScreenState();
}

class _MyPercentIndicatorScreenState extends State<MyPercentIndicatorScreen> {
  bool isLoading = false;
  late List<Credit> _dataCredit = [];

  @override
  void initState() {
    super.initState();
    // _dataCredit = widget.data_credit;
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse(
            'http://192.168.1.51/hosting_api/Test_student/st_chart_testing.php'),
        body: {
          'student_id': widget.data_studentUser[0].student_id,
          'pwd': widget.data_studentUser[0].pwd,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        setState(() {
          _dataCredit = List<Credit>.from(
              data['credit_data'].map((data) => Credit.fromJson(data)));
          isLoading = false;
        });
      } else {
        // Handle the response status code other than 200
        print('Response Status Code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    double calculatePercentIndicator() {
      if (_dataCredit.isEmpty || _dataCredit[0].totalCredit == "0") {
        return 0; // Avoid division by zero error
      }

      double yourCredit = double.parse(_dataCredit[0].yourCredit);
      double totalCredit = double.parse(_dataCredit[0].totalCredit);

      double percentIndicator = yourCredit / totalCredit;
      return percentIndicator;
    }

    double percentIndicator = calculatePercentIndicator();

    return Scaffold(
      appBar: AppBar(
        title: Text('Percent Indicator'),
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView.builder(
            itemCount: _dataCredit.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Text(
                    'Total Credit: ${_dataCredit[index].totalCredit}',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Your Credit: ${_dataCredit[index].yourCredit}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 50.0,
                    percent: percentIndicator,
                    progressColor: Colors.indigo[900],
                    animateFromLastPercent: true,
                    animation: true,
                    animationDuration: 750,
                    backgroundColor: Colors.indigo.shade100,
                    center: Text(
                      _dataCredit.isNotEmpty
                          ? '${_dataCredit[0].yourCredit} / ${_dataCredit[0].totalCredit}'
                          : 'N/A',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: 500,
                    width: 100,
                    color: Colors.amber,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

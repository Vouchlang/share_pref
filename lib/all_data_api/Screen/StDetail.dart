import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Class/StDetailClass.dart';
import '../Class/StudentUserClass.dart';
import '../Customization/customFont.dart';

class StudentDetail extends StatefulWidget {
  final List<StudentUser> data_studentUser;
  // final List<StDetail> data_stDetail;

  const StudentDetail({
    Key? key,
    // required this.data_stDetail,
    required this.data_studentUser,
  }) : super(key: key);

  @override
  State<StudentDetail> createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
  bool isLoading = false;
  late List<StDetail> _dataStudentDetail = [];

  @override
  void initState() {
    super.initState();
    // _dataStudentDetail = widget.data_stDetail;
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse(
            'http://192.168.1.51/hosting_api/Test_student/st_detail_testing.php'),
        body: {
          'student_id': widget.data_studentUser[0].student_id,
          'pwd': widget.data_studentUser[0].pwd,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        setState(() {
          _dataStudentDetail = List<StDetail>.from(
              data['user_data'].map((data) => StDetail.fromJson(data)));
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Detail'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          itemCount: _dataStudentDetail.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_dataStudentDetail[index].name_kh),
              subtitle: Text(_dataStudentDetail[index].name_en),
              trailing: buildText(_dataStudentDetail[index].date_of_birth, 24),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../Class/StudentUserClass.dart';
import '../Class/SurveyClass.dart';
import '../Customization/customFont.dart';

class Survey_Screen extends StatefulWidget {
  final List<StudentUser> data_studentUser;
  // final List<Survey_Class> data_stSurvey;

  const Survey_Screen({
    Key? key,
    // required this.data_stSurvey,
    required this.data_studentUser,
  }) : super(key: key);

  @override
  State<Survey_Screen> createState() => _SurveyState();
}

class _SurveyState extends State<Survey_Screen> {
  bool isLoading = false;
  late List<Survey_Class> _dataSurvey = [];

  @override
  void initState() {
    super.initState();
    // _dataSurvey = widget.data_stSurvey;
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse(
            'http://192.168.1.51/hosting_api/Test_Student/st_survey_testing.php'),
        body: {
          'student_id': widget.data_studentUser[0].student_id,
          'pwd': widget.data_studentUser[0].pwd,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        setState(() {
          _dataSurvey = List<Survey_Class>.from(
              data['survey_status'].map((data) => Survey_Class.fromJson(data)));
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

  final Uri urlFb = Uri.parse("https://www.facebook.com/usea.edu.kh");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Detail'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          itemCount: _dataSurvey.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: ElevatedButton(
                child: Text('Go'),
                onPressed: () {
                  launchUrl(Uri.parse(_dataSurvey[index].survey_link));
                },
              ),
              trailing: buildText(_dataSurvey[index].survey_teacher, 24),
            );
          },
        ),
      ),
    );
  }
}

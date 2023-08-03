import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Class/Class_Registration.dart';

class RegistrationUI extends StatefulWidget {
  @override
  _RegistrationUIState createState() => _RegistrationUIState();
}

class _RegistrationUIState extends State<RegistrationUI> {
  List<EducationData> educationDataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Replace this URL with your API endpoint
    String apiUrl =
        'http://192.168.1.51/hosting_api/Guest/fetch_guest_registration.php';
    try {
      http.Response response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<EducationData> data = jsonData.map((item) {
          String title = item['title'];
          List<dynamic> details = item['details'];
          List<EducationDetail> educationDetails = details.map((detail) {
            String dateTitle = detail['date_title'];
            List<dynamic> educationList = detail['education_list'];
            List<EducationItem> educationItems = educationList.map((education) {
              String educationName = education['education_name'];
              List<dynamic> infoList = education['list'];
              List<InfoList> infos = infoList.map((info) {
                String info_text = info['info'];
                return InfoList(info_text: info_text);
              }).toList();
              return EducationItem(
                  educationName: educationName, infoList: infos);
            }).toList();
            String timeTitle = detail['time_title'];
            String timeDetail = detail['time_detail'];
            return EducationDetail(
              dateTitle: dateTitle,
              educationList: educationItems,
              timeTitle: timeTitle,
              timeDetail: timeDetail,
            );
          }).toList();
          return EducationData(title: title, details: educationDetails);
        }).toList();

        setState(() {
          educationDataList = data;
        });
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Education Data'),
      ),
      body: ListView.builder(
        itemCount: educationDataList.length,
        itemBuilder: (context, index) {
          final educationData = educationDataList[index];
          return Column(
            children: [
              Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text(educationData.title)),
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: educationData.details.length,
                itemBuilder: (context, detailIndex) {
                  final details = educationData.details[detailIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(details.dateTitle,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      for (var educationItem in details.educationList)
                        Column(
                          children: [
                            Text(educationItem.educationName),
                            for (var info in educationItem.infoList)
                              Column(
                                children: [Text(info.info_text)],
                              ),
                          ],
                        ),
                      Text(details.timeTitle,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(details.timeDetail),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

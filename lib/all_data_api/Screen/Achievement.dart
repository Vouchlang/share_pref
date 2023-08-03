import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Class/AchievementClass.dart';
import '../Class/StudentUserClass.dart';

class Achievement extends StatefulWidget {
  final List<StudentUser> data_studentUser;

  Achievement({
    Key? key,
    required this.data_studentUser,
  }) : super(key: key);

  @override
  State<Achievement> createState() => _AchievementState();
}

class _AchievementState extends State<Achievement> {
  bool isLoading = false;
  AchievementData? _achievementData;
  int _selectedAchievementTypeIndex = 0;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse(
            'http://192.168.1.51/hosting_api/Test_student/st_achievement_testing.php'),
        body: {
          'student_id': widget.data_studentUser[0].student_id,
          'pwd': widget.data_studentUser[0].pwd,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          _achievementData = AchievementData.fromJson(jsonData);
          isLoading = false;
        });
      } else {
        // Handle error when fetching data
        print(
            'Failed to fetch achievements. Status Code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Failed to fetch achievements: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Achievements'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // Show a loading indicator while fetching data
            : _achievementData != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Achievement Types',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _achievementData!.achievementData.length,
                          itemBuilder: (context, index) {
                            final achievementTypeData =
                                _achievementData!.achievementData[index];
                            final isSelected =
                                _selectedAchievementTypeIndex == index;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedAchievementTypeIndex = index;
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected ? Colors.blue : Colors.grey,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      achievementTypeData.achievementType,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Achievements',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns in the grid
                            crossAxisSpacing: 8.0, // Spacing between columns
                            mainAxisSpacing: 8.0, // Spacing between rows
                          ),
                          itemCount: _selectedAchievementTypeIndex >= 0
                              ? _achievementData!
                                  .achievementData[
                                      _selectedAchievementTypeIndex]
                                  .data
                                  .length
                              : 0,
                          itemBuilder: (context, index) {
                            return Image.network(
                              _achievementData!
                                  .achievementData[
                                      _selectedAchievementTypeIndex]
                                  .data[index]
                                  .image,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Text('Failed to fetch achievements.'),
      ),
    );
  }
}

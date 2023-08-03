import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_pref/social/UI/Social.dart';
import 'Registration/UI/Regirstration.dart';
import 'all_data_api/HomePage.dart';
import 'image_slide/UI/ImageSlide.dart';

class First extends StatefulWidget {
  const First({Key? key}) : super(key: key);

  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('First'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.to(MyHomePage());
              },
              child: Text('MyHomePage'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(RegistrationUI());
              },
              child: Text('Registration'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(Image_Slideshow());
              },
              child: Text('Image'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(SocialUI());
              },
              child: Text('Social'),
            ),
          ],
        ),
      ),
    );
  }
}

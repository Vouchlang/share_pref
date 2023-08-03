import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Class/Class_Social.dart';

class SocialUI extends StatefulWidget {
  const SocialUI({super.key});

  @override
  State<SocialUI> createState() => _SocialUIState();
}

class _SocialUIState extends State<SocialUI> {
  late List<Class_Social> social = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getSocialData();
  }

  Future<void> getSocialData() async {
    try {
      var res = await http.get(
        Uri.parse(
            "http://192.168.1.51/hosting_api/Guest/fetch_guest_social.php"),
      );
      var r = json.decode(res.body);
      if (r is List<dynamic>) {
        setState(() {
          social = r.map((e) => Class_Social.fromJson(e)).toList();
        });
      } else {
        setState(() {
          social = [Class_Social.fromJson(r)];
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      // handle the error here
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Social'),
        ),
        body: Card(
          elevation: 2,
          shadowColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: social.map((item) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      launchUrl(Uri.parse(item.link_url));
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20,
                      child: Image.network(
                        item.image_url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ));
  }
}

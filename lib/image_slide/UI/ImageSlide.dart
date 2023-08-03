import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../Class/Class_ImageSlide.dart';

class Image_Slideshow extends StatefulWidget {
  const Image_Slideshow({super.key});

  @override
  State<Image_Slideshow> createState() => _Image_SlideshowState();
}

class _Image_SlideshowState extends State<Image_Slideshow> {
  late List<Class_Image> image_slides = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      var res = await http.get(
        Uri.parse(
            "http://192.168.1.51/hosting_api/Guest/fetch_guest_image_slideshow.php"),
      );
      var r = json.decode(res.body);
      if (r is List<dynamic>) {
        setState(() {
          image_slides = r.map((e) => Class_Image.fromJson(e)).toList();
        });
      } else {
        setState(() {
          image_slides = [Class_Image.fromJson(r)];
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

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget buildImage(String image_slide, int index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              // Change this line to use Image.network
              image_slide,
              fit: BoxFit.cover,
            ),
          ),
        );

    Widget buildIndicator() => AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: image_slides.length,
          effect: WormEffect(
            activeDotColor: Colors.indigo,
            dotColor: Colors.grey,
            dotHeight: 8,
            dotWidth: 8,
          ),
        );
    return Scaffold(
      appBar: AppBar(title: Text('Image')),
      body: Container(
        height: 175,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
        child: isLoading
            ? CircularProgressIndicator() // Show a loading indicator while fetching data
            : CarouselSlider.builder(
                options: CarouselOptions(
                  height: double.infinity,
                  pageSnapping: true,
                  enableInfiniteScroll: true,
                  autoPlayInterval: Duration(seconds: 3),
                  viewportFraction: 1,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                  onPageChanged: ((index, reason) =>
                      setState(() => activeIndex = index)),
                ),
                itemCount: image_slides.length,
                itemBuilder: (context, index, realIndex) {
                  if (index >= 0 && index < image_slides.length) {
                    final image_slide = image_slides[index].image_url;
                    return buildImage(image_slide, index);
                  } else {
                    return buildImage("fallback_image_path", index);
                  }
                },
              ),
      ),
    );
  }
}

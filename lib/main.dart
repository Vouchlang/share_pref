import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_pref/Fetch_Data_Firebase/firebase_api.dart';
import 'Fetch_Data_Firebase/Realtime_Firebase.dart';
import 'First.dart';
import 'package:firebase_core/firebase_core.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: First(),
      routes: {RealtimeFirebase.route: (context) => const RealtimeFirebase()},
    );
  }
}

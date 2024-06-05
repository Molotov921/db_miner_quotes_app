import 'package:db_miner_quotes_app/views/home/homepage.dart';
import 'package:db_miner_quotes_app/views/splash/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/Splash',
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page: () => Homepage()),
        GetPage(name: '/Splash', page: () => const SplashScreen()),
      ],
    );
  }
}

import 'package:aarogya_app/home_page.dart';
import 'package:aarogya_app/utils/routes.dart';
import 'package:flutter/material.dart';

import 'pages/start_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aarogya.ai',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: MyRoutes.startRoute,
      routes: {
        "/": (context) => StartPage(),
        MyRoutes.HomeRoute: (context) => MyHomePage(
              title: 'Aarogya.ai',
            ),
        MyRoutes.startRoute: (context) => StartPage(),
      },
    );
  }
}

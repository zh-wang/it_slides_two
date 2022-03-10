import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:it_slides_two/routes/puzzle_route.dart';

void main() {
  var targetPlatform = defaultTargetPlatform;
  if (targetPlatform == TargetPlatform.macOS
      || targetPlatform == TargetPlatform.linux
      || targetPlatform == TargetPlatform.windows) {
    // TODO
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.

        // primarySwatch: Colors.lime,
        // primaryColor: primaryColor

        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),

      ),
      home: const PuzzlePage(),
      // home: const TopPage(),
    );
  }
}


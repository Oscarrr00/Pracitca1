import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shazam/favorites_page.dart';
import 'package:shazam/home_page.dart';
import 'package:shazam/provider/provider_music.dart';

void main() => runApp(
      ChangeNotifierProvider<Provide_Music>(
        create: (context) => Provide_Music(),
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
      ),
      title: 'FindTrackApp',
      home: HomePage(context2: context),
    );
  }
}

import 'package:flutter/material.dart';
import 'screens/mergeGame.dart';
import 'screens/mainMenu.dart';
import './providers/appPoints.dart';
import 'package:provider/provider.dart'; // Добавьте этот импорт

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppPointsProviders(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Merger',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      //  home: MaterialApp(home: StartPage()),
      home: MaterialApp(home: MergeGame()),
    );
  }
}

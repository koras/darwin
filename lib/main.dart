import 'package:flutter/material.dart';
import 'screens/mergeGame.dart';
import 'screens/mainMenu.dart';
import './providers/appPoints.dart';
import 'package:provider/provider.dart'; // Добавьте этот импорт
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './bloc/level_bloc.dart';

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
    return BlocProvider(
      create: (context) => LevelBloc(),
      child: MaterialApp(
        title: 'Merger',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),

        //    home: MaterialApp(home: StartPage()),
        home: MaterialApp(home: MergeGame()),
      ),
    );
  }
}

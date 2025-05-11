import 'package:flutter/material.dart';
import 'screens/mergeGame.dart';

import './providers/appPoints.dart';
import 'package:provider/provider.dart'; // Добавьте этот импорт

import 'package:flutter_bloc/flutter_bloc.dart';

//import '../models/game_item.dart';
import '../bloc/level_bloc.dart';
import './services/hive_service.dart';

import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Инициализация Hive
  await Hive.initFlutter();
  // Регистрация адаптеров
  //  Hive.registerAdapter(GameItemAdapter());
  Hive.registerAdapter(LevelStateAdapter());

  // Открытие бокса для сохранения состояния
  await Hive.openBox<LevelState>('gameState');

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

/// Логика подсказок.
/// 
/// Для прохождения уровня необходимо определённое количество подсказок, но не менее 3
/// Первые 10 подсказок бесплатны.
/// На каждыю уровень доступно 3 подсказки 
/// Следующий бесплатная подсказка доступна через 3 часа.
/// Если игрок нашёл совпадение которое есть в подсказке, то такая подсказка снимается или помечается как открытая.
/// возможно купить подсказки 1,3,5,10,20
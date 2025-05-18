import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'providers/appService.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:darwin/l10n/app_localizations.dart';

import 'package:darwin/bloc/level_bloc.dart';
import 'package:darwin/services/hive_service.dart';
import 'package:darwin/screens/mergeGame.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Новый импорт

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Hive
  await HiveService.init();

  // Открытие бокса для сохранения состояния
  await Hive.openBox<LevelState>('gameState');

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppLevelProviders(),
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
        localizationsDelegates: const [
        //  AppLocalizations.delegate, // Из flutter_gen
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // Английский
          Locale('ru'), // Русский
        ],
        //    home: MaterialApp(home: StartPage()),
        home: MaterialApp(home: MergeGame()),
      ),
    );
  }
}

// Логика подсказок.
// 
// Для прохождения уровня необходимо определённое количество подсказок, но не менее 3
// Первые 10 подсказок бесплатны.
// На каждыю уровень доступно 3 подсказки 
// Следующий бесплатная подсказка доступна через 3 часа.
// Если игрок нашёл совпадение которое есть в подсказке, то такая подсказка снимается или помечается как открытая.
// возможно купить подсказки 1,3,5,10,20
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'providers/appService.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darwin/data/levels_repository.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:darwin/gen_l10n/app_localizations.dart'; // Основной импорт

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:darwin/bloc/level_bloc.dart';
import 'package:darwin/services/hive_service.dart';
import 'package:darwin/screens/mergeGame.dart';
import 'package:darwin/screens/settings.dart';
import 'package:darwin/screens/main_menu.dart';
import 'package:flutter/foundation.dart'; // Добавьте эту строку
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируем In-App Purchase
  if (kIsWeb) {
    debugPrint('In-App Purchases are not supported on web platform');
  } else {
    await InAppPurchase.instance.isAvailable();
  }
  // Инициализация Hive
  await Hive.initFlutter();
  // Открытие бокса для сохранения состояния
  await Hive.openBox<LevelState>('gameState');

  // Уменьшаем уровень логов
  runApp(const MyApp());
}

//const MyApp({super.key});
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  late Box<LevelState> _settingsBox;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();

    // Очистка старых данных (раскомментируйте если нужно)
    //  await Hive.deleteBoxFromDisk('settings');
    //  await Hive.deleteBoxFromDisk('gameState');

    Hive.registerAdapter(LevelStateAdapter());
    Hive.registerAdapter(HintsStateAdapter());
    _settingsBox = await Hive.openBox<LevelState>('settings');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LevelBloc(),
      child: Builder(
        builder: (context) {
          return BlocBuilder<LevelBloc, LevelState>(
            builder: (context, state) {
              return MaterialApp(
                title: 'Merger',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.deepPurple,
                  ),
                ),
                locale: context.select((LevelBloc bloc) => bloc.state.locale),
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                home: BlocProvider(
                  create: (context) => LevelBloc(),
                  child: Builder(
                    builder: (context) {
                      LevelsRepository.initialize(context);
                      return MainMenu();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _settingsBox.close();
    super.dispose();
  }
}

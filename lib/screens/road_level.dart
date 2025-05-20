import 'package:flutter/material.dart';
import 'dart:ui' as ui;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Прогресс уровней',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LevelProgressScreen(),
    );
  }
}

class Level {
  final int id;
  final String name;
  final String imageAsset;
  final bool isCompleted;
  bool isCurrent;

  Level({
    required this.id,
    required this.name,
    required this.imageAsset,
    this.isCompleted = false,
    this.isCurrent = false,
  });
}

class LevelProgressScreen extends StatefulWidget {
  const LevelProgressScreen({super.key});

  @override
  State<LevelProgressScreen> createState() => _LevelProgressScreenState();
}

class _LevelProgressScreenState extends State<LevelProgressScreen> {
  final ScrollController _scrollController = ScrollController();
  final double _levelHeight = 100.0;

  List<Level> levels = [
    Level(id: 11, name: "Начало", imageAsset: "level/level1.png"),
    Level(id: 12, name: "Практика", imageAsset: "level/level2.png"),
    Level(id: 9, name: "Начало", imageAsset: "level/level1.png"),
    Level(id: 8, name: "Практика", imageAsset: "level/level2.png"),
    Level(id: 7, name: "Начало", imageAsset: "level/level1.png"),
    Level(id: 6, name: "Практика", imageAsset: "level/level2.png"),
    Level(id: 5, name: "Начало", imageAsset: "level/level1.png"),
    Level(id: 4, name: "Практика", imageAsset: "level/level2.png"),
    Level(
      id: 3,
      name: "Продвинутый",
      imageAsset: "level/level3.png",
      isCurrent: true,
    ),
    Level(
      id: 2,
      name: "Эксперт",
      imageAsset: "level/level4.png",
      isCompleted: true,
    ),
    Level(
      id: 1,
      name: "Финальный уровень",
      imageAsset: "level/level5.png",
      isCompleted: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentLevel();
    });
  }

  void _scrollToCurrentLevel() {
    final currentIndex = levels.indexWhere((level) => level.isCurrent);
    if (currentIndex != -1) {
      final offset = currentIndex * _levelHeight - 100;
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final totalHeight = levels.length * _levelHeight;

    return Scaffold(
      appBar: AppBar(title: const Text('Мой прогресс')),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: totalHeight,
          child: Stack(
            children: [
              // Уровни (непройденные сверху, пройденные снизу)
              Column(
                children:
                    levels.map((level) {
                      return _LevelCard(
                        level: level,
                        screenWidth: screenWidth,
                        levelHeight: _levelHeight,
                      );
                    }).toList(),
              ),

              // Яркая синяя дорожка поверх картинок
              Positioned(
                left: 30,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 8,
                  decoration: BoxDecoration(
                    color: Colors.blue[700]!.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),

              // Кружки-индикаторы на дорожке
              ...levels.asMap().entries.map((entry) {
                final index = entry.key;
                final level = entry.value;
                return Positioned(
                  left: 22,
                  top: index * _levelHeight + _levelHeight / 2 - 15,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color:
                          level.isCompleted
                              ? Colors.green[400]
                              : level.isCurrent
                              ? Colors.blue[400]
                              : Colors.grey[400],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final Level level;
  final double screenWidth;
  final double levelHeight;

  const _LevelCard({
    required this.level,
    required this.screenWidth,
    required this.levelHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth,
      height: levelHeight,
      child: Stack(
        children: [
          // Фоновое изображение с прозрачностью
          Opacity(
            opacity: 0.2, // Уменьшаем яркость картинки
            child: Container(
              width: screenWidth,
              height: levelHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(level.imageAsset),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),

          // Дополнительное затемнение для непройденных уровней
          if (!level.isCompleted && !level.isCurrent)
            Container(color: Colors.black.withOpacity(0.1)),

          // Блюр для непройденных уровней
          if (!level.isCompleted && !level.isCurrent)
            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(color: Colors.transparent),
            ),

          // Контент уровня
          Padding(
            padding: const EdgeInsets.only(left: 70, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  level.name,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 53, 53, 53),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (level.isCompleted)
                  // const Text(
                  //   "Пройдено",
                  //   style: TextStyle(
                  //     color: Color.fromARGB(122, 59, 59, 59),
                  //     fontSize: 16,
                  //     shadows: [
                  //       Shadow(
                  //         color: Colors.black,
                  //         blurRadius: 5,
                  //         offset: Offset(1, 1),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  if (level.isCurrent)
                    const Text(
                      "Текущий уровень",
                      style: TextStyle(
                        color: Color.fromARGB(255, 80, 255, 64),
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 5,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

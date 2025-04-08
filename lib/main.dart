import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MaterialApp(home: MergeGame()),
    );
  }
}

ImageItem? findImageById(String id) {
  return allImages.firstWhere((image) => image.id == id);
}

String? getMergeResult(String firstId, String secondId) {
  // Проверяем правила в обоих направлениях (A+B и B+A)
  final rule = mergeRules.firstWhereOrNull(
    (rule) =>
        (rule.firstImageId == firstId && rule.secondImageId == secondId) ||
        (rule.firstImageId == secondId && rule.secondImageId == firstId),
  );
  return rule?.resultImageId;
}

class MergeGame extends StatefulWidget {
  @override
  _MergeGameState createState() => _MergeGameState();
}

class _MergeGameState extends State<MergeGame> {
  // Выбранные картинки для игры (например, 3 из всех)
  late List<ImageItem> gameImages;

  // Позиции и видимость
  final Map<String, Offset> positions = {};
  final Map<String, bool> isVisible = {};
  String? resultImageId;

  @override
  void initState() {
    super.initState();
    // Выбираем случайные картинки для уровня
    gameImages = [...allImages.take(3)]; // Берём первые 3 для примера

    // Инициализируем позиции и видимость
    for (var i = 0; i < gameImages.length; i++) {
      final img = gameImages[i];
      positions[img.id] = Offset(100 + i * 150, 200);
      isVisible[img.id] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Рисуем все видимые картинки
          for (final img in gameImages)
            if (isVisible[img.id]!)
              Positioned(
                left: positions[img.id]!.dx,
                top: positions[img.id]!.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      positions[img.id] = positions[img.id]! + details.delta;
                      checkCollisions();
                    });
                  },
                  child: Image.asset(img.assetPath, width: 100, height: 100),
                ),
              ),

          // Результат слияния (если есть)
          if (resultImageId != null)
            Positioned(
              left: _getCenterX(),
              top: _getCenterY(),
              child: Image.asset(
                findImageById(resultImageId!)!.assetPath,
                width: 50,
                height: 50,
              ),
            ),
        ],
      ),
    );
  }

  void checkCollisions() {
    final visibleImages =
        gameImages.where((img) => isVisible[img.id]!).toList();

    // Проверяем все пары
    for (int i = 0; i < visibleImages.length; i++) {
      for (int j = i + 1; j < visibleImages.length; j++) {
        final img1 = visibleImages[i];
        final img2 = visibleImages[j];

        final distance = (positions[img1.id]! - positions[img2.id]!).distance;

        if (distance < 100) {
          // Дистанция для слияния
          final resultId = getMergeResult(img1.id, img2.id);
          if (resultId != null) {
            setState(() {
              isVisible[img1.id] = false;
              isVisible[img2.id] = false;
              resultImageId = resultId;
            });
            return;
          }
        }
      }
    }
  }

  double _getCenterX() {
    final visible = gameImages.where((img) => !isVisible[img.id]!);
    if (visible.length != 2) return 200;
    return (positions[visible.first.id]!.dx + positions[visible.last.id]!.dx) /
        2;
  }

  double _getCenterY() {
    final visible = gameImages.where((img) => !isVisible[img.id]!);
    if (visible.length != 2) return 300;
    return (positions[visible.first.id]!.dy + positions[visible.last.id]!.dy) /
        2;
  }
}

final List<ImageItem> allImages = [
  ImageItem('apple', 'assets/images/apple.png'),
  ImageItem('banana', 'assets/images/banana.png'),
  ImageItem('orange', 'assets/images/orange.png'),
  ImageItem('fruit_basket', 'assets/images/fruit_basket.png'),
  ImageItem('smoothie', 'assets/images/smoothie.png'),
];

final List<MergeRule> mergeRules = [
  MergeRule('apple', 'banana', 'fruit_basket'),
  MergeRule('banana', 'orange', 'smoothie'),
];

class ImageItem {
  final String id;
  final String assetPath;

  ImageItem(this.id, this.assetPath);
}

class MergeRule {
  final String firstImageId;
  final String secondImageId;
  final String resultImageId;

  MergeRule(this.firstImageId, this.secondImageId, this.resultImageId);
}

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
  double _toolboxHeightPercentage = 0.3; // Начальная высота панели (30% экрана)

  // Геттер для вычисления высоты игрового поля
  double get _gameAreaHeight =>
      MediaQuery.of(context).size.height * _gameAreaPercentage;

  // Геттер для высоты панели инструментов
  double get _toolboxHeight =>
      MediaQuery.of(context).size.height * (1 - _gameAreaPercentage);

  // double _gameAreaHeight = 400; // Высота игрового поля (можно менять)
  // final List<ImageItem> _selectedImages = []; // Картинки на игровом поле
  //final List<ImageItem> _toolboxImages = []; // Картинки в панели инструментов

  double _gameAreaPercentage = 0.7; // Начальная высота (70%)
  final List<ImageItem> _selectedImages = [];
  final List<ImageItem> _toolboxImages = allImages.take(5).toList();

  // Выбранные картинки для игры (например, 3 из всех)
  late List<ImageItem> gameImages;

  // Позиции и видимость
  final Map<String, Offset> positions = {};
  final Map<String, bool> isVisible = {};
  String? resultImageId;

  @override
  void initState() {
    super.initState();

    // Заполняем панель инструментов (например, первые 5 картинок)
    _toolboxImages.addAll(allImages.take(5));

    // // Выбираем случайные картинки для уровня
    // gameImages = [...allImages.take(3)]; // Берём первые 3 для примера

    // // Инициализируем позиции и видимость
    // for (var i = 0; i < gameImages.length; i++) {
    //   final img = gameImages[i];
    //   positions[img.id] = Offset(100 + i * 150, 200);
    //   isVisible[img.id] = true;
    // }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final toolboxHeight = screenHeight * _toolboxHeightPercentage;
    final itemSize =
        MediaQuery.of(context).size.width / 4 -
        12; // 4 элемента в ряд с отступами

    // final gameAreaHeight = screenHeight * _gameAreaPercentage;
    // final toolboxHeight = screenHeight * (1 - _gameAreaPercentage);
    // Widget _buildDraggableImage(ImageItem img) {
    //   return Positioned(
    //     left: img.position.dx,
    //     top: img.position.dy,
    //     child: GestureDetector(
    //       onPanUpdate: (details) {
    //         setState(() => img.position += details.delta);
    //       },
    //       child: Image.asset(img.assetPath, width: 80, height: 80),
    //     ),
    //   );
    // }

    return Scaffold(
      body: Column(
        children: [
          // Основное игровое поле (автоматически занимает оставшееся пространство)
          // Expanded(
          //   child: Container(
          //     color: Colors.grey[200],
          //     child: Stack(
          //       children:
          //           _selectedImages
          //               .map((img) => _buildDraggableImage(img))
          //               .toList(),
          //     ),
          //   ),
          // ),
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Center(child: Text("Игровая зона")),
            ),
          ),
          // Панель инструментов (статичные картинки)

          // Нижняя панель с ручкой для растягивания
          // Нижняя панель
          SizedBox(
            height: toolboxHeight,
            child: Column(
              children: [
                // Полоса для растягивания
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      _toolboxHeightPercentage -=
                          details.delta.dy / screenHeight;
                      _toolboxHeightPercentage = _toolboxHeightPercentage.clamp(
                        0.15,
                        0.4,
                      );
                    });
                  },
                  child: Container(
                    height: 24,
                    color: Colors.blueGrey[300],
                    child: Center(
                      child: Container(
                        width: 60,
                        height: 4,
                        color: Colors.blueGrey[500],
                      ),
                    ),
                  ),
                ),

                // Скроллируемая область с фиксированными элементами
                Expanded(
                  child: Container(
                    color: Colors.blueGrey[100],
                    child: GridView.builder(
                      padding: EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // 4 элемента в ряд
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1, // Квадратные элементы
                      ),
                      itemCount: _toolboxImages.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: itemSize,
                          height: itemSize,
                          child: _buildToolboxItem(
                            _toolboxImages[index],
                            itemSize,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildToolboxPanel(BuildContext context, double size) {
  //   return SizedBox(
  //     height: height,
  //     child: Column(
  //       children: [
  //         // Верхняя полоса для растягивания
  //         _buildDragHandle(),

  //         // Скроллируемая область с элементами
  //         Expanded(
  //           child: Container(
  //             color: Colors.blueGrey[100],
  //             child: GridView.builder(
  //               padding: EdgeInsets.all(8),
  //               scrollDirection: Axis.horizontal,
  //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                 crossAxisCount: 2,
  //                 mainAxisSpacing: 8,
  //                 crossAxisSpacing: 8,
  //                 childAspectRatio: 1,
  //               ),
  //               itemCount: _toolboxImages.length,
  //               itemBuilder: (context, index) {
  //                 return _buildToolboxItem(_toolboxImages[index], itemSize);
  //               },
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDragHandle() {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          final screenHeight = MediaQuery.of(context).size.height;
          _toolboxHeightPercentage -= details.delta.dy / screenHeight;
          _toolboxHeightPercentage = _toolboxHeightPercentage.clamp(0.15, 0.7);
        });
      },
      child: Container(
        height: 24,
        color: Colors.blueGrey[300],
        child: Center(
          child: Container(width: 60, height: 4, color: Colors.blueGrey[500]),
        ),
      ),
    );
  }
  // Полоса для растягивания

  Widget _buildToolboxItem(ImageItem imgItem, double size) {
    return GestureDetector(
      onTap: () => print("Добавлен ${imgItem.id}"), // Замените на вашу логику
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 1),
          ],
        ), // Добавлена закрывающая скобка

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Картинка (занимает большую часть пространства)
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  imgItem.assetPath,
                  fit: BoxFit.contain,
                  width: size - 20,
                  height: size - 20,
                ),
              ),
            ),

            // Текстовая подпись
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                imgItem.slug, // Преобразуем item_1 в "item 1"
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addImageToGameField(ImageItem img) {
    setState(() {
      _selectedImages.add(
        ImageItem(
          img.id,
          img.id,
          img.assetPath,
          position: Offset(
            MediaQuery.of(context).size.width / 2 - 40,
            _gameAreaHeight / 2 - 40,
          ),
        ),
      );
    });
  }

  void _updateImagePosition(String id, Offset newPosition) {
    setState(() {
      final img = _selectedImages.firstWhere((img) => img.id == id);
      img.position = newPosition;
    });
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
  ImageItem('apple', 'apple', 'assets/images/apple.png'),
  ImageItem('banana', 'banana', 'assets/images/banana.png'),
  ImageItem('orange', 'orange', 'assets/images/orange.png'),
  ImageItem('fruit_basket', 'fruit_basket', 'assets/images/fruit_basket.png'),
  ImageItem('smoothie', 'smoothie', 'assets/images/smoothie.png'),
];

final List<MergeRule> mergeRules = [
  MergeRule('apple', 'banana', 'fruit_basket'),
  MergeRule('banana', 'orange', 'smoothie'),
];

class ImageItem {
  final String id;
  final String slug;
  final String assetPath;
  Offset position;
  ImageItem(this.id, this.slug, this.assetPath, {this.position = Offset.zero});
}

class MergeRule {
  final String firstImageId;
  final String secondImageId;
  final String resultImageId;

  MergeRule(this.firstImageId, this.secondImageId, this.resultImageId);
}

class DraggableImage extends StatelessWidget {
  final ImageItem image;
  final Function(Offset) onDragEnd;

  const DraggableImage({required this.image, required this.onDragEnd});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: image.position.dx,
      top: image.position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          onDragEnd(image.position + details.delta);
        },
        child: Image.asset(image.assetPath, width: 80, height: 80),
      ),
    );
  }
}
